Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31664 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbdBWLRm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 06:17:42 -0500
Subject: Re: [PATCH v5 3/3] [media] s5p-mfc: Check and set
 'v4l2_pix_format:field' field in try_fmt
To: Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <ded4b715-39a2-adfa-0f2d-7276a0024e29@samsung.com>
Date: Thu, 23 Feb 2017 12:17:35 +0100
MIME-version: 1.0
In-reply-to: <ed287d5a-687b-b344-3f20-10154071852c@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <20170221192059.29745-1-thibault.saunier@osg.samsung.com>
 <CGME20170221192135epcas4p1811fa9ce35481d42144bdab368c9243a@epcas4p1.samsung.com>
 <20170221192059.29745-4-thibault.saunier@osg.samsung.com>
 <78444dcd-169f-0c16-0e09-6b71d1a502b2@samsung.com>
 <ed287d5a-687b-b344-3f20-10154071852c@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.02.2017 14:10, Thibault Saunier wrote:
> Hello,
>
> On 02/22/2017 06:29 AM, Andrzej Hajda wrote:
>> On 21.02.2017 20:20, Thibault Saunier wrote:
>>> It is required by the standard that the field order is set by the
>>> driver.
>>>
>>> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
>>>
>>> ---
>>>
>>> Changes in v5:
>>> - Just adapt the field and never error out.
>>>
>>> Changes in v4: None
>>> Changes in v3:
>>> - Do not check values in the g_fmt functions as Andrzej explained in previous review
>>>
>>> Changes in v2:
>>> - Fix a silly build error that slipped in while rebasing the patches
>>>
>>>   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>>> index 0976c3e0a5ce..44ed2afe0780 100644
>>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>>> @@ -386,6 +386,9 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>>>   	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
>>>   	struct s5p_mfc_fmt *fmt;
>>>   
>>> +	if (f->fmt.pix.field == V4L2_FIELD_ANY)
>>> +		f->fmt.pix.field = V4L2_FIELD_NONE;
>>> +
>> In previous version the only supported field type was NONE, here you
>> support everything.
>> If the only supported format is none you should set 'field'
>> unconditionally to NONE, nothing more.
> Afaict we  support 2 things:
>
>    1. NONE
>    2. INTERLACE
>
> Until now we were not checking what was supported or not and basically 
> ignoring that info, this patch
> keeps the old behaviour making sure to be compliant.
>
> I had a doubt and was pondering doing:
>
> ``` diff
>
> +	if (f->fmt.pix.field != V4L2_FIELD_INTERLACED)
> +		f->fmt.pix.field = V4L2_FIELD_NONE;
> +
>
> ```
>
> instead, it is probably more correct, do you think it is what should be 
> done here?

I have realized I have forgot that it is not simple mem2mem device, it
is decoder. It is feed with compressed data which is just byte stream,
the only valid field value on output side is V4L2_FIELD_NONE.
About possible interlacing we could only say in case of capture side.
And in this case there are multiple questions:
- how MFC decodes stream with interlaced content?
- is it possible to convince it to decode it as user asks?
- does it perform (de-)interlacing?
- what is implemented in the driver?

After answering above questions we will be able to say how fmt.pix.field
should be treated on capture side.
And similar question we can pose in case of encoder.

So simple patch and so many doubts.

Regards
Andrzej

>
> Regards,
>
> Thibault
>
>> Regards
>> Andrzej
>>
>>>   	mfc_debug(2, "Type is %d\n", f->type);
>>>   	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>>>   		fmt = find_format(f, MFC_FMT_DEC);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
