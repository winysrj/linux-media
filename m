Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:41988 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3EFAfg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 May 2013 20:35:36 -0400
Received: by mail-lb0-f170.google.com with SMTP id t11so2951818lbd.1
        for <linux-media@vger.kernel.org>; Sun, 05 May 2013 17:35:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKMK7uGJWHb7so8_uNe0JzH_EUAQLExFPda=ZR+8yuG+ALvo2w@mail.gmail.com>
References: <1367382644-30788-1-git-send-email-airlied@gmail.com>
	<CAKMK7uGJWHb7so8_uNe0JzH_EUAQLExFPda=ZR+8yuG+ALvo2w@mail.gmail.com>
Date: Mon, 6 May 2013 10:35:35 +1000
Message-ID: <CAPM=9tzW-9U+ff2818asviXtm8+56-gp3NOFxy_u1m7b21TaQg@mail.gmail.com>
Subject: Re: [PATCH] drm/udl: avoid swiotlb for imported vmap buffers.
From: Dave Airlie <airlied@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>
>> However if we don't set a dma mask on the usb device, the mapping
>> ends up using swiotlb on machines that have it enabled, which
>> is less than desireable.
>>
>> Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> Fyi for everyone else who was not on irc when Dave&I discussed this:
> This really shouldn't be required and I think the real issue is that
> udl creates a dma_buf attachement (which is needed for device dma
> only), but only really wants to do cpu access through vmap/kmap. So
> not attached the device should be good enough. Cc'ing a few more lists
> for better fyi ;-)

Though I've looked at this a bit more, and since I want to be able to expose
shared objects as proper GEM objects from the import side I really
need that list of pages.

So it looks like this won't really fly.

Dave.
