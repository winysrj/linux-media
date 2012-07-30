Return-path: <linux-media-owner@vger.kernel.org>
Received: from faith.oztechninja.com ([202.4.233.235]:36625 "EHLO
	faith.oztechninja.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2G3KW6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 06:22:58 -0400
Date: Mon, 30 Jul 2012 20:17:06 +1000
From: David Basden <davidb-git@rcpt.to>
To: poma <pomidorabelisima@gmail.com>
Cc: davidb-git@rcpt.to, Thomas Mair <thomas.mair86@googlemail.com>,
	Hans-Frieder Vogt <hfvogt@gmx.net>,
	Antti Palosaari <crope@iki.fi>, mchehab@redhat.com,
	linux-media@vger.kernel.org
Subject: Re: rtl28xxu - rtl2832 frontend attach
Message-ID: <20120730101706.GH9047@faith.oztechninja.com>
References: <4FB92428.3080201@gmail.com>
 <4FB94F2C.4050905@iki.fi>
 <4FB95E4B.9090006@googlemail.com>
 <4FC0443F.8030004@gmail.com>
 <4FC32233.1040407@googlemail.com>
 <4FC3902D.3090506@googlemail.com>
 <4FE9EEB4.9010005@gmail.com>
 <4FEA9849.5010105@googlemail.com>
 <5016328E.3040909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5016328E.3040909@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 30, 2012 at 09:06:54AM +0200, poma wrote:
> On 06/27/2012 07:21 AM, Thomas Mair wrote:
> > On 26.06.2012 19:17, poma wrote:
> >> On 05/28/2012 04:48 PM, Thomas Mair wrote:
> >>> On 28.05.2012 08:58, Thomas Mair wrote:
> >>>> On 26.05.2012 04:47, poma wrote:
> >>>>> On 05/20/2012 11:12 PM, Thomas Mair wrote:
> >>>>>> On 20.05.2012 22:08, Antti Palosaari wrote:
> >>>>>>> On 20.05.2012 20:04, poma wrote:
> >>>>>>>> After hard/cold boot:
> >>>>>>>
> >>>>>>>> DVB: register adapter0/net0 @ minor: 2 (0x02)
> >>>>>>>> rtl2832u_frontend_attach:
> >>>>>>>> rtl28xxu_ctrl_msg: failed=-32
> >>>>>>>> rtl28xxu_ctrl_msg: failed=-32
> >>>>>>>> rtl28xxu_ctrl_msg: failed=-32
> >>>>>>>> rtl28xxu_ctrl_msg: failed=-32
> >>>>>>>> rtl28xxu_ctrl_msg: failed=-32
> >>>>>>>> rtl28xxu_ctrl_msg: failed=-32
> >>>>>>>> rtl28xxu_ctrl_msg: failed=-32
> >>>>>>>> rtl28xxu_ctrl_msg: failed=-32
> >>>>>>>> rtl28xxu_ctrl_msg: failed=-32
> >>>>>>>> rtl28xxu_ctrl_msg: failed=-32
> >>>>>>>> No compatible tuner found
> >>>>>>>
> >>>>>>> These errors are coming from tuner probe. As it still goes to probing and did not jump out earlier when gate is opened it means that demod is answering commands but tuner are not.
> >>>>>>>
> >>>>>>> My guess is that tuner is still on the reset or not powered at all. It is almost 100% sure error is wrong tuner GPIO.
> >>>>>>
> >>>>>> There is an issue with GPIO, as FC0012 tuner callback will set 
> >>>>>> the value of one of the GPIO outputs. However fixing that, will
> >>>>>> not resolve the issue. So I need to debug the problem further.
> >>>>>>
> >>>>> True. Whatever a value is changed - 'rtl2832u_power_ctrl', it brakes
> >>>>> even more.
> >>>>> Precisely, what breaks a tuner on next soft [re]boot are apps/utils
> >>>>> which engage tzap/scan[dvb].
> >>>>>
> >>>>
> >>>> To reproduce the bug it is not necessary to reboot the machine. Simply 
> >>>> unload and load of the dvb_usb_rtl28xxu module will lead to the same 
> >>>> situation.
> >>>>
> >>>> I suspect, that when power is turned off, the tuner power is not 
> >>>> switched on correctly. The mistake is not related to the OUTPUT_VAL
> >>>> registers but probably to the OUTPUT_DIR or OUTPUT_EN registers.
> >>>>
> >>>> What makes me wonder is if no tuning operation is performed before
> >>>> reboot, the driver does work correctly after that, as poma already
> >>>> noticed.
> >>>>
> >>>> I have some spare time today and will investigate the problem further.
> >>>>
> >>>
> >>> I tried a few things regarding the problem today and could find out a 
> >>> few more details, but could not resolve the issue.
> >>>
> >>> The GPIO pin configuration for the devices with the fc0012 (and probably
> >>> also with the fc0013) tuner is the following:
> >>>
> >>> GPIO0: demod power
> >>> GPIO3: tuner power? (the realtek driver puts this to 1 and never touches it again)
> >>> GPIO4: tuner power? (maybe antenna power?)
> >>> GPIO5: tuner reset
> >>> GPIO6: UHF/VHF band selection
> >>>
> >>> All of these GPIOs are configured as output. When the device is plugged in
> >>> the tuner is powered up correctly, but I am not able to power it up when
> >>> a reboot is performed. What I tried was the following:
> >>>
> >>> - on rtl28xxu_power_ctrl off:
> >>>   - GPIO4 = 1 (off)
> >>>   - GPIO5 = 0 
> >>>   - GPIO6 = 0 (default state)
> >>>
> >>> - on rtl28xxu_power_ctrl on:
> >>>   - GPIO3 = 1
> >>>   - GPIO4 = 0 (on)
> >>>   - GPIO5 = 0 
> >>>   - GPIO6 = 0 (default state)
> >>>
> >>> - on rtl2832_frontend_attach:
> >>>   - GPIO5 = 1 
> >>>   - GPIO5 = 0 
> >>>
> >>> This sequence should ensure that the tuner is powered on when the frontend
> >>> is attached, and a tuner reset is being performed before the tuner is probed.
> >>> However this sequence fails the same way as it did before. I tried to add
> >>> timeouts to be sure that the tuner is not probed while it is reset but that
> >>> did not help either.
> >>>
> >>> Right now I really don't know where I should look for the solution of
> >>> the problem. It seems that the tuner reset does not have any effect on the 
> >>> tuner whatsoever.
> >>>
> >>> Is there anybody who could look at the code, or maybe knows what could be
> >>> the cause of the problem? I suspect I am just too blind to see my own mistakes.
> >>>
> >>> Regards
> >>> Thomas
> >>>
> >>
> >> Cheers Thomas, Hans-Frieder, Antti, Mauro!
> >> Hans-Frieder, are you having the same issue with fc0011&af9035?
> >> Antti, no tricks up your sleeve?
> >> Senhor Mauro, is rtl2832 demod going to be merged?
> >>
> >> regards,
> >> poma
> >>
> > Hi all,
> > 
> > I will try to solve the issue as soon as I have some spare time. In the meantime I 
> > asked Realtek if they knew of any problems with the hardware, and I got a GPIO
> > list which might help me to solve the problem.
> > 
> > Regrads
> > Thomas
> > 
> 
> This is correspondent code by dbasden - fc0012 for rtl-sdr GPIOs
> https://gist.github.com/2171926#120
> David, can you help with this tuner issue?
> http://git.linuxtv.org/anttip/media_tree.git/blob/3efd26330fda97e06279cbca170ae4a0dee53220:/drivers/media/dvb/dvb-usb/rtl28xxu.c#l898
> 
> Cheers,
> poma

It sounds like you're definately on the right track with the GPIO pins for
tuner power and reset lines, especially if it's not making it through the
tuner probe.

The gist you linked to above has since been merged into the rtl-sdr tree,
and the version in there is likely to be a much better reference than the
old patch I had posted: http://sdr.osmocom.org/trac/wiki/rtl-sdr
It reliably brings the rtl and the tuner up from cold, after reboots, and
multiple times without rebooting. Given others have improved it since last
time I looked at the tree, it would be a good place to look for at least
bringing up the tuner.  Given it's not trying to do DVB though, be careful
with any assumptions that the setup of the RTL or tuner past then are going
to be what you're trying to do though; (It's not using the deframing stuff at
all, AGC is likely switched off, and the LNA gain is just set to a fixed
value and left there)

That said, these dongles are really done on a budget, and the hardware
itself can be dodgy in ways that look like software problems. Although
it's not that likely given the way you're able to reproduce, just check:

 - dmesg to make sure the USB device is coming up in hispeed rather fullspeed,
   and that there aren't any problems attaching before it hits the dongle driver
 - It's not hooked up through an unpowered USB extension. Some of them barely
   up regardless
 - The antenna is connected. One of the dongles I have will reliably kill the
   power on my netbook if I plug it in without an antenna connected. The 
   implications are rather scary.

all of which can lead to fail when in the middle of bringing up the dongle,
and can look like errors in the tuner init code.

(If you weren't already able to get it working before resetting the dongle
I'd also have suggested checking the tuner onboard your dongle is the one 
you think it is; There is much reuse of USB ids with different hardware)

As for bring up the tuner, you'll want to:

 - Setup the RTL etc. and power on the demodulator and tuner

 - Check that it's anything but an FC0012 if you're doing tuner probing
   rather than messing with GPIOs that won't be hooked up that way

 - Explicitly disable the I2C repeater/bridge so the rtl is listening NOT the tuner.

 - Make sure GPIO5 and GPIO6 are both enabled, set to be outputs, and have
   an output value set. i.e.

    o Read the value from GPD, clear bits 0x30, and write the result to GPO
    o Read the value from GPOE, set bits 0x30, and write the result back to GPOE

   GPIO5 is really important, as it's the RESET line, and if it's not setup properly
   it will float, and leave the tuner likely in a bad state 

 - Reset the tuner by setting GPIO5 to 1 then 0:

    o Read the value from GPO, set bit 0x20, and write the result back to GPO
    o Read the value from GPO, clear bit 0x20, and write the result back to GPO

 - Enable the I2C repeater to talk to the tuner

 - Probe to check the FC0012 indeed exists (reading from 0xc6,0x00 should give you 0xa1)
   and go on to setup the tuner

Hopefully that will help some.  If it doesn't help enough, let me know, or drop
into ##rtl-sdr on freenode where people are banging their heads against walls daily
seeing how hard they can push rtl2832 dongles to do SDR.

Cheers,

David
