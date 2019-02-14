Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F02C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 09:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B8292229F
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 09:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbfBNJUl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 04:20:41 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:55647 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726411AbfBNJUl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 04:20:41 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id uDC8gJJQcLMwIuDCBgOvOF; Thu, 14 Feb 2019 10:20:39 +0100
Subject: Re: [PATCH] media: cedrus: Forbid setting new formats on busy queues
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20190214083731.16230-1-paul.kocialkowski@bootlin.com>
 <3b24ac73-f891-533f-8563-fe38ba4a83ca@xs4all.nl>
 <0b6bd0f8f1ad67e85e00127dbf1b2c7e78efbfd0.camel@bootlin.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <351d3f52-89f2-b362-5642-821bc428d13c@xs4all.nl>
Date:   Thu, 14 Feb 2019 10:20:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <0b6bd0f8f1ad67e85e00127dbf1b2c7e78efbfd0.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAxx7G/wi2LsxtD1XNSbCsqkhFzh/TrzfAaV/D65MlazK3gRAKAHTtDxtoWm/ufmHuRsL2YuyzFgR4bkFgr1xRL/LQl1b6nUh2KTNU3wDxxvm7uSk3Nq
 yOpaQsCY5IgAEFu0/TKsJpPd0mbpRFWr5Qm3rcdj7CM1gkJwC7lAOp8wxadNMJ2O8i8AAdyijcFuJLDDLkQ7Qiaubsc6HJaq55DXdDQ/PVO7fn7bRKY9JgW5
 PZ4MjG6gi3GI4Jsf8x0l+mhCIVFYjtkTRzakUsI3SxMHr01Y4/kiC8/9Zsx0J5rRaK0EpBfvIV7v4Ycmli0K52dWp2tfmc/zErHEEIo93h2STzahZ6dNju4e
 rzyYC8CHwEqyl32YtoCoxl3ORNvYrUyRWX7Moo7nxupH3EswXJjzfdxb+y0BE8ATX4bcz2pf1DIR6IUc9wPFKccjxFEUwlecvkdIcwE7e6ytD9zvv8/dci8U
 cag1jOmeudKPv6jw
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/14/19 10:18 AM, Paul Kocialkowski wrote:
> Hi,
> 
> On Thu, 2019-02-14 at 09:59 +0100, Hans Verkuil wrote:
>> On 2/14/19 9:37 AM, Paul Kocialkowski wrote:
>>> Check that our queues are not busy before setting the format or return
>>> EBUSY if that's the case. This ensures that our format can't change
>>> once buffers are allocated for the queue.
>>>
>>> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>>> ---
>>>  drivers/staging/media/sunxi/cedrus/cedrus_video.c | 14 ++++++++++++++
>>>  1 file changed, 14 insertions(+)
>>>
>>> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
>>> index b5cc79389d67..3420a938a613 100644
>>> --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
>>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
>>> @@ -282,8 +282,15 @@ static int cedrus_s_fmt_vid_cap(struct file *file, void *priv,
>>>  {
>>>  	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
>>>  	struct cedrus_dev *dev = ctx->dev;
>>> +	struct vb2_queue *vq;
>>>  	int ret;
>>>  
>>> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
>>> +	if (!vq)
>>> +		return -EINVAL;
>>
>> Can this ever happen?
> 
> I guess not, or something would be very wrong.
> I have seen this check around when looking at how other drivers
> implement this, but it does seem overkill.
> 
> Should I get rid of it in v2?

Yes please!

Regards,

	Hans

> 
> Cheers,
> 
> Paul
> 
>> Regards,
>>
>> 	Hans
>>
>>> +	else if (vb2_is_busy(vq))
>>> +		return -EBUSY;
>>> +
>>>  	ret = cedrus_try_fmt_vid_cap(file, priv, f);
>>>  	if (ret)
>>>  		return ret;
>>> @@ -299,8 +306,15 @@ static int cedrus_s_fmt_vid_out(struct file *file, void *priv,
>>>  				struct v4l2_format *f)
>>>  {
>>>  	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
>>> +	struct vb2_queue *vq;
>>>  	int ret;
>>>  
>>> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
>>> +	if (!vq)
>>> +		return -EINVAL;
>>> +	else if (vb2_is_busy(vq))
>>> +		return -EBUSY;
>>> +
>>>  	ret = cedrus_try_fmt_vid_out(file, priv, f);
>>>  	if (ret)
>>>  		return ret;
>>>

