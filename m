Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3809C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 08:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A53F20859
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 08:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfBTIjV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 03:39:21 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:50316 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbfBTIjU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 03:39:20 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id wNPNgq6JRLMwIwNPRgsycX; Wed, 20 Feb 2019 09:39:18 +0100
Subject: Re: [PATCH 01/10] media: Introduce helpers to fill pixel format
 structs
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>
References: <20190205202417.16555-1-ezequiel@collabora.com>
 <20190205202417.16555-2-ezequiel@collabora.com>
 <79ad7cf7-90d5-9542-06ea-e28ddeb14e94@xs4all.nl>
 <85ff24016b4d4b55a1a02f1aee6b42dbbaf2279a.camel@collabora.com>
 <d1ea8698-e4c6-a826-0820-b8395c8c2a6f@xs4all.nl>
 <CAAFQd5DLTOJ0kheFdxzTV7Hrtc5MpG4Utn00HgNh06d+h_qJfQ@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ea53ac3d-a337-d725-3317-1cef42481820@xs4all.nl>
Date:   Wed, 20 Feb 2019 09:39:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DLTOJ0kheFdxzTV7Hrtc5MpG4Utn00HgNh06d+h_qJfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCBowCaxp4IMQbs1WeC8zJfljmePn/F1b3pjvIKaWudPJLG7UxMxk2GrMoHI1n+/viQ3NmWXQsIyUNtC1PQbZnVYSo3X05Z9+8AtscknGjCR11mYBrc5
 AgzjBYpYHTMQMx1iC3pdXk+upbrx2sDtCvdnykllJbnZTLpXYaA87dKSjQQQ3WBgbv5nrsd8r4dUJ4sh6EHpQ8dOTdiqJGhyt7f226WpTrQZqRIDeD6V6Fxe
 ct4ZVC+FvrmPZkgmQJQNPUEPU8EiFlgzizjDZ9ieUF+kCRg/a72ZJUnotLyCFPjP+RCiyoOPD926UIYGwwdUrBC/+DkLDtc66wGHpS9yZCp2K2hbx8D+fWLP
 1EAqkKKd30deKBum6dXRINOVRYs7e131Bib7yq4qXmJopqoSaeB9l9lxKFJzRt8pZmsnQQh5rNqHuB7upt6LQATMzRTBvrYqnLE79gdxNlJgCZAMF29hEzvf
 nUI8lhwnrMXVjN0mYCKtKP01bzp/TKnmMzb3yw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/20/19 7:53 AM, Tomasz Figa wrote:
> On Thu, Feb 7, 2019 at 1:36 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> On 2/6/19 5:22 PM, Ezequiel Garcia wrote:
>>> On Wed, 2019-02-06 at 11:43 +0100, Hans Verkuil wrote:
>>>> Hi Ezequiel,
>>>>
>>>> A quick review below. This looks really useful, BTW.
>>>>
>>>> On 2/5/19 9:24 PM, Ezequiel Garcia wrote:
> 
> [snip]
>>>>> +/**
>>>>> + * struct v4l2_format_info - information about a V4L2 format
>>>>> + * @format: 4CC format identifier (V4L2_PIX_FMT_*)
>>>>> + * @header_size: Size of header, optional and used by compressed formats
>>>>> + * @num_planes: Number of planes (1 to 3)
>>>>
>>>> This is actually 1-4 since there may be an alpha channel as well. Not that we have
>>>> such formats since the only formats with an alpha channel are interleaved formats,
>>>> but it is possible.
> 
> How about 1 to VIDEO_MAX_PLANES to be a bit more consistent?
> Tbh. I'm not sure why we have that defined to 8, but if we have such
> constant already, it could make sense to use it here as well.

We didn't know at the time how many planes we would need. I think we
chose 8 because 1) that fit inside struct v4l2_format and 2) it allowed
room for planes carrying meta data.

In hindsight we probably should have chosen 4 instead of 8.

In any case, since this is an internal API I think chosing MAX_PLANES
here would waste unnecessary memory.

> 
> [snip]
>>>
>>> Also, note that drm-fourcc deprecates cpp, to support tile formats.
>>> Hopefully we don't need that here?
>>
>> We do have tile formats (V4L2_PIX_FMT_NV12MT_16X16), but it is up to the
>> driver to align width/height accordingly.
>>
> 
> I'd still make these helpers align to the constraints defined by the
> format itself (e.g. 16x16), since it doesn't cost us anything, and
> have the driver do any further alignment only if they need so.

Yes, sorry, I should have said that: for tiled pixel formats this
struct should give the alignments.

But those alignments differ from hsub/vsub: those values restrict the
resolution, but the 'tiled' alignments are on top of that.

> 
>>>
>>>>> + * @hsub: Horizontal chroma subsampling factor
>>>>> + * @vsub: Vertical chroma subsampling factor
>>>>
>>>> A bit too cryptic IMHO. I would prefer hdiv or hsubsampling. 'hsub' suggests
>>>> subtraction :-)
>>>>
>>>
>>> Ditto, this name follows drm-fourcc. I'm fine either way.
>>>
> 
> I personally like hsub and vsub too, but maybe I just spent too much
> time with DRM code. *subsampling would make the initializers super
> wide, so if we decide that we don't like *sub, I'd go with *div.
> 
>>>>> + * @multiplanar: Is it a multiplanar variant format? (e.g. NV12M)
>>>>
>>>> This should, I think, be renamed to num_non_contig_planes to indicate how many
>>>> non-contiguous planes there are in the format.
>>>>
>>>> So this value is 1 for NV12 and 2 for NV12M. For V4L2_PIX_FMT_YUV444M it is 3.
>>>>
>>>> You can stick this value directly into pixfmt_mp->num_planes.
>>>>
>>>
>>> Fine by me, but I have to admit I don't see the value of adding the
>>> number of non-contiguous planes. For multiplanar non-contiguous formats
>>> the number of planes is equal to the number of planes.
>>
>> Hmm, that's true. Choose whatever gives you the shortest code :-)
>>
>>>
>>> Although maybe it will be clear this way for readers?
>>>
>>>> As an aside: perhaps we should start calling the 'multiplanar API' the
>>>> 'multiple non-contiguous planes API', at least in the documentation. It's the
> 
> To me, "multiple non-contiguous planes API" would suggest that the
> planes themselves are non-contiguous.
> 
> Many drivers (especially Samsung ones) have a distinction between
> "color planes" and "memory planes" internally, so maybe "Multiple
> memory planes API" could make sense?

Huh, that's an idea. So _MPLANE should have been _MMPLANE?

> 
>>>> first time that I found a description that actually covers the real meaning.
>>>>
>>>
>>> Yes, indeed. In fact, my first version of this code had something like
>>> "is_noncontiguous" instead of the "multiplanar" field.
>>
>> I'm fine with that. Add a comment after it like: /* aka multiplanar */
>>
> 
> FWIW, some of the drivers have .num_cplanes and .num_mplanes in their
> format descriptors.

I think that makes sense. Good suggestion.

Regards,

	Hans
