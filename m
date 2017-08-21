Return-path: <linux-media-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60920 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753684AbdHUQVQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 12:21:16 -0400
Date: Mon, 21 Aug 2017 17:21:05 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        jonathan.chai@arm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: DRM Format Modifiers in v4l2
Message-ID: <20170821162105.GA4871@e107564-lin.cambridge.arm.com>
References: <20170821155203.GB38943@e107564-lin.cambridge.arm.com>
 <CAKMK7uFdQPUomZDCp_ak6sTsUayZuut4us08defjKmiy=24QnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKMK7uFdQPUomZDCp_ak6sTsUayZuut4us08defjKmiy=24QnA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 21, 2017 at 06:01:24PM +0200, Daniel Vetter wrote:
>On Mon, Aug 21, 2017 at 5:52 PM, Brian Starkey <brian.starkey@arm.com> wrote:
>> Hi all,
>>
>> I couldn't find this topic talked about elsewhere, but apologies if
>> it's a duplicate - I'll be glad to be steered in the direction of a
>> thread.
>>
>> We'd like to support DRM format modifiers in v4l2 in order to share
>> the description of different (mostly proprietary) buffer formats
>> between e.g. a v4l2 device and a DRM device.
>>
>> DRM format modifiers are defined in include/uapi/drm/drm_fourcc.h and
>> are a vendor-namespaced 64-bit value used to describe various
>> vendor-specific buffer layouts. They are combined with a (DRM) FourCC
>> code to give a complete description of the data contained in a buffer.
>>
>> The same modifier definition is used in the Khronos EGL extension
>> EGL_EXT_image_dma_buf_import_modifiers, and is supported in the
>> Wayland linux-dmabuf protocol.
>>
>>
>> This buffer information could of course be described in the
>> vendor-specific part of V4L2_PIX_FMT_*, but this would duplicate the
>> information already defined in drm_fourcc.h. Additionally, there
>> would be quite a format explosion where a device supports a dozen or
>> more formats, all of which can use one or more different
>> layouts/compression schemes.
>>
>> So, I'm wondering if anyone has views on how/whether this could be
>> incorporated?
>>
>> I spoke briefly about this to Laurent at LPC last year, and he
>> suggested v4l2_control as one approach.
>>
>> I also wondered if could be added in v4l2_pix_format_mplane - looks
>> like there's 8 bytes left before it exceeds the 200 bytes, or could go
>> in the reserved portion of v4l2_plane_pix_format.
>>
>> Thanks for any thoughts,
>
>One problem is that the modifers sometimes reference the DRM fourcc
>codes. v4l has a different (and incompatible set) of fourcc codes,
>whereas all the protocols and specs (you can add DRI3.1 for Xorg to
>that list btw) use both drm fourcc and drm modifiers.
>

This problem already exists (ignoring modifiers) in the case of any
v4l2 <-> DRM buffer sharing (direct video scanout, for instance).

I was hoping it would be possible to draw enough equivalency between
the different definitions to manage a useful subset through a 1:1
lookup table. If that's not possible then this gets a whole lot more
tricky. Are you already aware of incompatibilities which would prevent
it?

-Brian

>This might or might not make this proposal unworkable, but it's
>something I'd at least review carefully.
>
>Otherwise I think it'd be great if we could have one namespace for all
>modifiers, that's pretty much why we have them. Please also note that
>for drm_fourcc.h we don't require an in-kernel user for a new modifier
>since a bunch of them might need to be allocated just for
>userspace-to-userspace buffer sharing (e.g. in EGL/vk). One example
>for this would be compressed surfaces with fast-clearing, which is
>planned for i915 (but current hw can't scan it out). And we really
>want to have one namespace for everything.
>-Daniel
>-- 
>Daniel Vetter
>Software Engineer, Intel Corporation
>+41 (0) 79 365 57 48 - http://blog.ffwll.ch
