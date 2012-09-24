Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36432 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab2IXMi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 08:38:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enric =?ISO-8859-1?Q?Balletb=F2?= i Serra <eballetbo@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: omap3isp: wrong image after resizer with mt9v034 sensor
Date: Mon, 24 Sep 2012 14:39:03 +0200
Message-ID: <10375683.p3v6BRe8Fj@avalon>
In-Reply-To: <CAFqH_53EY7BcMjn+fy=KfAhSU9Ut1pcLUyrmu2kiHznrBUB2XQ@mail.gmail.com>
References: <CAFqH_53EY7BcMjn+fy=KfAhSU9Ut1pcLUyrmu2kiHznrBUB2XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enric,

On Monday 24 September 2012 10:33:42 Enric Balletbò i Serra wrote:
> Hi everybody,
> 
> I'm trying to add support for MT9V034 Aptina image sensor to current
> mainline, as a base of my current work I start using the latest
> omap3isp-next branch from Laurent's git tree [1]. The MT9V034 image
> sensor is very similar to MT9V032 sensor, so I modified current driver
> to accept MT9V034 sensor adding the chip ID. The driver recognizes the
> sensor and I'm able to capture some frames.
> 
> I started capturing directly frames using the pipeline Sensor -> CCDC
> 
>     ./media-ctl -r
>     ./media-ctl -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1]'
>     ./media-ctl -l '"OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>     ./media-ctl -f '"mt9v032 3-005c":0 [SGRBG10 752x480]'
>     ./media-ctl -f '"OMAP3 ISP CCDC":1 [SGRBG10 752x480]'
> 
>     # Test pattern
>     ./yavta --set-control '0x00981901 1' /dev/v4l-subdev8
> 
>     # ./yavta -p -f SGRBG10 -s 752x480 -n 4 --capture=3 /dev/video2
> --file=img-#.bin
> 
> To convert to jpg I used bayer2rgb [2] program executing following command,
> 
>     $ convert -size 752x480  GRBG_BAYER:./img-000000.bin img-000000.jpg
> 
> And the result image looks like this
> 
>     http://downloads.isee.biz/pub/files/patterns/img-from-sensor.jpg
> 
> Seems good, so I tried to use following pipeline Sensor -> CCDC ->
> Preview -> Resizer
> 
>     ./media-ctl -r
>     ./media-ctl -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1]'
>     ./media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
>     ./media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
>     ./media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
> 
>     ./media-ctl -V '"mt9v032 3-005c":0[SGRBG10 752x480]'
>     ./media-ctl -V  '"OMAP3 ISP CCDC":0 [SGRBG10 752x480]'
>     ./media-ctl -V  '"OMAP3 ISP CCDC":2 [SGRBG10 752x480]'
>     ./media-ctl -V  '"OMAP3 ISP preview":1 [UYVY 752x480]'
>     ./media-ctl -V  '"OMAP3 ISP resizer":1 [UYVY 752x480]'
> 
>     # Set Test pattern
> 
>     ./yavta --set-control '0x00981901 1' /dev/v4l-subdev8
> 
>     ./yavta -f UYVY -s 752x480 --capture=3 --file=img-#.uyvy /dev/video6
> 
> I used 'convert' program to pass from UYVY to jpg,
> 
>     $ convert -size 752x480 img-000000.uyvy img-000000.jpg
> 
> and the result image looks like this
> 
>     http://downloads.isee.biz/pub/files/patterns/img-from-resizer.jpg
> 
> As you can see, the image is wrong and I'm not sure if the problem is
> from the sensor, from the previewer, from the resizer or from my
> conversion. Anyone have idea where should I look ? Or which is the
> source of the problem ?

Could you please post the output of all the above media-ctl and yavta runs, as 
well as the captured raw binary frame ?

> [1] http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> omap3isp-next
> [2] https://github.com/jdthomas/bayer2rgb

-- 
Regards,

Laurent Pinchart

