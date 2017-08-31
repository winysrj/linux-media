Return-path: <linux-media-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:57374 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751422AbdHaPX4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 11:23:56 -0400
Date: Thu, 31 Aug 2017 16:23:48 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Daniel Vetter <daniel@ffwll.ch>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        jonathan.chai@arm.com, dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: DRM Format Modifiers in v4l2
Message-ID: <20170831152347.GA21158@e107564-lin.cambridge.arm.com>
References: <20170824111430.GB25711@e107564-lin.cambridge.arm.com>
 <f41c48df-6337-6d15-c629-9d365e478873@xs4all.nl>
 <20170830103040.GA19103@e107564-lin.cambridge.arm.com>
 <2089286.L0REA3WtaS@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2089286.L0REA3WtaS@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Aug 31, 2017 at 05:51:33PM +0300, Laurent Pinchart wrote:
>Hi Brian,
>
>On Wednesday, 30 August 2017 13:32:01 EEST Brian Starkey wrote:
>> On Wed, Aug 30, 2017 at 11:53:58AM +0200, Hans Verkuil wrote:
>> > On 30/08/17 11:36, Brian Starkey wrote:
>> >> On Wed, Aug 30, 2017 at 10:10:01AM +0200, Hans Verkuil wrote:
>> >>> On 30/08/17 09:50, Daniel Vetter wrote:
>> >>>> On Tue, Aug 29, 2017 at 10:47:01AM +0100, Brian Starkey wrote:
>> >>>>> The fact is, adding special formats for each combination is
>> >>>>> unmanageable - we're talking dozens in the case of our hardware.
>> >>>>
>> >>>> Hm right, we can just remap the special combos to the drm-fourcc +
>> >>>> modifier style. Bonus point if v4l does that in the core so not
>> >>>> everyone has to reinvent that wheel :-)
>> >>>
>> >>> Probably not something we'll do: there are I believe only two drivers
>> >>> that are affected (exynos & mediatek), so they can do that in their
>> >>> driver.
>> >>>
>> >>> Question: how many modifiers will typically apply to a format? I ask
>> >>> because I realized that V4L2 could use VIDIOC_ENUMFMT to make the link
>> >>> between a fourcc and modifiers:
>> >>>
>> >>> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-enum-fmt.html
>> >>>
>> >>> The __u32 reserved[4] array can be used to provide a bitmask to modifier
>> >>> indices (for the integer menu control). It's similar to what drm does,
>> >>> except instead of modifiers mapping to fourccs it is the other way
>> >>> around.
>> >>>
>> >>> This would avoid having to change the modifiers control whenever a new
>> >>> format is set and it makes it easy to enumerate all combinations.
>> >>>
>> >>> But this only works if the total number of modifiers used by a single
>> >>> driver is expected to remain small (let's say no more than 64).
>> >>
>> >> In our current (yet to be submitted) description, we've got around a
>> >> dozen modifiers for any one format to describe our compression
>> >> variants. We have a lot of on/off toggles which leads to combinatorial
>> >> expansion, so it can grow pretty quickly (though I am trying to limit
>> >> the valid combinations as much as possible).
>> >>
>> >> How about if the mask fills up then VIDIOC_ENUM_FMT can return another
>> >> fmtdsc with the same FourCC and different modifier bitmask, where the
>> >> second one's modifier bitmask is for the next "N" modifiers?
>> >
>> > I was thinking along similar lines, but it could cause some problems with
>> > the ABI since applications currently assume that no fourcc will appear
>> > twice when enumerating formats. Admittedly, we never explicitly said in
>> > the spec that that can't happen, but it is kind of expected.
>> >
>> > There are ways around that, but if possible I'd like to avoid that.
>> >
>> > In theory there are up to 128 bits available but I can't help thinking
>> > that if you create more than, say, 64 modifiers for a HW platform you
>> > have a big mess anyway.
>> >
>> > If I am wrong, then I need to know because then I can prepare for it
>> > (or whoever is going to actually implement this...)
>>
>> You're probably right, but I can't speak for everyone. From the
>> current state of drm_fourcc.h it looks like 64 would be plenty (there
>> aren't anywhere near 64 modifiers even defined right now). Adding in
>> the Arm compression formats will expand it a lot, but still not to 64
>> (yet).
>
>Do all those modifiers make sense on the V4L2 side ? I expect that some
>modifiers will mostly be used for buffers shared between the GPU and the
>display engine, while others will be used by codecs. The sets will likely
>overlap, but might not be identical.
>

All of the ones from drm_fourcc.h - I expect not. In the case of Arm's
framebuffer compression though, it's used in all our media IPs;
Display, GPU and Video, and ideally on all data exchanged between
them. For the most part the modifiers describing it could apply to
all three.

There's also the question of what you're calling a codec - mem2mem
rotation blocks/scalers/etc. exposed via V4L2 would likely want the
same set as any display device which consumes their output (which I
think puts them firmly in the shared between the XXX and display
engine camp).

Cheers,
-Brian

>> > If the number of modifiers is expected to be limited then making 64 bits
>> > available would be good enough, at least for now.
>> >
>> > BTW, is a modifier always optional? I.e. for all fourccs, is the
>> > unmodified format always available? Or are there fourccs that require the
>> > use of a modifier?
>>
>> We do actually have one or two formats which are only supported with a
>> modifier (on our HW).
>
>-- 
>Regards,
>
>Laurent Pinchart
>
