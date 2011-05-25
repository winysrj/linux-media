Return-path: <mchehab@pedra>
Received: from mail01.prevas.se ([62.95.78.3]:8023 "EHLO mail01.prevas.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab1EYP54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 11:57:56 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: omap3isp - H3A auto white balance
Date: Wed, 25 May 2011 17:47:51 +0200
Message-ID: <CA7B7D6C54015B459601D68441548157C5A3F8@prevas1.prevas.se>
In-Reply-To: <CA7B7D6C54015B459601D68441548157C5A3B3@prevas1.prevas.se>
References: <CA7B7D6C54015B459601D68441548157C5A3AE@prevas1.prevas.se> <201103241135.06025.laurent.pinchart@ideasonboard.com> <CA7B7D6C54015B459601D68441548157C5A3B3@prevas1.prevas.se>
From: "Daniel Lundborg" <Daniel.Lundborg@prevas.se>
To: <linux-media@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I am developing a camera sensor driver for the Aptina MT9V034. I am only
using it in snapshot mode and I can successfully trigger the sensor and
receive pictures using the latest omap3isp driver from
git://linuxtv.org/pinchartl/media.git branch omap3isp-next-sensors with
kernel 2.6.38.

I configure the sensor with media-ctl:

media-ctl -r -l '"mt9v034 3-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
CCDC":1->"OMAP3 ISP CCDC output":0[1]'
media-ctl -f '"mt9v034 3-0048":0[SGRBG10 752x480], "OMAP3 ISP
CCDC":1[SGRBG10 752x480]'

And take pictures with yavta:

./yavta -f SGRBG10 -s 752x480 -n 6 --capture=6 -F /dev/video2

My trouble is that I am always receiving whiter pictures when I wait a
moment before triggering the sensor to take a picture. If I take several
pictures in a row with for instance 20 ms between them, they all look
ok. But if I wait for 100 ms the picture will get much whiter.

I have turned off auto exposure and auto gain in the sensor and the
LED_OUT signal always have the same length (in this case 8 msec).

Why would the pictures become whiter if I wait a moment before taking a
picture?

If I set the sensor in streaming mode all pictures look like they
should.

Could there be something with the H3A auto white balance or auto
exposure?


Regards,

Daniel Lundborg
