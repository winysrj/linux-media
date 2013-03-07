Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:39220 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3CGKLF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 05:11:05 -0500
Received: by mail-wg0-f51.google.com with SMTP id 8so415116wgl.18
        for <linux-media@vger.kernel.org>; Thu, 07 Mar 2013 02:11:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1303051845060.25837@axis700.grange>
References: <1360948121.29406.15.camel@mars>
	<20130215172452.GA27113@kroah.com>
	<1361009964.5028.3.camel@mars>
	<Pine.LNX.4.64.1303051845060.25837@axis700.grange>
Date: Thu, 7 Mar 2013 11:11:04 +0100
Message-ID: <CACKLOr0smOW2cukSmeoexq3=b=dpGw=CDO3qo=gGm4+28iwb8Q@mail.gmail.com>
Subject: Re: [PATCH v2] media: i.MX27 camera: fix picture source width
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Fritz <chf.fritz@googlemail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	"Hans J. Koch" <hjk@hansjkoch.de>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
sorry for the long delay. I missed this one.

On 5 March 2013 18:56, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> (Javier's opinion requested)
>
> I'm no expert in i.MX27 hardware, would be great to have an ack from
> someone, intensively working in this area. Javier, what do you think? Is
> this really correct always for channel 1, or should this calculation
> depend on the pixel format?
>
> Thanks
> Guennadi
>
> On Sat, 16 Feb 2013, Christoph Fritz wrote:
>
>> While using a mt9m001 (monochrome) camera the final output falsely gets
>> horizontally divided into two pictures.
>>
>> The issue was git bisected to commit f410991dcf1f
>>
>>   |  [media] i.MX27 camera: add support for YUV420 format
>>   |
>>   |  This patch uses channel 2 of the eMMa-PrP to convert
>>   |  format provided by the sensor to YUV420.
>>   |
>>   |  This format is very useful since it is used by the
>>   |  internal H.264 encoder.
>>
>> It sets PICTURE_X_SIZE in register PRP_SRC_FRAME_SIZE to its full width
>> while before that commit it was divided by two:
>>
>> -   writel(((bytesperline >> 1) << 16) | icd->user_height,
>> +           writel((icd->user_width << 16) | icd->user_height,
>>                     pcdev->base_emma + PRP_SRC_FRAME_SIZE);
>>
>> i.mx27 reference manual (41.6.12 PrP Source Frame Size Register) says:
>>
>>     PICTURE_X_SIZE. These bits set the frame width to be
>>     processed in number of pixels. In YUV 4:2:0 mode, Cb and
>>     Cr widths are taken as PICTURE_X_SIZE/2 pixels.  In YUV
>>     4:2:0 mode, this value should be a multiple of 8-pixels.
>>     In other modes (RGB, YUV 4:2:2 and YUV 4:4:4) it should
>>     be a multiple of 4 pixels.

Note that, according to the description in the datasheet,
PICTURE_X_SIZE is specified in pixels, not bytes. So, it is not
dependant on the format used.

>> This patch reverts to PICTURE_X_SIZE/2 for channel 1.
>>
>> Tested on Kernel 3.4, merged to 3.8rc.
>>
>> Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
>> ---
>>  drivers/media/platform/soc_camera/mx2_camera.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
>> index 8bda2c9..795bd3f 100644
>> --- a/drivers/media/platform/soc_camera/mx2_camera.c
>> +++ b/drivers/media/platform/soc_camera/mx2_camera.c
>> @@ -778,11 +778,11 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
>>       struct mx2_camera_dev *pcdev = ici->priv;
>>       struct mx2_fmt_cfg *prp = pcdev->emma_prp;
>>
>> -     writel((pcdev->s_width << 16) | pcdev->s_height,
>> -            pcdev->base_emma + PRP_SRC_FRAME_SIZE);
>>       writel(prp->cfg.src_pixel,
>>              pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
>>       if (prp->cfg.channel == 1) {
>> +             writel(((bytesperline >> 1) << 16) | pcdev->s_height,
>> +                     pcdev->base_emma + PRP_SRC_FRAME_SIZE);

If you use bytesperline here you are making this operation dependant
on the mbus format.
You should use s_width instead and there is no reason to divide it by
2 since it is already in pixels, as well as PRP_SRC_FRAME_SIZE.

>>               writel((icd->user_width << 16) | icd->user_height,
>>                       pcdev->base_emma + PRP_CH1_OUT_IMAGE_SIZE);
>>               writel(bytesperline,
>> @@ -790,6 +790,8 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
>>               writel(prp->cfg.ch1_pixel,
>>                       pcdev->base_emma + PRP_CH1_PIXEL_FORMAT_CNTL);
>>       } else { /* channel 2 */
>> +             writel((pcdev->s_width << 16) | pcdev->s_height,
>> +                     pcdev->base_emma + PRP_SRC_FRAME_SIZE);
>>               writel((icd->user_width << 16) | icd->user_height,
>>                       pcdev->base_emma + PRP_CH2_OUT_IMAGE_SIZE);
>>       }
>> --
>> 1.7.10.4

We are using channel 1 here daily for capturing YUV422 and have not
experience the problem you point out.

What mbus format are you using? Could you please check if the s_width
value that your sensor mt9m001 returns is correct? Remember it should
be in pixels, not in bytes.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
