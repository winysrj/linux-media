Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1Jcvcf-00044M-Px
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 05:46:26 +0100
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 22 Mar 2008 05:45:22 +0100
References: <47E45138.1030107@googlemail.com>
In-Reply-To: <47E45138.1030107@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803220545.23147@orion.escape-edv.de>
Subject: Re: [linux-dvb] [PATCH] 2/3: implement DMX_SET_BUFFER_SIZE for dvr
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Andrea wrote:
> This patch implements the ioctl DMX_SET_BUFFER_SIZE for the dvr.
> =

> The ioctl used to be supported but not yet implemented.
> =

> The way it works is that it replaces the ringbuffer with a new one.
> Beforehand it flushes the old buffer.
> This means that part of the stream is lost, and reading errors (like over=
flow) are cleaned.
> The flushing is not a problem since this operation usually occurs at begi=
nning before start reading.
> =

> Since the dvr is *always* up and running this change has to be done while=
 the buffer is written:
> =

> 1) On the userspace side, it is as safe as dvb_dvr_read is now:
> 	- dvb_dvr_set_buffer_size locks the mutex
> 	- dvb_dvr_read does *not* lock the mutex (the code is there commented ou=
t)
> =

> So as long as one does not call read simultaneously it works properly.
> Maybe the mutex should be enforced in dvb_dvr_read.
> =

> 2) On the kernel side
> The only thing I am not 100% sure about is whether the spin_lock I've use=
d is enough to guarantee
> synchronization between the new function dvb_dvr_set_buffer_size (which u=
ses spin_lock_irq) and
> dvb_dmxdev_ts_callback and dvb_dmxdev_section_callback (using spin_lock).
> But this looks to me the same as all other functions do.

Please see my other mail, too

>=A0=A0=A0=A0=A0=A0=A0spin_lock(&dmxdev->lock);
>=A0=A0=A0=A0=A0=A0=A0mem =3D buf->data;
>=A0=A0=A0=A0=A0=A0=A0buf->data =3D NULL;
>=A0=A0=A0=A0=A0=A0=A0buf->size =3D size;
>=A0=A0=A0=A0=A0=A0=A0dvb_ringbuffer_flush(buf);
>=A0=A0=A0=A0=A0=A0=A0spin_unlock(&dmxdev->lock);
>=A0=A0=A0=A0=A0=A0=A0vfree(mem);
>
>=A0=A0=A0=A0=A0=A0=A0if (buf->size) {
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mem =3D vmalloc(dmxdev->dvr_b=
uffer.size);
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!mem)
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0retur=
n -ENOMEM;
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0spin_lock(&dmxdev->lock);
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0buf->data =3D mem;
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0spin_unlock(&dmxdev->lock);
>=A0=A0=A0=A0=A0=A0=A0}

I see some problems here:
- Do not release the lock before the ringbuffer is consistent again.
- We should not free the old buffer before we got a new one.
- As the ring buffer can be written from an ISR, we have to use
  spin_lock_irqsave/spin_unlock_irqrestore here.

What about this fragment:
	...
	if (!size)
		return -EINVAL;

	mem =3D vmalloc(size);
	if (!mem)
		return -ENOMEM;

	mem2 =3D buf->data;

        spin_lock_irqsave(&dmxdev->lock);
        buf->pread =3D buf->pwrite =3D 0;
	buf->data =3D mem;
	buf->size =3D size;
	spin_unlock_irqrestore(&dmxdev->lock);

	vfree(mem2);
	return 0;

Any comemnts? I hope that someone else also has a look at this because
I don't have much time atm.

CU
Oliver

-- =

----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
