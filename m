Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f195.google.com ([209.85.160.195]:33898 "EHLO
	mail-yk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbcAXL1U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 06:27:20 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1601231926270.10701@axis700.grange>
References: <1452773908-19260-1-git-send-email-ykaneko0929@gmail.com>
	<Pine.LNX.4.64.1601231926270.10701@axis700.grange>
Date: Sun, 24 Jan 2016 20:27:19 +0900
Message-ID: <CAH1o70L8xz6Q_E2VSgFB4jXZKjLRd7dhQnFug1z7QWH+GFKeYw@mail.gmail.com>
Subject: Re: [PATCH v4] media: soc_camera: rcar_vin: Add ARGB8888 caputre
 format support
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi-san,

Thanks for your review.

2016-01-24 3:38 GMT+09:00 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> Hello Kaneko-san,
>
> I've got a question to this patch:
>
> On Thu, 14 Jan 2016, Yoshihiro Kaneko wrote:
>
>> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>>
>> This patch adds ARGB8888 capture format support for R-Car Gen3.
>>
>> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
>> ---
>>
>> This patch is based on the for-4.6-1 branch of Guennadi's v4l-dvb tree.
>>
>> v4 [Yoshihiro Kaneko]
>> * As suggested by Sergei Shtylyov
>>   - revised an error message.
>>
>> v3 [Yoshihiro Kaneko]
>> * rebased to for-4.6-1 branch of Guennadi's tree.
>>
>> v2 [Yoshihiro Kaneko]
>> * As suggested by Sergei Shtylyov
>>   - fix the coding style of the braces.
>>
>>  drivers/media/platform/soc_camera/rcar_vin.c | 21 +++++++++++++++++++--
>>  1 file changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
>> index dc75a80..07c67f6 100644
>> --- a/drivers/media/platform/soc_camera/rcar_vin.c
>> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
>> @@ -124,7 +124,7 @@
>>  #define VNDMR_EXRGB          (1 << 8)
>>  #define VNDMR_BPSM           (1 << 4)
>>  #define VNDMR_DTMD_YCSEP     (1 << 1)
>> -#define VNDMR_DTMD_ARGB1555  (1 << 0)
>> +#define VNDMR_DTMD_ARGB              (1 << 0)
>>
>>  /* Video n Data Mode Register 2 bits */
>>  #define VNDMR2_VPS           (1 << 30)
>> @@ -643,7 +643,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>>               output_is_yuv = true;
>>               break;
>>       case V4L2_PIX_FMT_RGB555X:
>> -             dmr = VNDMR_DTMD_ARGB1555;
>> +             dmr = VNDMR_DTMD_ARGB;
>>               break;
>>       case V4L2_PIX_FMT_RGB565:
>>               dmr = 0;
>> @@ -654,6 +654,14 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>
> Let me give a bit more context here for clarity:
>
>                 if (priv->chip == RCAR_GEN2 || priv->chip == RCAR_H1 ||
>                     priv->chip == RCAR_E1) {
>>                       dmr = VNDMR_EXRGB;
>>                       break;
>>               }
>
> As you can see, there's no common "break" in the "case" clause above, i.e.
> it is relying on falling through if the "if" condition isn't satisfied.
> Now you insert your new "case" here, so, the failing "if" above will fall
> through into your new case. Is this intended? This fall through was
> handling the "invalid for this SoC pixel format" case, same as your "else"
> case below. How about replacing all these cases with a "goto e_format"
> statement and put "e_format:" below "return 0;" at the end of this
> function? So, the above would become
>
>                 if (priv->chip != RCAR_GEN2 && priv->chip != RCAR_H1 &&
>                     priv->chip != RCAR_E1)
>                         goto e_format;
>
>                 dmr = VNDMR_EXRGB;
>                 break;
>
> And your addition would be
>
>                 if (priv->chip != RCAR_GEN3)
>                         goto e_format;
>
>                 dmr = VNDMR_EXRGB | VNDMR_DTMD_ARGB;
>                 break;
>
> And then
>
>                 default:
>                         goto e_format;

Sounds good.
I will fix it according to your suggestion.

Thanks,
kaneko

>
> Thanks
> Guennadi
>
>> +     case V4L2_PIX_FMT_ARGB32:
>> +             if (priv->chip == RCAR_GEN3) {
>> +                     dmr = VNDMR_EXRGB | VNDMR_DTMD_ARGB;
>> +             } else {
>> +                     dev_err(icd->parent, "Unsupported format\n");
>> +                     return -EINVAL;
>> +             }
>> +             break;
>>       default:
>>               dev_warn(icd->parent, "Invalid fourcc format (0x%x)\n",
>>                        icd->current_fmt->host_fmt->fourcc);
>> @@ -1304,6 +1312,14 @@ static const struct soc_mbus_pixelfmt rcar_vin_formats[] = {
>>               .order                  = SOC_MBUS_ORDER_LE,
>>               .layout                 = SOC_MBUS_LAYOUT_PACKED,
>>       },
>> +     {
>> +             .fourcc                 = V4L2_PIX_FMT_ARGB32,
>> +             .name                   = "ARGB8888",
>> +             .bits_per_sample        = 32,
>> +             .packing                = SOC_MBUS_PACKING_NONE,
>> +             .order                  = SOC_MBUS_ORDER_LE,
>> +             .layout                 = SOC_MBUS_LAYOUT_PACKED,
>> +     },
>>  };
>>
>>  static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
>> @@ -1611,6 +1627,7 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
>>       case V4L2_PIX_FMT_RGB32:
>>               can_scale = priv->chip != RCAR_E1;
>>               break;
>> +     case V4L2_PIX_FMT_ARGB32:
>>       case V4L2_PIX_FMT_UYVY:
>>       case V4L2_PIX_FMT_YUYV:
>>       case V4L2_PIX_FMT_RGB565:
>> --
>> 1.9.1
>>
