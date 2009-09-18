Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:55600 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbZIRTBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 15:01:01 -0400
Received: by fxm17 with SMTP id 17so917673fxm.37
        for <linux-media@vger.kernel.org>; Fri, 18 Sep 2009 12:01:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253298801.19044.5.camel@prometheus>
References: <1253298801.19044.5.camel@prometheus>
Date: Fri, 18 Sep 2009 15:01:03 -0400
Message-ID: <829197380909181201w6ad9da3cide3c8825c421edfe@mail.gmail.com>
Subject: Re: Incorrectly detected em28xx device
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Matthias_Bl=E4sing?= <mblaesing@doppel-helix.eu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/9/18 Matthias Bläsing <mblaesing@doppel-helix.eu>:
> Hello,
>
> when I plugin my usb video grabber, it is misdetected (this email is the
> reaction to the request in the module output):
>
> Sep 18 20:27:19 prometheus kernel: [15016.458509] em28xx: New device @ 480 Mbps (eb1a:2860, interface 0, class 0)
> Sep 18 20:27:19 prometheus kernel: [15016.458516] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
> Sep 18 20:27:19 prometheus kernel: [15016.458563] em28xx #0: chip ID is em2860
> Sep 18 20:27:19 prometheus kernel: [15016.548934] em28xx #0: board has no eeprom
> Sep 18 20:27:19 prometheus kernel: [15016.562331] em28xx #0: found i2c device @ 0x4a [saa7113h]
> Sep 18 20:27:19 prometheus kernel: [15016.595202] em28xx #0: Your board has no unique USB ID.
> Sep 18 20:27:19 prometheus kernel: [15016.595207] em28xx #0: A hint were successfully done, based on i2c devicelist hash.
> Sep 18 20:27:19 prometheus kernel: [15016.595209] em28xx #0: This method is not 100% failproof.
> Sep 18 20:27:19 prometheus kernel: [15016.595210] em28xx #0: If the board were missdetected, please email this log to:
> Sep 18 20:27:19 prometheus kernel: [15016.595212] em28xx #0: ^IV4L Mailing List  <linux-media@vger.kernel.org>
> Sep 18 20:27:19 prometheus kernel: [15016.595214] em28xx #0: Board detected as PointNix Intra-Oral Camera
> Sep 18 20:27:19 prometheus kernel: [15016.595217] em28xx #0: Registering snapshot button...
> Sep 18 20:27:19 prometheus kernel: [15016.595289] input: em28xx snapshot button as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.4/input/input19
> Sep 18 20:27:20 prometheus kernel: [15016.980420] saa7115 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> Sep 18 20:27:21 prometheus kernel: [15017.696774] em28xx #0: Config register raw data: 0x00
> Sep 18 20:27:21 prometheus kernel: [15017.696777] em28xx #0: No AC97 audio processor
> Sep 18 20:27:21 prometheus kernel: [15017.796516] em28xx #0: v4l2 driver version 0.1.2
> Sep 18 20:27:21 prometheus kernel: [15018.076600] em28xx #0: V4L2 device registered as /dev/video1 and /dev/vbi0
> Sep 18 20:27:21 prometheus kernel: [15018.076630] usbcore: registered new interface driver em28xx
> Sep 18 20:27:21 prometheus kernel: [15018.076633] em28xx driver loaded
>
> The correct functionality can be accessed, when explicitly called with
> card=35 as paramter:
>
> [ 1014.939536] em28xx: New device @ 480 Mbps (eb1a:2860, interface 0, class 0)
> [ 1014.939549] em28xx #0: Identified as Typhoon DVD Maker (card=35)
> [ 1014.939734] em28xx #0: chip ID is em2860
> [ 1015.029084] em28xx #0: board has no eeprom
> [ 1015.393031] saa7115 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> [ 1016.100782] em28xx #0: Config register raw data: 0x00
> [ 1016.100789] em28xx #0: No AC97 audio processor
> [ 1016.204578] em28xx #0: v4l2 driver version 0.1.2
> [ 1016.484275] em28xx #0: V4L2 device registered as /dev/video1 and /dev/vbi0
>
> It would be very nice, if this could be auto-detected. If you need more information, please CC me.
>
> Greetings
>
> Matthias

Hi Matthias,

I fixed this a couple of months ago.  Just update to the latest v4l-dvb tree.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
