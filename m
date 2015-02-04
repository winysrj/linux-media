Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:53224 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932203AbbBDHVP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 02:21:15 -0500
Message-ID: <54D1C841.5090108@xs4all.nl>
Date: Wed, 04 Feb 2015 08:20:33 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Miguel Casas-Sanchez <mcasas@chromium.org>,
	linux-media@vger.kernel.org
Subject: Re: Vivid test device: adding YU12
References: <CAKoAQ7=MmJZcyGZkJwUFHL=yHZfG0AbNcZV+Ho0d6EhB5WV7nw@mail.gmail.com>
In-Reply-To: <CAKoAQ7=MmJZcyGZkJwUFHL=yHZfG0AbNcZV+Ho0d6EhB5WV7nw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/2015 01:42 AM, Miguel Casas-Sanchez wrote:
>     On 02/02/15 23:32, Miguel Casas-Sanchez wrote:
>     >> On 01/29/2015 03:44 AM, Miguel Casas-Sanchez wrote:
>     >>> Hi folks, I've been trying to add a triplanar format to those that vivid
>     >>> can generate, and didn't quite manage :(
>     >>>
>     >>> So, I tried adding code for it like in the patch (with some dprintk() as
>     >>> well) to clarify what I wanted to do. Module is insmod'ed like "insmod
>     >>> vivid.ko n_devs=1 node_types=0x1 multiplanar=2 vivid_debug=1"
>     >>
>     >> You are confusing something: PIX_FMT_YUV420 is single-planar, not multi-planar.
>     >> That is, all image data is contained in one buffer. PIX_FMT_YUV420M is multi-planar,
>     >> however. So you need to think which one you actually want to support.
>     >> Another problem is that for the chroma part you need to average the values over
>     >> four pixels. So the TPG needs to be aware of the previous line. This makes the TPG
>     >> more complicated, and of course it is the reason why I didn't implement 4:2:0
>     >> formats :-)
>     >> I would implement YUV420 first, and (if needed) YUV420M and/or NV12 can easily be
>     >> added later.
>     >> Regards,
>     >>         Hans
>     >>
>     >
>     > So, we could call YUV420 (YU12) a tightly packed planar format :)
>     > because it has several planes, rigurously speaking, but they are
>     > laid out back-to-back in memory. Correct?
>     Correct.
>     > I was interested here precisely in using the MPLANE API, so I'd
>     > rather go for YUV420M directly; perhaps cheating a bit on the
>     > TPG calculation in the first implementation: I/we could just simplify
>     > the Chroma calculation to grabbing the upper-left pixel value,
>     > ignoring the other three. Not perfect, but for a first patch of a test
>     > device it should do.
>     >
>     > WDYT?
>     I would actually pick YUV420 or NV12 as the initial implementation, since
>     you can test that with qv4l2 (it uses libv4lconvert which understands
>     those two formats). That way you can develop on any linux PC. Also there
>     is no need initially to add support for 3-plane formats, which simplifies
>     things. But that's just my preference.
> 
> 
> I'll follow your advice then.
>  
> 
>     Note that I won't accept patches that do not implement 4:2:0 correctly
>     (averaging four pixels). The goal of the vivid driver is to emulate
>     hardware as well as possible, so shortcuts with that are a no-go.
> 
> 
> Yeah sure, I meant: there were two to-do's"
> a) add NV12 (YUV420) non-multiplanar, making sure the chromas are rightly calculated
> b) add mplanar version of the previous.
> What we "argued" for a second was about the order of those two, not
> their existence :)
> 
> I think we're on to doing a) then b). Would it be ok to prepare-review-land
> them separately or rather have a single patch?

I'd keep them separately. The first patch adds support for, say, NV12, the next
for NV21, then YUV420, YVU420, YUV240M, YVU420M, NV12M, NV21M. Perhaps I'm too
optimistic here, but it should be easy to add support for all these variants
once the first is done.

Regards,

	Hans
