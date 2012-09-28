Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34508 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758359Ab2I1Pch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 11:32:37 -0400
Received: by pbbrr4 with SMTP id rr4so5275213pbb.19
        for <linux-media@vger.kernel.org>; Fri, 28 Sep 2012 08:32:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378805.eK71Lgs3H4@avalon>
References: <CAFqH_53EY7BcMjn+fy=KfAhSU9Ut1pcLUyrmu2kiHznrBUB2XQ@mail.gmail.com>
	<12608216.Ba7kF04BeL@avalon>
	<CAFqH_52g8nTTDQDJEzx9E9sC5GoQML7bV-hxjA8q4Q2TcDOTYg@mail.gmail.com>
	<1378805.eK71Lgs3H4@avalon>
Date: Fri, 28 Sep 2012 17:32:36 +0200
Message-ID: <CAFqH_51khWJ6RBv707J8AC9YrMhzwqg5QPuo52EYVnBOmTRpFA@mail.gmail.com>
Subject: Re: omap3isp: wrong image after resizer with mt9v034 sensor
From: =?UTF-8?Q?Enric_Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

2012/9/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Enric,
>
> On Friday 28 September 2012 10:21:56 Enric Balletbò i Serra wrote:
>> 2012/9/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> > On Thursday 27 September 2012 18:05:56 Enric Balletbò i Serra wrote:
>> >> 2012/9/27 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> >> > On Wednesday 26 September 2012 16:15:35 Enric Balletbò i Serra wrote:
>> >> >> 2012/9/26 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> >> >> > On Wednesday 26 September 2012 09:57:53 Enric Balletbò i Serra
>> >> >> > wrote:
>> >> >> >
>> >> >> > [snip]
>> >> >> >
>> >> >> >> You had reason. Checking the data lines of the camera bus with an
>> >> >> >> oscilloscope I see I had a problem, exactly in D8 /D9 data lines.
>> >> >> >
>> >> >> > I'm curious, how have you fixed that ?
>> >> >>
>> >> >> The board had a pull-down 4k7 resistor which I removed in these lines
>> >> >> (D8/D9). The board is prepared to accept sensors from 8 to 12 bits,
>> >> >> lines from D8 to D12 have a pull-down resistor to tie down the line by
>> >> >> default.
>> >> >>
>> >> >> With the oscilloscope I saw that D8/D9 had problems to go to high
>> >> >> level like you said, then I checked the schematic and I saw these
>> >> >> resistors.
>> >> >>
>> >> >> >> Now I can capture images but the color is still wrong, see the
>> >> >> >> following
>> >> >> >> image captured with pipeline SENSOR -> CCDC OUTPUT
>> >> >> >>
>> >> >> >>     http://downloads.isee.biz/pub/files/patterns/img-000001.pnm
>> >> >> >>
>> >> >> >> Now the image was converted using :
>> >> >> >>     ./raw2rgbpnm -s 752x480 -f SGRBG10 img-000001.bin
>> >> >> >>     img-000001.pnm
>> >> >> >>
>> >> >> >> And the raw data can be found here:
>> >> >> >>     http://downloads.isee.biz/pub/files/patterns/img-000001.bin
>> >> >> >>
>> >> >> >> Any idea where I can look ? Thanks.
>> >> >> >
>> >> >> > Your sensors produces BGGR data if I'm not mistaken, not GRBG.
>> >> >> > raw2rgbpnm doesn't support BGGR (yet), but the OMAP3 ISP preview
>> >> >> > engine
>> >> >> > can convert that to YUV since v3.5. Just make your sensor driver
>> >> >> > expose
>> >> >> > the right media bus format and configure the pipeline accordingly.
>> >> >>
>> >> >> The datasheet (p.10,11) says that the Pixel Color Pattern is as
>> >> >> follows.
>> >> >>
>> >> >> <------------------------ direction
>> >> >> n  4    3    2    1
>> >> >> .. GB GB GB GB
>> >> >> .. RG RG RG RG
>> >> >>
>> >> >> So seems you're right, if the first byte is on the right the sensor
>> >> >> produces BGGR. But for some reason the mt9v032 driver uses GRBG data.
>> >> >
>> >> > You can change the Bayer pattern by moving the crop rectangle. That how
>> >> > the mt9v032 driver ensures a GRBG pattern even though the first active
>> >> > pixel in the sensor array is a blue one. As the MT9V034 first active
>> >> > pixel
>> >> > is located at different coordinates you will have to modify the crop
>> >> > rectangle computation logic to get GRBG.
>> >>
>> >> Please, could you explain how to do this ? I'm a newbie into image
>> >> sensors world :-)
>> >
>> > Let's assume the following Bayer pattern (left to right and top to bottom
>> > direction).
>> >
>> >  | 1 2 3 4 5 6 7 8 ...
>> >
>> > ----------------------
>> > 1| G R G R G R G R ...
>> > 2| B G B G B G B G ...
>> > 3| G R G R G R G R ...
>> > 4| B G B G B G B G ...
>> > 5| G R G R G R G R ...
>> > 6| B G B G B G B G ...
>> > 7| G R G R G R G R ...
>> > 8| B G B G B G B G ...
>> > .| ...................
>> >
>> > If you crop the (1,1)/4x4 rectangle from that sensor you will get
>> >
>> >  | 1 2 3 4
>> >
>> > ----------
>> > 1| G R G R
>> > 2| B G B G
>> > 3| G R G R
>> > 4| B G B G
>> >
>> > which is clearly a GRBG pattern. If you crop the (2,1)/4x4 rectangle you
>> > will get
>> >
>> >  | 2 3 4 5
>> >
>> > ----------
>> > 1| R G R G
>> > 2| G B G B
>> > 3| R G R G
>> > 4| G B G B
>> >
>> > which is now a RGGB pattern. The pattern you get out of your sensor thus
>> > depends on the crop rectangle position.
>>
>> Many thanks for the explanation. I'm learning a lot with your explanations
>> :-)
>> >> >> Maybe is related with following lines which writes register 0x0D Read
>> >> >> Mode (p.26,27) and presumably flips row or column bytes (not sure
>> >> >> about this I need to check)
>> >> >>
>> >> >> 334         /* Configure the window size and row/column bin */
>> >> >> 335         hratio = DIV_ROUND_CLOSEST(crop->width, format->width);
>> >> >> 336         vratio = DIV_ROUND_CLOSEST(crop->height, format->height);
>> >> >> 337
>> >> >> 338         ret = mt9v032_write(client, MT9V032_READ_MODE,
>> >> >> 339                     (hratio - 1) <<
>> >> >> MT9V032_READ_MODE_ROW_BIN_SHIFT |
>> >> >> 340                     (vratio - 1) <<
>> >> >> MT9V032_READ_MODE_COLUMN_BIN_SHIFT);
>> >> >>
>> >> >> Nonetheless, I changed the driver to configure for BGGR pattern. Using
>> >> >> the Sensor->CCDC->Preview->Resizer pipeline I captured the data with
>> >> >> yavta and converted using raw2rgbpnm program.
>> >> >>
>> >> >>     ./raw2rgbpnm -s 752x480 -f UYVY img-000001.uyvy img-000001.pnm
>> >> >>
>> >> >> and the result is
>> >> >>
>> >> >>     http://downloads.isee.biz/pub/files/patterns/img-000002.pnm
>> >> >>     http://downloads.isee.biz/pub/files/patterns/img-000002.bin
>> >> >>
>> >> >> The image looks better than older, not perfect, but better. The image
>> >> >> is only a bit yellowish. Could be this a hardware issue ? We are close
>> >> >> to ...
>> >> >
>> >> > It's like a white balance issue. The OMAP3 ISP hardware doesn't perform
>> >> > automatic white balance, you will need to implement an AWB algorithm in
>> >> > software. You can have a look at the omap3-isp-live project for sample
>> >> > code (http://git.ideasonboard.org/omap3-isp-live.git).
>>
>> So you think the sensor is set well now ?
>
> I think so, yes.
>
>> The hardware can produce this issue ? Do you know if this algorithm is
>> implemented in gstreamer ?
>
> I don't know, but if it is the implementation will be software-based, and will
> thus be slow. The OMAP3 ISP can compute AWB-related statistics in hardware and
> can apply per-color gains to the image. The only software you then need will
> retrieve the statistics, compute the gains from them and apply the gains.
> That's what the sample code in omap3-isp-live does. This should at some point
> be integrated as a libv4l plugin.
>

So I can use your software to test if it's a white balance issue ? (as
the omap3-isp-live has this support if I understood). I'll try this,
do you can provide some tips on how use the omap3-isp-live ? Thanks
again.


> --
> Regards,
>
> Laurent Pinchart
>
