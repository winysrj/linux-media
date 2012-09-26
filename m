Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35811 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2IZItN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 04:49:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enric =?ISO-8859-1?Q?Balletb=F2?= i Serra <eballetbo@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: omap3isp: wrong image after resizer with mt9v034 sensor
Date: Wed, 26 Sep 2012 10:49:49 +0200
Message-ID: <4942603.aHqLq5MBAn@avalon>
In-Reply-To: <CAFqH_515+=O+s1rOZ85hzO8nnU=Fn9O=NxV_mM+4dfowb0pa7w@mail.gmail.com>
References: <CAFqH_53EY7BcMjn+fy=KfAhSU9Ut1pcLUyrmu2kiHznrBUB2XQ@mail.gmail.com> <1982842.IhYcnQa0e6@avalon> <CAFqH_515+=O+s1rOZ85hzO8nnU=Fn9O=NxV_mM+4dfowb0pa7w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enric,

On Wednesday 26 September 2012 09:57:53 Enric Balletbò i Serra wrote:

[snip]

> You had reason. Checking the data lines of the camera bus with an
> oscilloscope I see I had a problem, exactly in D8 /D9 data lines.

I'm curious, how have you fixed that ?

> Now I can capture images but the color is still wrong, see the following
> image captured with pipeline SENSOR -> CCDC OUTPUT
> 
>     http://downloads.isee.biz/pub/files/patterns/img-000001.pnm
> 
> Now the image was converted using :
> 
>     ./raw2rgbpnm -s 752x480 -f SGRBG10 img-000001.bin img-000001.pnm
> 
> And the raw data can be found here:
> 
>     http://downloads.isee.biz/pub/files/patterns/img-000001.bin
> 
> Any idea where I can look ? Thanks.

Your sensors produces BGGR data if I'm not mistaken, not GRBG. raw2rgbpnm 
doesn't support BGGR (yet), but the OMAP3 ISP preview engine can convert that 
to YUV since v3.5. Just make your sensor driver expose the right media bus 
format and configure the pipeline accordingly.

-- 
Regards,

Laurent Pinchart

