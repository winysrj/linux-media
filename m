Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:35321 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbbCPTy2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 15:54:28 -0400
MIME-Version: 1.0
In-Reply-To: <5506A13F.9060608@xs4all.nl>
References: <1426415656-20775-1-git-send-email-prabhakar.csengg@gmail.com> <5506A13F.9060608@xs4all.nl>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 16 Mar 2015 19:53:56 +0000
Message-ID: <CA+V-a8upDbCMtNxgNKa8hg=GyUT8bjJEzgC9xFu02ScXMF7ZJg@mail.gmail.com>
Subject: Re: [PATCH v6] media: i2c: add support for omnivision's ov2659 sensor
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

On Mon, Mar 16, 2015 at 9:24 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> On 03/15/2015 11:34 AM, Lad Prabhakar wrote:
>> From: Benoit Parrot <bparrot@ti.com>
>>
>> this patch adds support for omnivision's ov2659
>> sensor, the driver supports following features:
>> 1: Asynchronous probing
>> 2: DT support
>> 3: Media controller support
>>
>> Signed-off-by: Benoit Parrot <bparrot@ti.com>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  Changes for v6:
>>  a: fixed V4L2_CID_PIXEL_RATE control to use link_frequency
>>     instead of xvclk_frequency.
>>  b: Included Ack from Sakari
>>
>>  v5: https://patchwork.kernel.org/patch/6000161/
>>  v4: https://patchwork.kernel.org/patch/5961661/
>>  v3: https://patchwork.kernel.org/patch/5959401/
>>  v2: https://patchwork.kernel.org/patch/5859801/
>>  v1: https://patchwork.linuxtv.org/patch/27919/
>>
>>  .../devicetree/bindings/media/i2c/ov2659.txt       |   38 +
>>  MAINTAINERS                                        |   10 +
>>  drivers/media/i2c/Kconfig                          |   11 +
>>  drivers/media/i2c/Makefile                         |    1 +
>>  drivers/media/i2c/ov2659.c                         | 1510 ++++++++++++++++++++
>>  include/media/ov2659.h                             |   33 +
>>  6 files changed, 1603 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2659.txt
>>  create mode 100644 drivers/media/i2c/ov2659.c
>>  create mode 100644 include/media/ov2659.h
>>
>> diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
>> new file mode 100644
>> index 0000000..3ae6629
>> --- /dev/null
>> +++ b/drivers/media/i2c/ov2659.c
>
> <snip>
>
>> +static const struct ov2659_pixfmt ov2659_formats[] = {
>> +     {
>> +             .code = MEDIA_BUS_FMT_YUYV8_2X8,
>> +             .colorspace = V4L2_COLORSPACE_JPEG,
>> +             .format_ctrl_regs = ov2659_format_yuyv,
>> +     },
>> +     {
>> +             .code = MEDIA_BUS_FMT_UYVY8_2X8,
>> +             .colorspace = V4L2_COLORSPACE_JPEG,
>> +             .format_ctrl_regs = ov2659_format_uyvy,
>> +     },
>> +     {
>> +             .code = MEDIA_BUS_FMT_RGB565_2X8_BE,
>> +             .colorspace = V4L2_COLORSPACE_JPEG,
>> +             .format_ctrl_regs = ov2659_format_rgb565,
>> +     },
>> +     {
>> +             .code = MEDIA_BUS_FMT_SBGGR8_1X8,
>> +             .colorspace = V4L2_COLORSPACE_SMPTE170M,
>> +             .format_ctrl_regs = ov2659_format_bggr,
>> +     },
>> +};
>
> The colorspaces defined here make no sense. Sensors should give you
> V4L2_COLORSPACE_SRGB. Certainly not COLORSPACE_JPEG (unless they encode
> to a JPEG for you) and SMPTE170M (SDTV) is unlikely as well, unless the
> documentation explicitly states that it uses that colorspace.
>
> Unfortunately, the product brief of this sensor does not mention the
> colorimetry information at all, nor does it give any information about
> the transfer function (aka gamma) used by the sensor. Since this sensor
> is advertised as an HDTV sensor I would guess the colorspace should either
> be SRGB or REC709, depending on the transfer function used.
>
Yes it needs to be V4L2_COLORSPACE_SRGB, Ill respin fixing this.

Cheers,
--Prabhakar Lad

> I see a lot of sensor drivers that wrongly use the JPEG colorspace. I'm planning
> to fix them, since that is really wrong.
>
> Regards,
>
>         Hans
