Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JkTjy-0002A5-U5
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 02:37:12 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 12 Apr 2008 02:35:52 +0200
References: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
	<47E813C7.6070208@googlemail.com>
In-Reply-To: <47E813C7.6070208@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804120235.52939@orion.escape-edv.de>
Cc: Andrea <mariofutire@googlemail.com>
Subject: Re: [linux-dvb] [PATCH] 2/3: implement DMX_SET_BUFFER_SIZE for dvr
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Andrea wrote:
> linux-dvb-request@linuxtv.org wrote:
huh?

>  > What about this fragment:
>  > 	...
>  > 	if (!size)
>  > 		return -EINVAL;
>  >
>  > 	mem = vmalloc(size);
>  > 	if (!mem)
>  > 		return -ENOMEM;
>  >
>  > 	mem2 = buf->data;
>  >
>  >       spin_lock_irqsave(&dmxdev->lock);
>  >       buf->pread = buf->pwrite = 0;
>  > 	buf->data = mem;
>  > 	buf->size = size;
>  > 	spin_unlock_irqrestore(&dmxdev->lock);
>  >
>  > 	vfree(mem2);
>  > 	return 0;
> 
> Maybe I can think of one reason while the current code is not implemented this way:
> 
> In your version the new buffer is allocated before the old one is released.

Yes, this is intentional. See below.

> In the current implementation the old buffer is released and afterwards the new one allocated.
> 
> One could argue that the new implementation has a maximum memory requirement higher than the old one.
> It's not much but I am not too familiar with kernel development, so I don't know how important that 
> could be.
> 
> What do you think?

- With your code the demux becomes unusable if the memory allocation
  failes for some reason. This should be avoided. It is better have a
  working demux with a smaller buffer than to have an defunct demux.

- If there is not enough memory for both buffers, your machine has a problem
  anyway, and you should not increase buffer size.

> About the spin_lock_irqsave: currently it is not used anywhere in the code for the demux in dmxdev.c.
> I am always a bit scared when I introduce something new, maybe I am missing the current logic.

I'm sorry, spin_lock_irqsave/spin_unlock_irqrestore was a typo.
We have to use spin_[un]lock_irq because buffer writing _might_ occur
in interrupt context. So the '_irq' is very important!

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
