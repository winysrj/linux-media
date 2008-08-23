Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KWwCy-0004je-NO
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 18:43:25 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 23 Aug 2008 18:42:36 +0200
References: <48B00D6C.8080302@gmx.de> <200808231748.54615@orion.escape-edv.de>
	<alpine.LRH.1.10.0808231750550.26788@pub5.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0808231750550.26788@pub5.ifh.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808231842.36465@orion.escape-edv.de>
Subject: Re: [linux-dvb] Support of Nova S SE DVB card missing
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

Patrick Boettcher wrote:
> On Sat, 23 Aug 2008, Oliver Endriss wrote:
> >> In addition (see my other mail in that thread), sending two independent
> >> i2c_transfers which actually belong together is not really safe.
> >
> > The current code in the else path will *never* work, because the tuner
> > does not support repeated start conditions. The problem is not the I2C
> > master (saa7146/flexcop) but the I2C slave (s5h1420).
> 
> Wouldn't it be more correct to have a flag signaling to the 
> i2c_tranfer-function that a repeated start is not wanted even though it is 
> two i2c-messages glued (which are interpreted today as a read with
> repeated start).

As there is a flag I2C_M_NOSTART in the I2C subsystem in recent kernels,
we could pass this flag to the I2C driver and add a workaround to the 
i2c master_xfer function.

I remember that we had the same discussion for the stv0297 driver a long
time ago. I suggested to add a workaround to the saa7146 master_xfer
routine, but Johannes stated that the frontend caused the problem, and
so it should be fixed there...

For the stv0297 I have an experimental patch which intercepts the
master_xfer routine, but this is not very nice either.

Usually there is no problem with the old approach, because i2c transfers
are protected by the frontend mutex. But bad things may happen if
someone accesses the i2c bus from user space. :-(

I'll think about the I2C_M_NOSTART mod for the master_xfer routine,
but I need some time to work it out.

For now we should test whether the driver works again if we put the old
code into the else path.

Btw,
        b[1] = state->shadow[(reg - 1) & 0xff];
reads shadow[255] for reg == 0.

So you should change
   u8 shadow[255];
to
   u8 shadow[256];

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
