Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45576 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab3KVQRi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Nov 2013 11:17:38 -0500
Received: by mail-ob0-f176.google.com with SMTP id va2so1493367obc.7
        for <linux-media@vger.kernel.org>; Fri, 22 Nov 2013 08:17:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <86d2lsem3m.fsf@miki.keithp.com>
References: <1385093524-22276-1-git-send-email-keithp@keithp.com>
	<20131122102632.GQ27344@phenom.ffwll.local>
	<86d2lsem3m.fsf@miki.keithp.com>
Date: Fri, 22 Nov 2013 17:17:37 +0100
Message-ID: <CAKMK7uEqHKOmMFXZLKno1q08X1B=U7XcJiExHaHbO9VdMeCihQ@mail.gmail.com>
Subject: Re: [Mesa-dev] [PATCH] dri3, i915, i965: Add __DRI_IMAGE_FOURCC_SARGB8888
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Mesa Dev <mesa-dev@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 22, 2013 at 12:01 PM, Keith Packard <keithp@keithp.com> wrote:
> Daniel Vetter <daniel@ffwll.ch> writes:
>
>> Hm, where do we have the canonical source for all these fourcc codes? I'm
>> asking since we have our own copy in the kernel as drm_fourcc.h, and that
>> one is part of the userspace ABI since we use it to pass around
>> framebuffer formats and format lists.
>
> I think it's the kernel? I really don't know, as the whole notion of
> fourcc codes seems crazy to me...
>
> Feel free to steal this code and stick it in the kernel if you like.

Well, I wasn't ever in favour of using fourcc codes since they're just
not standardized at all, highly redundant in some cases and also miss
lots of stuff we actually need (like all the rgb formats).

Cc'ing the heck out of this to get kernel people to hopefully notice.
Maybe someone takes charge of this ... Otherwise meh.

>> Just afraid to create long-term maintainance madness here with the
>> kernel's iron thou-shalt-not-break-userspace-ever rule ... Not likely
>> we'll ever accept srgb for framebuffers though.
>
> Would suck to collide with something we do want though.

Yeah, it'd suck. But given how fourcc works we probably have that
already, just haven't noticed yet :(
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
