Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36069 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaBDK3Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 05:29:16 -0500
Received: by mail-ig0-f169.google.com with SMTP id uq10so8614461igb.0
        for <linux-media@vger.kernel.org>; Tue, 04 Feb 2014 02:29:15 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 4 Feb 2014 21:29:15 +1100
Message-ID: <CADyej-mND8fuxseQhp0-XeaapPoK8Q9r5bDjcVFndpoay6wLtQ@mail.gmail.com>
Subject: Help wanted patching saa7164 driver to work with Compro E900F
From: Daniel Playfair Cal <daniel.playfair.cal@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I've been working on patching the saa7164 driver to work with the
Compro Videomate Vista E900F. This is a PCI-e tuner card that seems to
be almost identical to the Hauppauge HVR-2200, many versions of which
are supported. I've had some success but there are a few problems
which I'm not sure how to approach and I would appreciate any
help/advice. The most important point is number 2 under things that
are confusing.

CARD DETAILS:
 - Dual hybrid DVB-T/analogue TV tuner
 - hardware analogue source encoders
 - Various analogue video inputs
 - IR remote input
 - pci ID: 185b:e900
 - Main IC: phillips saa7164 rev2
 - Tuners: 2x NXP tda18271
 - DVB-T Demodulators: 2x NXP tda10048

WHAT I'VE DONE
My approach has been to modify the driver to make the kernel output
resemble the sample shown for the HVR-2200 here:
http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2200#Sample_kernel_output
I patched saa7164-cards.c and saa7164.h to include the details of the
card (see https://gist.github.com/anonymous/8801027), and added the
card to the first case in saa7164_dvb_register() in saa7164-dvb.c (the
case covering the Hauppauge DVB-T cards). This results in the card
being recognised, the tuner/digital demodulator chips being detected,
and the DVB frontend devices being registered correctly. Kernel log of
this process is here: https://gist.github.com/anonymous/8799960. The
output of w_scan is here: https://gist.github.com/anonymous/8800001.
w_scan correctly finds frequencies on which there is a signal in my
area but seems to fail to get any data from those transmissions like
channel names etc. Kernel logs collected during that run of w_scan are
here: https://gist.github.com/anonymous/8800084. The behaviour is the
same on both adapters.

MISCELLANEOUS OBSERVATIONS/ACTIONS:
 - the card's firmware is different to any of the hauppauge firmwares.
The earlier two rev2 firmwares on Steven Toth's site boot correctly
and behave similarly to the stock firmware under linux but result in
the card failing to work at all under windows. The rev3 firmwares and
the newer/larger rev2 firmwares fail to boot. The firmware in the
windows driver has a different header structure to that in the
hauppauge firmware files, but I haven't bothered tackling that problem
yet since the firmware persists even through a full power cycle. I've
just been using the Compro firmware as flashed by the windows driver.
 - My best guess is that the two GPIO pins connected to the tda10048
demodulator reset pin are the same as on the HVR-2200. When I disabled
setting these pins on initialisation, the demodulators were not
correctly detected after a reboot, and strobing these pins as is done
for the HVR-2200 fixed the problem.

THINGS THAT ARE CONFUSING TO ME AND SEEM TO BE WRONG:
1. RF calibration for the tda18271 occurs only on the second of the
two tuners. When tda18271c2_rf_cal_init() is called from within
tda18271_attach(...) in tda18271-fe.c, cfg->rf_cal_on_startup is 0 for
the first chip and 1 for the second. I don't know why this is the
case, but I'm currently assuming its not a serious problem.
2. firmware is not loaded onto either of the tda10048's.
tda10048_init() seems to never be called. I don't understand how it is
meant to be called and why it isn't being called. Does the firmware on
this chip not persist through a reboot or reset, and would this
explain why w_scan is unable to see the channels on the frequencies?
What is the expected series of events that results in tda10048_init
being called to initialise the demodulator? At the moment I feel like
this is likely the biggest problem.
3. The firmware seems to object the the get firmware debug status
command sent from saa7164_api_set_debug() with a 0x9 status code
(SAA_ERR_BAD_PARAMETER), but not to the set debug status command, so I
don't see that this matters. I can see messages in the log starting
with FWMSG like what saa7164_api_collect_debug() would print, so it
seems that the firmware debugging is working in any case.
4. The output of saa7164_api_dump_subdevs() (see kernel log:
https://gist.github.com/anonymous/8799960) indicates that there is an
EEPROM with unitID 0x02. I have configured the card with this unitID
but the firmware returns 0x09 (SAA_ERR_BAD_PARAMETER) and the eeprom
is not read. I don't know why this is the case, and I am curious as to
why the particular read addresses are used in
saa7164_api_read_eeprom() in saa7164-api.c. ("u8 reg[] = { 0x0f, 0x00
};"). Might the correct address vary between cards? If so, how would I
got about finding the correct address? Am I correct in thinking that
the failure to read the EEPROM will not affect digital reception?
(btw, I also tried using all other unitIDs 0-0xff and none resulted in
a successful eeprom read)
5. Some of the configurations of hvr-2200 cards do not include analog
demodulators. I assume one must be present and configured in the card
struct to enable analog reception, and that the driver currently only
supports it for some cards for some reason?

As I said any help or guidance would be greatly appreciated. I'm not
experienced in kernel/driver development so it's quite possible I've
overlooked something important.

Daniel
