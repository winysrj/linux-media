Return-path: <linux-media-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:41612 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750835AbdH3JgZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 05:36:25 -0400
Date: Wed, 30 Aug 2017 10:36:21 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        jonathan.chai@arm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: DRM Format Modifiers in v4l2
Message-ID: <20170830093621.GB15136@e107564-lin.cambridge.arm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4399d87d-9b60-1d8b-cb83-b62f134a0aa5@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 30, 2017 at 10:10:01AM +0200, Hans Verkuil wrote:
>On 30/08/17 09:50, Daniel Vetter wrote:
>> On Tue, Aug 29, 2017 at 10:47:01AM +0100, Brian Starkey wrote:
>>> The fact is, adding special formats for each combination is
>>> unmanageable - we're talking dozens in the case of our hardware.
>>
>> Hm right, we can just remap the special combos to the drm-fourcc +
>> modifier style. Bonus point if v4l does that in the core so not everyone
>> has to reinvent that wheel :-)
>
>Probably not something we'll do: there are I believe only two drivers that
>are affected (exynos & mediatek), so they can do that in their driver.
>
>Question: how many modifiers will typically apply to a format? I ask
>because I realized that V4L2 could use VIDIOC_ENUMFMT to make the link
>between a fourcc and modifiers:
>
>https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-enum-fmt.html
>
>The __u32 reserved[4] array can be used to provide a bitmask to modifier
>indices (for the integer menu control). It's similar to what drm does,
>except instead of modifiers mapping to fourccs it is the other way around.
>
>This would avoid having to change the modifiers control whenever a new
>format is set and it makes it easy to enumerate all combinations.
>
>But this only works if the total number of modifiers used by a single driver
>is expected to remain small (let's say no more than 64).

In our current (yet to be submitted) description, we've got around a
dozen modifiers for any one format to describe our compression
variants. We have a lot of on/off toggles which leads to combinatorial
expansion, so it can grow pretty quickly (though I am trying to limit
the valid combinations as much as possible).

How about if the mask fills up then VIDIOC_ENUM_FMT can return another
fmtdsc with the same FourCC and different modifier bitmask, where the
second one's modifier bitmask is for the next "N" modifiers?

-Brian
>
>Regards,
>
>	Hans
