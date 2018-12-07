Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97332C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 08:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C76020882
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 08:58:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C76020882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbeLGI6V (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 03:58:21 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:42906 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725976AbeLGI6V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 03:58:21 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VBxJg4yumgJOKVBxOgXuLE; Fri, 07 Dec 2018 09:58:14 +0100
Subject: Re: [PATCH 1/6] media: v4l2-subdev: stub v4l2_subdev_get_try_format()
 ??
To:     jacopo mondi <jacopo@jmondi.org>, Lubomir Rintel <lkundrak@v3.sk>
Cc:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181128171918.160643-1-lkundrak@v3.sk>
 <20181128171918.160643-2-lkundrak@v3.sk> <20181203134800.GA2901@w540>
 <680ea9621883d53712d701a9859ab2677890daca.camel@v3.sk>
 <20181206083041.GA5597@w540>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d9a4c95f-7f95-625d-2a57-e427068d5b3f@xs4all.nl>
Date:   Fri, 7 Dec 2018 09:57:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181206083041.GA5597@w540>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNUHMmLy+vjL7lLEKQUnAx0pUq3opTLdPoCBN/dZEIk7HXNvQ5QBk0Jv2SmbWE9m074u7rbaM3cqhaLtEsanD2JQ8tolUxrU5ZEylWVpZd0qMsfHw5pV
 oMRsKc32tHxwshhmohMh5UXFSVW2EuAcJt5BhEJpXGf4Irape82lKnlYzhtF/QKsC8naTWaYUCD5SFANPJm269pswAqyZNW5k0sX3f7EChkuA/nKsdN0aP4E
 DpwfdnXpPlzK+Sa5DkjKyV16FEnVSTQ2kjRqrBpCRmaRDwVypJUQzUTpHTASkx98oxx1LSlvc5+2eCjegJQFWqXfGTPZzlkTIREuYMfzgPugflWf8W8hfsFC
 +E1eV6cyFiT+Chh0QznrruJ1K48jHwFMckF8gzxUSADt+SnfRqCzkK5IAKiw59kR9fC4z0xvF82wLdsdqkFJ2uOdVfRJsKrVDZB5bes/ElM+zmqjD6U=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/06/2018 09:30 AM, jacopo mondi wrote:
> Hi Lubomir,
> 
> On Tue, Dec 04, 2018 at 04:01:43PM +0100, Lubomir Rintel wrote:
>> On Mon, 2018-12-03 at 14:48 +0100, jacopo mondi wrote:
>>> Hi Lubomir,
>>>
>>>   thanks for the patches
>>>
>>> On Wed, Nov 28, 2018 at 06:19:13PM +0100, Lubomir Rintel wrote:
>>>> Provide a dummy implementation when configured without
>>>> CONFIG_VIDEO_V4L2_SUBDEV_API to avoid ifdef dance in the drivers
>>>> that can
>>>> be built either with or without the option.
>>>>
>>>> Suggested-by: Jacopo Mondi <jacopo@jmondi.org>
>>>> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
>>>> ---
>>>>  include/media/v4l2-subdev.h | 11 +++++++++++
>>>>  1 file changed, 11 insertions(+)
>>>>
>>>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-
>>>> subdev.h
>>>> index 9102d6ca566e..906e28011bb4 100644
>>>> --- a/include/media/v4l2-subdev.h
>>>> +++ b/include/media/v4l2-subdev.h
>>>> @@ -967,6 +967,17 @@ static inline struct v4l2_rect
>>>>  		pad = 0;
>>>>  	return &cfg[pad].try_compose;
>>>>  }
>>>> +
>>>> +#else /* !defined(CONFIG_VIDEO_V4L2_SUBDEV_API) */
>>>> +
>>>> +static inline struct v4l2_mbus_framefmt
>>>> +*v4l2_subdev_get_try_format(struct v4l2_subdev *sd,
>>>> +			    struct v4l2_subdev_pad_config *cfg,
>>>> +			    unsigned int pad)
>>>> +{
>>>> +	return ERR_PTR(-ENOTTY);
>>>> +}
>>>> +
>>>>  #endif
>>>
>>> While at there, what about doing the same for get_try_crop and
>>> get_try_compose? At lease provide stubs, I let you figure out if
>>> you're willing to fix callers too, it seems there are quite a few of
>>> them though
>>>
>>> $ git grep v4l2_subdev_get_try* drivers/media/ | grep -v '_format' |
>>> wc -l
>>> 44
>>
>> I'd be happy to do that. However, the drivers that use those seem to
>> depend on CONFIG_VIDEO_V4L2_SUBDEV_API anyway. Should those
>> dependencies be eventually done away with?
>>
> 
> I don't think it is the case to drop the dependencies. If you go down
> that path you would need to be very careful. It's enough to add stubs
> for those functions like you've done for v4l2_subdev_get_try_format().
> 
> Now, looking around a bit in more detail, most sensor drivers return
> -ENOTTY if you require V4L2_SUBDEV_FORMAT_TRY format when
> CONFIG_VIDEO_V4L2_SUBDEV_API is not defined. I would say all drivers
> but mt9v111.c, which is one of the most recent ones, and that deals
> with the issue as:
> 
> static struct v4l2_mbus_framefmt *__mt9v111_get_pad_format(
> 					struct mt9v111_dev *mt9v111,
> 					struct v4l2_subdev_pad_config *cfg,
> 					unsigned int pad,
> 					enum v4l2_subdev_format_whence which)
> {
> 	switch (which) {
> 	case V4L2_SUBDEV_FORMAT_TRY:
> #if IS_ENABLED(CONFIG_VIDEO_V4L2_SUBDEV_API)
> 		return v4l2_subdev_get_try_format(&mt9v111->sd, cfg, pad);
> #else
> 		return &cfg->try_fmt;
> #endif
> 	case V4L2_SUBDEV_FORMAT_ACTIVE:
> 		return &mt9v111->fmt;
> 	default:
> 		return NULL;
> 	}
> }
> 
> Since I wrote that part, and I recall it had been suggested to me, I
> wonder which one of the two approaches it actually correct :/
> 
> 
>> Please pardon my ignorance -- I don't actually understand why would
>> anyone disable CONFIG_VIDEO_V4L2_SUBDEV_API.
> 
> The config options is described as:
> Enables the V4L2 sub-device pad-level userspace API used to configure
> video format, size and frame rate between hardware blocks.
> 
> Some driver simply do not expose a subdev in userspace. It might be
> discussed that if selecting MEDIA_CONTROLLER should in facts be enough
> and to imply CONFIG_VIDEO_V4L2_SUBDEV_API, but that's a separate
> issue.

I've thought for quite some time now that CONFIG_VIDEO_V4L2_SUBDEV_API
should be removed. I really do not see any advantage of having that config
option. You save a tiny bit of memory, at the cost of creating confusion.

Complexity is the real enemy of media drivers, and trying to keep that down
is always a good thing.

That said, removing CONFIG_VIDEO_V4L2_SUBDEV_API won't help much since in
the code above it would just replace #if IS_ENABLED(CONFIG_VIDEO_V4L2_SUBDEV_API)
by #if IS_ENABLED(CONFIG_MEDIA_CONTROLLER).

In fact, I would favor to just always enable both MEDIA_CONTROLLER and
V4L2_SUBDEV_API for V4L2 devices. They don't have to use the media controller
if they don't want to, but it's there if needed.

It simplifies a lot of code at the expense of a bit more memory usage. But
given the huge amount of memory that the video buffers take, I really don't
think that is an issue.

Also, as more and more drivers require the media controller anyway, it is likely
to be enabled in standard distros anyway. It is for debian, in any case.

I'll make an RFC patch and post it. See what people think.

Regards,

	Hans

>>
>> I'll be following up with a v2 after I get a response from you. It will
>> address locking issues found with smatch: one introduced by my patch
>> and one that was there before.
>>
> 
> Yep, ov2659 was b0rken already, thanks for fixing it while at there.
> 
> Thanks
>    j
> 
>> Cheers,
>> Lubo
>>
>>>>  extern const struct v4l2_file_operations v4l2_subdev_fops;
>>>> --
>>>> 2.19.1
>>>>
>>

