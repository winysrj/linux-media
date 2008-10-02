Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1KlWkn-0002uu-KD
	for linux-dvb@linuxtv.org; Fri, 03 Oct 2008 00:34:40 +0200
From: Andy Walls <awalls@radix.net>
To: David Cintron <loudestnoise@gmail.com>
In-Reply-To: <b5a60d170810012025m72e86270r4f24dce08300bb28@mail.gmail.com>
References: <2D4C0F1E-D73D-475C-BF64-91EF4A6E0BFE@gmail.com>
	<1222908425.2641.37.camel@morgan.walls.org>
	<b5a60d170810012025m72e86270r4f24dce08300bb28@mail.gmail.com>
Date: Thu, 02 Oct 2008 18:33:39 -0400
Message-Id: <1222986819.2650.21.camel@morgan.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18: Testers needed for patch to solve	non-working
	CX23418 cards under linux (Re: cx18: Possible
	causal	realtionship for HVR-1600 I2C errors)
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

On Wed, 2008-10-01 at 22:25 -0500, David Cintron wrote:
> On Wed, Oct 1, 2008 at 7:47 PM, Andy Walls <awalls@radix.net> wrote:
> > On Mon, 2008-09-29 at 23:08 -0500, David Cintron wrote:

> >>  I can't seem
> >> to get the card to initialize.  dmesg | grep cx18 returns nothing.
> >
> > OK.  Let me ask some basic questions that you may have already verified:
> >
> >
> > 1.  Does the following command show a cx18.ko module installed?
> >
> > $ find /lib/modules -name cx18.ko -print
> 
> Yep, sure does.

OK.


> > 2. Does this command:
> >
> > $ /sbin/lspci -v
> >
> > show a
> >
> > "Multimedia video controller: Conexant CX23418 Single-Chip MPEG-2 Encoder with Integrated Analog Video/Broadcast Audio Decoder
> > Subsystem: Hauppauge computer works Inc. Unknown device 7444"
> >
> > ?
> 
> Nope, this concerns me. I do see stuff about my PVR-500, but nothing
> that says Conexant CX23418.

Well, if lspci can't see the card, no amount of mucking with the cx18
driver is going to help.

See if

$ /sbin/lspci -n

returns something with "14f1:5b7a" which is the PCI vendor and device id
for a Conexant CX23418, like this:

03:03.0 0400: 14f1:5b7a

or a number that is very close (maybe wrong in one or two bit
positions).

If it doesn't show at all, invoke lspci as root to in mapping mode
(dangerous, according to the man page) to see if it finds the device: 

# lspci -n -H1 -M

Otherwise, you'll have to take other measures (pulling cards, moving
into a different slot, etc.) to see if you can get the board recognized
by the PCI subsystem.

If a PCI ID that is close, but wrong in a bit position or two, shows up,
then pull the card, blow the dust out of the slot, put the card back in
the machine, and try again.


> > does modporbe emit any errors and what does 'dmesg' or /var/log/messages
> > show?  (Please don't grep on cx18, as not all relevant messages will
> > have cx18 in them.)
> 
> No error messages on the modprobe, and here is the portion of dmesg
> that talks about my cards and things like ivtv and such.
> 
> 27.820719] Linux video capture interface: v2.00
> [   27.831881] ivtv:  Start initialization, version 1.4.0
> [   27.832020] ivtv0: Initializing card #0
> [   27.832024] ivtv0: Autodetected Hauppauge card (cx23416 based)
[snip]
> [   52.632670] ivtv1: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
> [   52.831513] ivtv1: Encoder revision: 0x02060039
> [   56.375834] cx25840 1-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
> [   62.593527] ath0: no IPv6 routers present
> [  953.888579] cx18:  Start initialization, version 1.0.0
> [  953.888979] cx18:  End initialization

The cx18 driver loaded up, the PCI bus was scanned for matching devices,
and none were found apparently.  No errors, but also no card with the
proper PCI ID visible on your PCI bus.


> [ 1677.647652] i2c /dev entries driver
> [ 2149.083630] ivtv1: =================  START STATUS CARD #1  =================
> [ 2149.083639] ivtv1: Version: 1.4.0 Card: WinTV PVR 500 (unit #2)
[snip]
> [74682.713469] ivtv1: ==================  END STATUS CARD #1  ==================
> [164887.647546] cx18:  Start initialization, version 1.0.0
> [164887.650039] cx18:  End initialization

More of the same.


> > 5.  When the module is loaded, it should always blurt out at least
> > "cx18:  Start initialization, version 1.0.0" in dmesg and messages,
> > unless the kernel couldn't load the module.  If the kernel couldn't load
> > the module, it should log an error message: what is that message?
> >
> An error message from somewhere besides dmesg? Let me know where this
> log resides and I can include that too.

No. There shouldn't be an error from the kernel in this case (but it
would be in dmesg), as the module loaded properly and blurted out "Start
initialization, version 1.0.0".  The PCI subsystem doesn't appear to be
recognizing your hardware.  That is not an error condition from the
perspective of the kernel nor the cx18 driver per se, but it certainly
is a problem.


Regards,
Andy

> - David C. (loudestnoise)



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
