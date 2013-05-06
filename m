Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47108 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3EFP4Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 11:56:25 -0400
Received: by mail-wg0-f42.google.com with SMTP id j13so2832142wgh.3
        for <linux-media@vger.kernel.org>; Mon, 06 May 2013 08:56:23 -0700 (PDT)
Date: Mon, 6 May 2013 17:59:30 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] drm/udl: avoid swiotlb for imported vmap buffers.
Message-ID: <20130506155930.GG5763@phenom.ffwll.local>
References: <1367382644-30788-1-git-send-email-airlied@gmail.com>
 <CAKMK7uGJWHb7so8_uNe0JzH_EUAQLExFPda=ZR+8yuG+ALvo2w@mail.gmail.com>
 <CAPM=9tzW-9U+ff2818asviXtm8+56-gp3NOFxy_u1m7b21TaQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tzW-9U+ff2818asviXtm8+56-gp3NOFxy_u1m7b21TaQg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 06, 2013 at 10:35:35AM +1000, Dave Airlie wrote:
> >>
> >> However if we don't set a dma mask on the usb device, the mapping
> >> ends up using swiotlb on machines that have it enabled, which
> >> is less than desireable.
> >>
> >> Signed-off-by: Dave Airlie <airlied@redhat.com>
> >
> > Fyi for everyone else who was not on irc when Dave&I discussed this:
> > This really shouldn't be required and I think the real issue is that
> > udl creates a dma_buf attachement (which is needed for device dma
> > only), but only really wants to do cpu access through vmap/kmap. So
> > not attached the device should be good enough. Cc'ing a few more lists
> > for better fyi ;-)
> 
> Though I've looked at this a bit more, and since I want to be able to expose
> shared objects as proper GEM objects from the import side I really
> need that list of pages.

Hm, what does "proper GEM object" mean in the context of udl?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
