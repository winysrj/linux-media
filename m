Return-path: <linux-media-owner@vger.kernel.org>
Received: from static.59.56.47.78.clients.your-server.de ([78.47.56.59]:50074
	"EHLO www.braincalibration.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbaABTsD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jan 2014 14:48:03 -0500
Received: from p5b397b55.dip0.t-ipconnect.de ([91.57.123.85] helo=[192.168.2.113])
	by www.braincalibration.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <conan@braincalibration.de>)
	id 1Vynnp-0003qX-FP
	for linux-media@vger.kernel.org; Thu, 02 Jan 2014 20:19:33 +0100
Message-ID: <52C5BC5A.5020109@braincalibration.de>
Date: Thu, 02 Jan 2014 20:22:02 +0100
From: Conan <conan@braincalibration.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: cx231xx: added usb id of 'Dexatek Video Grabber'
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all,

this patch adds support for the Dexatek Video Grabber with USB id 1d19:610a

The device is sold in germany as 'USB-Video-Digitalisierer Medion E89137
(MD 86937)', provides analog audio/video capture and is based on the
CX23103-11Z.

The driver loads the firmware v4l-cx231xx-avcore-01.fw, despite
v4l-cx23885-avcore-01.fw (merlinD.rom) beeing shipped with the windows
driver. But audio and video capturing works here.

Trivial patch:
- --- a/drivers/media/usb/cx231xx/cx231xx-cards.c 2014-01-01
11:49:19.000000000 +0100
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c 2014-01-01
11:58:50.949353779 +0100
@@ -684,6 +684,8 @@
         .driver_info = CX231XX_BOARD_CNXT_RDU_253S},
        {USB_DEVICE(0x0572, 0x58A6),
         .driver_info = CX231XX_BOARD_CNXT_VIDEO_GRABBER},
+       {USB_DEVICE(0x1D19, 0x610A),
+        .driver_info = CX231XX_BOARD_CNXT_VIDEO_GRABBER},
        {USB_DEVICE(0x0572, 0x589E),
         .driver_info = CX231XX_BOARD_CNXT_RDE_250},
        {USB_DEVICE(0x0572, 0x58A0),

- -- 
Regards,
C
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSxbxaAAoJECsSvCKD1CYcAacH/07/ps/pwDrVSvGXd5bZ+RBg
p/+9ktxgcW6L2pSLpH6qsF0psX9LRt4zWKuuvomQsC5wf0OS6yP2lxqYGNkX5O1d
ZbLNyAF6CAv3zH/jfAlq0rgi0Sk9ZqEcHjgP/si85lsjKAagZpmtHDMK7kYl6lNC
9IyoZHISbTzSZlbVBerZ/89Pta8AY9CrQ01FWlvpIctmjBE3AB+LCetj9mNB8uEV
164Irv66BMWBKRHGSz9zUXbAHUpJJLSRjN5KOV6Nk5hrodqqRkIe80YnBlkL9PLl
1zchPkd+05QBxVfK3+9Xwv31S4hegVleEv4S96XsnxirzPY9kCLcYF3lYOcGKFw=
=CQvY
-----END PGP SIGNATURE-----
