Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48713 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2CLEnS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 00:43:18 -0400
Received: by wibhq7 with SMTP id hq7so3114035wib.1
        for <linux-media@vger.kernel.org>; Sun, 11 Mar 2012 21:43:17 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 12 Mar 2012 00:38:07 -0400
Message-ID: <CALUGRoA7FfKn-+KWZOKLkGuCxpqh1D9tZJTnZQw1PVXYwOP8jw@mail.gmail.com>
Subject: HVR-1600 problem
From: Matt Berglund <bmwebinfo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I'm having trouble with my 1600 listed as: Hauppauge model 74541, rev C6A3
The firmware is installed. Both using yum and manually.
Based on the LTV wiki, it seems this is less well tested model. If
this is so, I'll be happy to do what I can to test it.

Subsystem: Hauppauge computer works Inc. WinTV HVR-1600 [0070:7444]

Running Fedora 16 with 3.2.9-1.fc16.x86_64 on an MSI 790FX-GD70 with
an AMD 5770 and 6770 board running crossfirex/catalyst  (I realize
this is potentially problematic but I don't think it is the cause of
this issue)

I have used both the built-in drivers and now have compiled what I
believe are the latest linuxtv drivers, per the wiki there.

With the following results:
[  762.974890] Linux media interface: v0.10
[  762.979795] Linux video capture interface: v2.00
[  762.979804] WARNING: You are using an experimental version of the
media stack.
[  762.979808]  As the driver is backported to an older kernel, it doesn't offer
[  762.979811]  enough quality for its usage in production.
[  762.979813]  Use it with care.
[  762.979815] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[  762.979818]  632fba4d012458fd5fedc678fb9b0f8bc59ceda2 [media]
cx25821: Add a card definition for No brand cards that have: subvendor
= 0x0000 subdevice = 0x0000
[  762.979823]  1b1301e67bbcad0649a8b3c6a944d2b2acddc411 [media] Fix
small DocBook typo
[  762.979826]  0f67a03ff6ada162ad7518d9092f72d830d3a887 [media]
media: tvp5150: support g_mbus_fmt callback
[  762.985568] WARNING: You are using an experimental version of the
media stack.
[  762.985570]  As the driver is backported to an older kernel, it doesn't offer
[  762.985570]  enough quality for its usage in production.
[  762.985571]  Use it with care.
[  762.985572] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[  762.985573]  632fba4d012458fd5fedc678fb9b0f8bc59ceda2 [media]
cx25821: Add a card definition for No brand cards that have: subvendor
= 0x0000 subdevice = 0x0000
[  762.985574]  1b1301e67bbcad0649a8b3c6a944d2b2acddc411 [media] Fix
small DocBook typo
[  762.985575]  0f67a03ff6ada162ad7518d9092f72d830d3a887 [media]
media: tvp5150: support g_mbus_fmt callback
[  762.986723] cx18:  Start initialization, version 1.5.1
[  762.987457] cx18-0: Initializing card 0
[  762.987460] cx18-0: Autodetected Hauppauge card
[  762.993040] cx18-0: cx23418 revision 01010000 (B)
[  763.227077] tveeprom 0-0050: Hauppauge model 74541, rev C6A3, serial#
[  763.227080] tveeprom 0-0050: MAC address
[  763.227082] tveeprom 0-0050: tuner model is TCL MFNM05-4 (idx 103, type 43)
[  763.227084] tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
[  763.227086] tveeprom 0-0050: audio processor is CX23418 (idx 38)
[  763.227088] tveeprom 0-0050: decoder processor is CX23418 (idx 31)
[  763.227089] tveeprom 0-0050: has radio
[  763.227090] cx18-0: Autodetected Hauppauge HVR-1600
[  763.227092] cx18-0: Simultaneous Digital and Analog TV capture supported
[  763.340073] cx18-0: Registered device video0 for encoder MPEG (64 x 32.00 kB)
[  763.340076] DVB: registering new adapter (cx18)
[  763.341895] s5h1409_readreg: readreg error (ret == -6)
[  763.341903] cx18-0: frontend initialization failed
[  763.342126] cx18-0: DVB failed to register
[  763.342235] cx18-0: Registered device video32 for encoder YUV (20 x
101.25 kB)
[  763.342301] cx18-0: Registered device vbi0 for encoder VBI (20 x 51984 bytes)
[  763.342369] cx18-0: Registered device video24 for encoder PCM audio
(256 x 4.00 kB)
[  763.342433] cx18-0: Registered device radio0 for encoder radio
[  763.342552] cx18-0: unregister DVB
[  763.343628] cx18-0: Error -1 registering devices
[  763.346390] cx18-0: Error -1 on initialization
[  763.346406] cx18: probe of 0000:07:07.0 failed with error -1
[  763.346427] cx18:  End initialization

This will be used to capture signals from a cable feed, both free HD
and SD.

This problem happens regardless of how the drivers are installed.

I noticed this:
[  763.341895] s5h1409_readreg: readreg error (ret == -6)
And was wondering if this is related to the card appearing to be less
well known?

I will enable debug and poke around a bit more, but I'm far from a
driver writer.

Thanks,
Matt
