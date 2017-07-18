Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38526 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751508AbdGRLtY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 07:49:24 -0400
Subject: Re: [PATCH v6] media: platform: Renesas IMR driver
To: Konstantin Kozhevnikov
        <konstantin.kozhevnikov@cogentembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
References: <20170623203456.503714406@cogentembedded.com>
 <589c2ca4-d1e7-86c3-1ef5-8831a54856ed@xs4all.nl>
 <45854c21-f355-37e4-b677-dddb8222e719@cogentembedded.com>
 <bb62b320-262b-0cc4-7da3-5b2c7f9c7535@cogentembedded.com>
Cc: linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bc926ba4-0c04-344e-329c-0aa1ded4ad94@xs4all.nl>
Date: Tue, 18 Jul 2017 13:49:21 +0200
MIME-Version: 1.0
In-Reply-To: <bb62b320-262b-0cc4-7da3-5b2c7f9c7535@cogentembedded.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/07/17 15:31, Konstantin Kozhevnikov wrote:
> Hello all,
> 
> the sample is made publicly available, and can be taken from https://github.com/CogentEmbedded/imr-sv-utest/blob/master/utest/utest-imr.c.
> 
> It doesn't show how luminance/chrominance correction actually works, however. That feature has been tested once a while ago, and probably we are going to release that soon.
> 
> Regarding usage of "chromacity" word in the comments, I actually meant "chrominance" or "chroma". The difference for non-native speaker is probably a bit vague, just like one between "luminance" and
> "luminosity". In the R-Car manual it is referred to as "hue", but what is meant is the "luma" and "chroma". These short forms seem a bit weird to me, hence I was using the words "luminance" and
> "chromacity". If that's confusing, I don't mind them be replaced with just "luma"/"chroma".

luma/chroma works well for me. 'chromacity' was confusing for me because it is close to
'chromaticity' which is a valid word but it has a different meaning.

> 
> For documentation part, I am not 100% sure Renesas is okay with disclosing each and every detail, it might be the case we should obtain a permit from their legals. Still, I believe the person who is
> about to use the driver is having an access to at least Technical Reference Manual of R-Car Gen2/3, so adding a reference to a chapter in TRM will most likely be sufficient.

A reference to the TRM is fine. I assume people who write code for this will have the TRM
available.

Regarding the code: having that example code is certainly useful, but what I am really looking
for is a code snippet that allocates and fills in the data to pass on with the ioctl.

Especially the handling of the 'type' field remains very fuzzy to me. Especially the fact
that it is a bitmask is strange. Usually a type is an enum that defines how to interpret
the struct (e.g. similar to type in struct v4l2_format). I get the feeling your mixing
type with flags. Perhaps if you split it up into a type and flags field things will make
more sense.

> 
> The question about usage of "user-pointer" buffers (V4L2_MEMORY_USERPTR) is a bit confusing. Indeed, right now we are using that scheme, though I wouldn't say we are absolutely required to do that.
> Specifically, we are allocating the contiguous buffers using Renesas' proprietary "mmngr" driver (it's not a rocket science thing, but it's made proprietary for some reason). Then we are using the
> buffers for various persons, both in EGL and in IMR. I guess we are okay with moving completely to DMA-fd (given the fact we have an accompanying driver "mmngrbuf" which serves for translation of
> memory pointers to DMA-fds for further cross-process sharing and stuff). I mean, if USERPTR is tagged as an obsolete / deprecated function, we are fine with dropping it. However, there is one thing
> I'd like to understand from V4L2 experts. I do see sometimes (during application closing or shortly after it) the bunches of warnings from kernel regarding "corrupted" MMU state (don't recall exactly,
> but it sounds like page which is supposed to be free gets somehow corrupted). Is that something that is related to (mis)use of USERPTR? I was trying to find out if there is any memory corruption
> caused by application logic, came to conclusion it's not. To me it looks like a race condition between unmapping of VMAs and V4L2 buffers deallocation which yields sometimes unpredictable results. Can
> you please provide some details about possible issues with usage of USERPTR with DMA-contiguous buffer driver, it would be good to find a match.

I am not aware of any warnings like you described.

Originally USERPTR was designed to be used with scatter-gather DMA engines. It requires
a really good DMA engine that is able to handle partial pages and address alignments
of 8 bytes or less. That way it allowed userspace to use malloc to allocate the buffers.

Later it was abused for embedded systems that used contiguous DMA but had special code
that carved out memory. Userspace would pass a pointer to the driver using the USERPTR
API and the driver would verify that it indeed pointed to physically contiguous memory.

When dmabuf came along (together with the CMA subsystem) the need for abusing USERPTR
in that way disappeared and our recommendation for new drivers is to always support
DMABUF and only use USERPTR if the hardware can *really* handle malloc()ed buffers.

I.e. without special alignment requirements such as the buffer must start at a page
boundary. Most hardware fails that test.

In practice we discourage the use of USERPTR for embedded systems.

Apologies for the delay in replying, I was on vacation last week.

Regards,

	Hans
