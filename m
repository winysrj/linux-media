Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:51680 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932111AbbBCKK2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 05:10:28 -0500
Message-ID: <54D09E86.2020400@xs4all.nl>
Date: Tue, 03 Feb 2015 11:10:14 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Miguel Casas-Sanchez <mcasas@chromium.org>,
	linux-media@vger.kernel.org
Subject: Re: Vivid test device: adding YU12
References: <CAKoAQ7=4wzPbahK7RnrCG1XJgdqon2ZBphNS_krM51+p7KT3PQ@mail.gmail.com>
In-Reply-To: <CAKoAQ7=4wzPbahK7RnrCG1XJgdqon2ZBphNS_krM51+p7KT3PQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/02/15 23:32, Miguel Casas-Sanchez wrote:
>> On 01/29/2015 03:44 AM, Miguel Casas-Sanchez wrote:
>>> Hi folks, I've been trying to add a triplanar format to those that vivid
>>> can generate, and didn't quite manage :(
>>>
>>> So, I tried adding code for it like in the patch (with some dprintk() as
>>> well) to clarify what I wanted to do. Module is insmod'ed like "insmod
>>> vivid.ko n_devs=1 node_types=0x1 multiplanar=2 vivid_debug=1"
>>
>> You are confusing something: PIX_FMT_YUV420 is single-planar, not multi-planar.
>> That is, all image data is contained in one buffer. PIX_FMT_YUV420M is multi-planar,
>> however. So you need to think which one you actually want to support.
>> Another problem is that for the chroma part you need to average the values over
>> four pixels. So the TPG needs to be aware of the previous line. This makes the TPG
>> more complicated, and of course it is the reason why I didn't implement 4:2:0
>> formats :-)
>> I would implement YUV420 first, and (if needed) YUV420M and/or NV12 can easily be
>> added later.
>> Regards,
>>         Hans
>>
> 
> So, we could call YUV420 (YU12) a tightly packed planar format :)
> because it has several planes, rigurously speaking, but they are
> laid out back-to-back in memory. Correct?

Correct.

> I was interested here precisely in using the MPLANE API, so I'd
> rather go for YUV420M directly; perhaps cheating a bit on the
> TPG calculation in the first implementation: I/we could just simplify
> the Chroma calculation to grabbing the upper-left pixel value,
> ignoring the other three. Not perfect, but for a first patch of a test
> device it should do.
> 
> WDYT?

I would actually pick YUV420 or NV12 as the initial implementation, since
you can test that with qv4l2 (it uses libv4lconvert which understands
those two formats). That way you can develop on any linux PC. Also there
is no need initially to add support for 3-plane formats, which simplifies
things. But that's just my preference.

Note that I won't accept patches that do not implement 4:2:0 correctly
(averaging four pixels). The goal of the vivid driver is to emulate
hardware as well as possible, so shortcuts with that are a no-go.

Regards,

	Hans

> 
>>
>>
>>> With the patch, vivid:
>>> - seems to enumerate the new triplanar format all right
>>> - vid_s_fmt_vid_cap() works as intended too, apparently
>>> - when arriving to vid_cap_queue_setup(), the size of the different
>>> sub-arrays does not look quite ok.
>>> - Generated video is, visually, all green.
>>>
>>> I added as well a capture output dmesgs. Not much of interest here, the
>>> first few lines configure the queue -- with my few added dprintk it can be
>>> seen that the queue sizes are seemingly incorrect.
>>>
>>> If and when this part is up and running, I wanted to use Vivid to test
>>> dma-buf based capture.
>>>
>>> Big thanks!
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

