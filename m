Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50581 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab2IZOPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 10:15:36 -0400
Received: by pbbrr4 with SMTP id rr4so1951329pbb.19
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 07:15:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4942603.aHqLq5MBAn@avalon>
References: <CAFqH_53EY7BcMjn+fy=KfAhSU9Ut1pcLUyrmu2kiHznrBUB2XQ@mail.gmail.com>
	<1982842.IhYcnQa0e6@avalon>
	<CAFqH_515+=O+s1rOZ85hzO8nnU=Fn9O=NxV_mM+4dfowb0pa7w@mail.gmail.com>
	<4942603.aHqLq5MBAn@avalon>
Date: Wed, 26 Sep 2012 16:15:35 +0200
Message-ID: <CAFqH_51XXMyN0W5tUJiUr9MUrXe1KUZT5LuD-95M7xCaFT5Kgg@mail.gmail.com>
Subject: Re: omap3isp: wrong image after resizer with mt9v034 sensor
From: =?UTF-8?Q?Enric_Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

2012/9/26 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Enric,
>
> On Wednesday 26 September 2012 09:57:53 Enric Balletbò i Serra wrote:
>
> [snip]
>
>> You had reason. Checking the data lines of the camera bus with an
>> oscilloscope I see I had a problem, exactly in D8 /D9 data lines.
>
> I'm curious, how have you fixed that ?

The board had a pull-down 4k7 resistor which I removed in these lines
(D8/D9). The board is prepared to accept sensors from 8 to 12 bits,
lines from D8 to D12 have a pull-down resistor to tie down the line by
default.

With the oscilloscope I saw that D8/D9 had problems to go to high
level like you said, then I checked the schematic and I saw these
resistors.

>
>> Now I can capture images but the color is still wrong, see the following
>> image captured with pipeline SENSOR -> CCDC OUTPUT
>>
>>     http://downloads.isee.biz/pub/files/patterns/img-000001.pnm
>>
>> Now the image was converted using :
>>
>>     ./raw2rgbpnm -s 752x480 -f SGRBG10 img-000001.bin img-000001.pnm
>>
>> And the raw data can be found here:
>>
>>     http://downloads.isee.biz/pub/files/patterns/img-000001.bin
>>
>> Any idea where I can look ? Thanks.
>
> Your sensors produces BGGR data if I'm not mistaken, not GRBG. raw2rgbpnm
> doesn't support BGGR (yet), but the OMAP3 ISP preview engine can convert that
> to YUV since v3.5. Just make your sensor driver expose the right media bus
> format and configure the pipeline accordingly.

The datasheet (p.10,11) says that the Pixel Color Pattern is as follows.

<------------------------ direction
n  4    3    2    1
.. GB GB GB GB
.. RG RG RG RG

So seems you're right, if the first byte is on the right the sensor
produces BGGR. But for some reason the mt9v032 driver uses GRBG data.
Maybe is related with following lines which writes register 0x0D Read
Mode (p.26,27) and presumably flips row or column bytes (not sure
about this I need to check)

334         /* Configure the window size and row/column bin */
335         hratio = DIV_ROUND_CLOSEST(crop->width, format->width);
336         vratio = DIV_ROUND_CLOSEST(crop->height, format->height);
337
338         ret = mt9v032_write(client, MT9V032_READ_MODE,
339                     (hratio - 1) <<
MT9V032_READ_MODE_ROW_BIN_SHIFT |
340                     (vratio - 1) << MT9V032_READ_MODE_COLUMN_BIN_SHIFT);

Nonetheless, I changed the driver to configure for BGGR pattern. Using
the Sensor->CCDC->Preview->Resizer pipeline I captured the data with
yavta and converted using raw2rgbpnm program.

    ./raw2rgbpnm -s 752x480 -f UYVY img-000001.uyvy img-000001.pnm

and the result is

    http://downloads.isee.biz/pub/files/patterns/img-000002.pnm
    http://downloads.isee.biz/pub/files/patterns/img-000002.bin

The image looks better than older, not perfect, but better. The image
is only a bit yellowish. Could be this a hardware issue ? We are close
to ...

Regards,
    Enric
