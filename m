Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:49481 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751693AbdH3JyB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 05:54:01 -0400
Subject: Re: DRM Format Modifiers in v4l2
To: Brian Starkey <brian.starkey@arm.com>
References: <CAKMK7uFdQPUomZDCp_ak6sTsUayZuut4us08defjKmiy=24QnA@mail.gmail.com>
 <47128f36-2990-bd45-ead9-06a31ed8cde0@xs4all.nl>
 <20170824111430.GB25711@e107564-lin.cambridge.arm.com>
 <ba202456-4bc6-733e-4950-88ce64ca990e@xs4all.nl>
 <20170824122647.GA28829@e107564-lin.cambridge.arm.com>
 <1503943642.3316.7.camel@ndufresne.ca>
 <CAKMK7uGaQ+9cZ2PyLkwC06Qpch3AK+Tkr4SZFZVLfUqUFKyygQ@mail.gmail.com>
 <20170829094701.GB26907@e107564-lin.cambridge.arm.com>
 <20170830075035.ojzhefm3ysqzigkg@phenom.ffwll.local>
 <4399d87d-9b60-1d8b-cb83-b62f134a0aa5@xs4all.nl>
 <20170830093621.GB15136@e107564-lin.cambridge.arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        jonathan.chai@arm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f41c48df-6337-6d15-c629-9d365e478873@xs4all.nl>
Date: Wed, 30 Aug 2017 11:53:58 +0200
MIME-Version: 1.0
In-Reply-To: <20170830093621.GB15136@e107564-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/08/17 11:36, Brian Starkey wrote:
> On Wed, Aug 30, 2017 at 10:10:01AM +0200, Hans Verkuil wrote:
>> On 30/08/17 09:50, Daniel Vetter wrote:
>>> On Tue, Aug 29, 2017 at 10:47:01AM +0100, Brian Starkey wrote:
>>>> The fact is, adding special formats for each combination is
>>>> unmanageable - we're talking dozens in the case of our hardware.
>>>
>>> Hm right, we can just remap the special combos to the drm-fourcc +
>>> modifier style. Bonus point if v4l does that in the core so not everyone
>>> has to reinvent that wheel :-)
>>
>> Probably not something we'll do: there are I believe only two drivers that
>> are affected (exynos & mediatek), so they can do that in their driver.
>>
>> Question: how many modifiers will typically apply to a format? I ask
>> because I realized that V4L2 could use VIDIOC_ENUMFMT to make the link
>> between a fourcc and modifiers:
>>
>> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-enum-fmt.html
>>
>> The __u32 reserved[4] array can be used to provide a bitmask to modifier
>> indices (for the integer menu control). It's similar to what drm does,
>> except instead of modifiers mapping to fourccs it is the other way around.
>>
>> This would avoid having to change the modifiers control whenever a new
>> format is set and it makes it easy to enumerate all combinations.
>>
>> But this only works if the total number of modifiers used by a single driver
>> is expected to remain small (let's say no more than 64).
> 
> In our current (yet to be submitted) description, we've got around a
> dozen modifiers for any one format to describe our compression
> variants. We have a lot of on/off toggles which leads to combinatorial
> expansion, so it can grow pretty quickly (though I am trying to limit
> the valid combinations as much as possible).
> 
> How about if the mask fills up then VIDIOC_ENUM_FMT can return another
> fmtdsc with the same FourCC and different modifier bitmask, where the
> second one's modifier bitmask is for the next "N" modifiers?

I was thinking along similar lines, but it could cause some problems with
the ABI since applications currently assume that no fourcc will appear
twice when enumerating formats. Admittedly, we never explicitly said in
the spec that that can't happen, but it is kind of expected.

There are ways around that, but if possible I'd like to avoid that.

In theory there are up to 128 bits available but I can't help thinking
that if you create more than, say, 64 modifiers for a HW platform you
have a big mess anyway.

If I am wrong, then I need to know because then I can prepare for it
(or whoever is going to actually implement this...)

If the number of modifiers is expected to be limited then making 64 bits
available would be good enough, at least for now.

BTW, is a modifier always optional? I.e. for all fourccs, is the unmodified
format always available? Or are there fourccs that require the use of a
modifier?

Regards,

	Hans
