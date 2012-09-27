Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47206 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab2I0LSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 07:18:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enric =?ISO-8859-1?Q?Balletb=F2?= i Serra <eballetbo@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: omap3isp: wrong image after resizer with mt9v034 sensor
Date: Thu, 27 Sep 2012 13:19:20 +0200
Message-ID: <2096827.TE4L9M8af3@avalon>
In-Reply-To: <CAFqH_51XXMyN0W5tUJiUr9MUrXe1KUZT5LuD-95M7xCaFT5Kgg@mail.gmail.com>
References: <CAFqH_53EY7BcMjn+fy=KfAhSU9Ut1pcLUyrmu2kiHznrBUB2XQ@mail.gmail.com> <4942603.aHqLq5MBAn@avalon> <CAFqH_51XXMyN0W5tUJiUr9MUrXe1KUZT5LuD-95M7xCaFT5Kgg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enric,

On Wednesday 26 September 2012 16:15:35 Enric Balletbò i Serra wrote:
> 2012/9/26 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > On Wednesday 26 September 2012 09:57:53 Enric Balletbò i Serra wrote:
> > 
> > [snip]
> > 
> >> You had reason. Checking the data lines of the camera bus with an
> >> oscilloscope I see I had a problem, exactly in D8 /D9 data lines.
> > 
> > I'm curious, how have you fixed that ?
> 
> The board had a pull-down 4k7 resistor which I removed in these lines
> (D8/D9). The board is prepared to accept sensors from 8 to 12 bits,
> lines from D8 to D12 have a pull-down resistor to tie down the line by
> default.
> 
> With the oscilloscope I saw that D8/D9 had problems to go to high
> level like you said, then I checked the schematic and I saw these
> resistors.
> 
> >> Now I can capture images but the color is still wrong, see the following
> >> image captured with pipeline SENSOR -> CCDC OUTPUT
> >> 
> >>     http://downloads.isee.biz/pub/files/patterns/img-000001.pnm
> >> 
> >> Now the image was converted using :
> >>     ./raw2rgbpnm -s 752x480 -f SGRBG10 img-000001.bin img-000001.pnm
> >> 
> >> And the raw data can be found here:
> >>     http://downloads.isee.biz/pub/files/patterns/img-000001.bin
> >> 
> >> Any idea where I can look ? Thanks.
> > 
> > Your sensors produces BGGR data if I'm not mistaken, not GRBG. raw2rgbpnm
> > doesn't support BGGR (yet), but the OMAP3 ISP preview engine can convert
> > that to YUV since v3.5. Just make your sensor driver expose the right
> > media bus format and configure the pipeline accordingly.
> 
> The datasheet (p.10,11) says that the Pixel Color Pattern is as follows.
> 
> <------------------------ direction
> n  4    3    2    1
> .. GB GB GB GB
> .. RG RG RG RG
> 
> So seems you're right, if the first byte is on the right the sensor
> produces BGGR. But for some reason the mt9v032 driver uses GRBG data.

You can change the Bayer pattern by moving the crop rectangle. That how the 
mt9v032 driver ensures a GRBG pattern even though the first active pixel in 
the sensor array is a blue one. As the MT9V034 first active pixel is located 
at different coordinates you will have to modify the crop rectangle 
computation logic to get GRBG.

> Maybe is related with following lines which writes register 0x0D Read
> Mode (p.26,27) and presumably flips row or column bytes (not sure
> about this I need to check)
> 
> 334         /* Configure the window size and row/column bin */
> 335         hratio = DIV_ROUND_CLOSEST(crop->width, format->width);
> 336         vratio = DIV_ROUND_CLOSEST(crop->height, format->height);
> 337
> 338         ret = mt9v032_write(client, MT9V032_READ_MODE,
> 339                     (hratio - 1) <<
> MT9V032_READ_MODE_ROW_BIN_SHIFT |
> 340                     (vratio - 1) << MT9V032_READ_MODE_COLUMN_BIN_SHIFT);
> 
> Nonetheless, I changed the driver to configure for BGGR pattern. Using
> the Sensor->CCDC->Preview->Resizer pipeline I captured the data with
> yavta and converted using raw2rgbpnm program.
> 
>     ./raw2rgbpnm -s 752x480 -f UYVY img-000001.uyvy img-000001.pnm
> 
> and the result is
> 
>     http://downloads.isee.biz/pub/files/patterns/img-000002.pnm
>     http://downloads.isee.biz/pub/files/patterns/img-000002.bin
> 
> The image looks better than older, not perfect, but better. The image
> is only a bit yellowish. Could be this a hardware issue ? We are close
> to ...

It's like a white balance issue. The OMAP3 ISP hardware doesn't perform 
automatic white balance, you will need to implement an AWB algorithm in 
software. You can have a look at the omap3-isp-live project for sample code 
(http://git.ideasonboard.org/omap3-isp-live.git).

-- 
Regards,

Laurent Pinchart

