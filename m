Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:57751 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752296AbbIDMdD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 08:33:03 -0400
Message-ID: <55E98F41.1080705@xs4all.nl>
Date: Fri, 04 Sep 2015 14:32:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	lars@metafoo.de
CC: linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/3] adv7180: implement g_std() method
References: <6015647.cjLjRfTWc7@wasted.cogentembedded.com> <55445603.CDVZru8CKl@wasted.cogentembedded.com> <55E989CC.60900@xs4all.nl>
In-Reply-To: <55E989CC.60900@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/2015 02:08 PM, Hans Verkuil wrote:
> On 09/04/2015 01:14 AM, Sergei Shtylyov wrote:
>> Commit cccb83f7a184 ([media] adv7180: add more subdev video ops) forgot to add
>> the g_std() video method. Its implementation seems identical to the querystd()
>> method,  so we  can just  point at adv7180_querystd()...
>>
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>
>> ---
>>  drivers/media/i2c/adv7180.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> Index: media_tree/drivers/media/i2c/adv7180.c
>> ===================================================================
>> --- media_tree.orig/drivers/media/i2c/adv7180.c
>> +++ media_tree/drivers/media/i2c/adv7180.c
>> @@ -717,6 +717,7 @@ static int adv7180_g_mbus_config(struct
>>  }
>>  
>>  static const struct v4l2_subdev_video_ops adv7180_video_ops = {
>> +	.g_std = adv7180_querystd,
> 
> No, this isn't right. Not your fault, the adv7180 driver is badly coded.
> 
> The adv7180 driver implements this 'autodetect' mode which is enabled
> when s_std is called with V4L2_STD_ALL. This is illegal according to the
> spec. Digging deeper shows that only the sta2x11_vip.c driver uses this
> 'feature':
> 
> static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id std)
> {
>         struct sta2x11_vip *vip = video_drvdata(file);
>         v4l2_std_id oldstd = vip->std, newstd;
>         int status;
> 
>         if (V4L2_STD_ALL == std) {
>                 v4l2_subdev_call(vip->decoder, video, s_std, std);
>                 ssleep(2);
>                 v4l2_subdev_call(vip->decoder, video, querystd, &newstd);
>                 v4l2_subdev_call(vip->decoder, video, g_input_status, &status);
>                 if (status & V4L2_IN_ST_NO_SIGNAL)
>                         return -EIO;
>                 std = vip->std = newstd;
>                 if (oldstd != std) {
>                         if (V4L2_STD_525_60 & std)
>                                 vip->format = formats_60[0];
>                         else
>                                 vip->format = formats_50[0];
>                 }
>                 return 0;
>         }
> 
>         if (oldstd != std) {
>                 if (V4L2_STD_525_60 & std)
>                         vip->format = formats_60[0];
>                 else
>                         vip->format = formats_50[0];
>         }
> 
>         return v4l2_subdev_call(vip->decoder, video, s_std, std);
> }
> 
> So it enables the autodetect, queries the standard and uses the resulting
> standard.
> 
> It leaves the autodetect feature on as well which can be very dangerous
> if it switches from NTSC to PAL since the buffer size increases in that
> case, potentially leading to buffer overruns.
> 
> What you should do is to completely remove the autodetect feature from the
> adv7180 driver, 

A quick follow-up to this: in adv7180_irq it does:

        if (isr3 & ADV7180_IRQ3_AD_CHANGE && state->autodetect)
                __adv7180_status(state, NULL, &state->curr_norm);

If we remove the autodetect 'feature', then this would be removed as well,
however, what would be better is to replace the call to __adv7180_status()
with generating a V4L2_EVENT_SOURCE_CHANGE event (v4l2_subdev_notify_event).

That way applications can be informed of source change events (assuming the
bridge driver will pass it through, but that's not the concern of the
adv7180 driver).

Regards,

	Hans
