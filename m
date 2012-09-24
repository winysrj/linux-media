Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44918 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab2IXIdm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 04:33:42 -0400
Received: by pbbrr4 with SMTP id rr4so6726482pbb.19
        for <linux-media@vger.kernel.org>; Mon, 24 Sep 2012 01:33:42 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 24 Sep 2012 10:33:42 +0200
Message-ID: <CAFqH_53EY7BcMjn+fy=KfAhSU9Ut1pcLUyrmu2kiHznrBUB2XQ@mail.gmail.com>
Subject: omap3isp: wrong image after resizer with mt9v034 sensor
From: =?UTF-8?Q?Enric_Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

I'm trying to add support for MT9V034 Aptina image sensor to current
mainline, as a base of my current work I start using the latest
omap3isp-next branch from Laurent's git tree [1]. The MT9V034 image
sensor is very similar to MT9V032 sensor, so I modified current driver
to accept MT9V034 sensor adding the chip ID. The driver recognizes the
sensor and I'm able to capture some frames.

I started capturing directly frames using the pipeline Sensor -> CCDC

    ./media-ctl -r
    ./media-ctl -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1]'
    ./media-ctl -l '"OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
    ./media-ctl -f '"mt9v032 3-005c":0 [SGRBG10 752x480]'
    ./media-ctl -f '"OMAP3 ISP CCDC":1 [SGRBG10 752x480]'

    # Test pattern
    ./yavta --set-control '0x00981901 1' /dev/v4l-subdev8

    # ./yavta -p -f SGRBG10 -s 752x480 -n 4 --capture=3 /dev/video2
--file=img-#.bin

To convert to jpg I used bayer2rgb [2] program executing following command,

    $ convert -size 752x480  GRBG_BAYER:./img-000000.bin img-000000.jpg

And the result image looks like this

    http://downloads.isee.biz/pub/files/patterns/img-from-sensor.jpg

Seems good, so I tried to use following pipeline Sensor -> CCDC ->
Preview -> Resizer

    ./media-ctl -r
    ./media-ctl -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1]'
    ./media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
    ./media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
    ./media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'

    ./media-ctl -V '"mt9v032 3-005c":0[SGRBG10 752x480]'
    ./media-ctl -V  '"OMAP3 ISP CCDC":0 [SGRBG10 752x480]'
    ./media-ctl -V  '"OMAP3 ISP CCDC":2 [SGRBG10 752x480]'
    ./media-ctl -V  '"OMAP3 ISP preview":1 [UYVY 752x480]'
    ./media-ctl -V  '"OMAP3 ISP resizer":1 [UYVY 752x480]'

    # Set Test pattern

    ./yavta --set-control '0x00981901 1' /dev/v4l-subdev8

    ./yavta -f UYVY -s 752x480 --capture=3 --file=img-#.uyvy /dev/video6

I used 'convert' program to pass from UYVY to jpg,

    $ convert -size 752x480 img-000000.uyvy img-000000.jpg

and the result image looks like this

    http://downloads.isee.biz/pub/files/patterns/img-from-resizer.jpg

As you can see, the image is wrong and I'm not sure if the problem is
from the sensor, from the previewer, from the resizer or from my
conversion. Anyone have idea where should I look ? Or which is the
source of the problem ?

Any help would be appreciated. Thanks in advance,
   Enric

[1] http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-omap3isp-next
[2] https://github.com/jdthomas/bayer2rgb
