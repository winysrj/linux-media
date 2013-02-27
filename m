Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:45304 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3B0VW3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 16:22:29 -0500
Received: by mail-vc0-f171.google.com with SMTP id fy7so726221vcb.30
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 13:22:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB0d6EdexHb_sLh3m_xRf36N9SUrr1axogxidyp+64-ROKDHjw@mail.gmail.com>
References: <CAB0d6EdexHb_sLh3m_xRf36N9SUrr1axogxidyp+64-ROKDHjw@mail.gmail.com>
Date: Wed, 27 Feb 2013 18:22:27 -0300
Message-ID: <CAB0d6EeZJu983yP3wMwbZtniDwWgoAuxAzifZvo_RZpO4Dio8Q@mail.gmail.com>
Subject: Re: V4L on android
From: Rafael Coutinho <rafael.coutinho@phiinnovations.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm having issues to get my video capture board to work. I see that
when I connect it is successfully mapped with the video driver:

<3>[   11.210876] em28xx #0: board has no eeprom
<6>[   11.244746] em28xx #0: found i2c device @ 0x4a [saa7113h]
<3>[   11.278498] em28xx #0: Your board has no unique USB ID.
<3>[   11.278504] em28xx #0: A hint were successfully done, based on
i2c devicelist hash.
<3>[   11.278509] em28xx #0: This method is not 100% failproof.
<3>[   11.278513] em28xx #0: If the board were missdetected, please
email this log to:
<3>[   11.278518] em28xx #0: 	V4L Mailing List  <linux-media@vger.kernel.org>
<3>[   11.278523] em28xx #0: Board detected as EM2860/SAA711X Reference Design
<6>[   11.370027] em28xx #0: Identified as EM2860/SAA711X Reference
Design (card=19)
<6>[   11.370033] em28xx #0: Registering snapshot button...
<6>[   11.370366] input: em28xx snapshot button as
/devices/pci0000:00/0000:00:1d.7/usb1/1-6/input/input8
<6>[   12.020506] saa7115 15-0025: saa7113 found (1f7113d0e100000) @
0x4a (em28xx #0)
<6>[   13.300245] em28xx #0: Config register raw data: 0x10
<4>[   13.340250] em28xx #0: AC97 vendor ID = 0x83847652
<4>[   13.360249] em28xx #0: AC97 features = 0x6a90
<6>[   13.360255] em28xx #0: Sigmatel audio processor detected(stac 9752)
<6>[   14.120032] em28xx #0: v4l2 driver version 0.1.2
<6>[   15.820615] em28xx #0: V4L2 video device registered as video1
<6>[   15.820623] em28xx #0: V4L2 VBI device registered as vbi0
<3>[   15.820678] em28xx audio device (eb1a:2861): interface 1, class 1
<3>[   15.820704] em28xx audio device (eb1a:2861): interface 2, class 1
<6>[   15.820953] usbcore: registered new interface driver em28xx
<6>[   15.820960] em28xx driver loaded

However when I try to use androids app for camera it gives me a blank screen...
Do you have any suggestions on how I could debug it? I've been looking
for any android command line programs to take snap shots but nothing
so far. An advice is welcome.

Thanks a lot.
