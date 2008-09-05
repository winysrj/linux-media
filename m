Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KbjZO-0006rD-Cr
	for linux-dvb@linuxtv.org; Sat, 06 Sep 2008 00:14:25 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	8C12418004AF
	for <linux-dvb@linuxtv.org>; Fri,  5 Sep 2008 22:13:47 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Thomas Goerke" <tom@goeng.com.au>, stev391@email.com,
	'jackden' <jackden@gmail.com>
Date: Sat, 6 Sep 2008 08:13:47 +1000
Message-Id: <20080905221347.5F8101BF28D@ws1-10.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
 TV/FM capture card
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


> ----- Original Message -----
> From: "Thomas Goerke" <tom@goeng.com.au>
> To: stev391@email.com, "'jackden'" <jackden@gmail.com>
> Subject: RE: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog	TV/FM capture card
> Date: Fri, 5 Sep 2008 12:40:19 +0800
> 
> 
> >
> > OK..some interesting feedback.  Your patch works, but only after a cold
> > reset.   I initially double checked I had applied the correct patch
> > i.e.
> > 	hg clone http://linuxtv.org/hg/v4l-dvb
> > 	cd v4l-dvb
> > 	make
> > 	patch -p1 < ../patch/Compro_VideoMate_E650_V0.2.patch
> > 	make
> > 	sudo make install
> >
> > and it seems that I did ;-).
> >
> > After a warm reboot the card does not work.  See below for outputs from
> > both
> > dmesg.  You will notice that for the second one (fail condition) the
> > kernel
> > ring buffer has been filled and seems to have wiped out the initial
> > messages.
> >
> > In terms of the ic descriptions these are the chips on the board (I
> > will
> > update the wiki):
> > 	CX23885-132					- AV Decoder
> > 	CX23417-11Z					- MPEG 2 Encoder
> > 	ZL10353 0619T S				- Demodulator
> > 	ETRONTECH EM638325ts-6G			- 2M x 32 bit Synchronous
> > DRAM (SDRAM)
> > 	XCEIVE  XC3008ACQ AK50113.2		- Video Tuner
> > 	ELAN EM78P156ELMH-G			- 8 bit microprocessor
> > 	HT24LC02					- 2K 2-Wire CMOS
> > Serial EEPROM
> > 	IDT QS3257					- High-Speed CMOS
> > QuickSwitch Quad 2:1 Mux/Demux
> > 	1509						- PWM Buck DC/DC
> > Converter??
> >
> > With regard to reading the eeprom, I don't have time at the moment to
> > search
> > but will look into it if someone can provide somepointers.
> >
> > Tom
> >
> --snip --
> 
> 
> Stephen,
> 
> I have just loaded the working modules from previous patch and all worked
> fine after cold reset.  However, after warm reset (sudo reboot) I get
> similar errors in the kernel ring buffer.  The card is still working and I
> can view channels etc.
> 
> Output from dmesg:
> 

---Snip---

Tom,

So the V0.2 patch worked after a cold reboot (No power to the computer then starting up again). Is that what you are saying?
(Make sure that the v0.1 modules are not loaded on boot up if you are testing V0.2)

I was expecting the DMA timeout errors when using V0.2 from a cold start, it should not have caused it to break for a warm start (i.e. V0.1 modules loaded, then removed and v0.2 modules loaded).

Sorry to ask for clarification, as the results were not what I was expecting.

Can you try the:
modprobe cx23885 i2c_scan=1
That Steve Suggested.

Thanks

Stephen


-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
