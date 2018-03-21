Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:39273 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbeCUI2m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 04:28:42 -0400
Received: by mail-wm0-f54.google.com with SMTP id f125so8131968wme.4
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2018 01:28:42 -0700 (PDT)
Date: Wed, 21 Mar 2018 09:28:39 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: christian.koenig@amd.com
Cc: Daniel Vetter <daniel@ffwll.ch>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
Message-ID: <20180321082839.GA14155@phenom.ffwll.local>
References: <20180316132049.1748-1-christian.koenig@amd.com>
 <20180316132049.1748-2-christian.koenig@amd.com>
 <152120831102.25315.4326885184264378830@mail.alporthouse.com>
 <21879456-db47-589c-b5e2-dfe8333d9e4c@gmail.com>
 <152147480241.18954.4556582215766884582@mail.alporthouse.com>
 <0bd85f69-c64c-70d1-a4a0-10ae0ed8b4e8@gmail.com>
 <CAKMK7uH3xNkx3UFBMdcJ415F2WsC7s_D+CDAjLAh1p-xo5RfSA@mail.gmail.com>
 <19ed21a5-805d-271f-9120-49e0c00f510f@amd.com>
 <20180320140810.GU14155@phenom.ffwll.local>
 <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 20, 2018 at 06:47:57PM +0100, Christian König wrote:
> Am 20.03.2018 um 15:08 schrieb Daniel Vetter:
> > [SNIP]
> > For the in-driver reservation path (CS) having a slow-path that grabs a
> > temporary reference, drops the vram lock and then locks the reservation
> > normally (using the acquire context used already for the entire CS) is a
> > bit tricky, but totally feasible. Ttm doesn't do that though.
> 
> That is exactly what we do in amdgpu as well, it's just not very efficient
> nor reliable to retry getting the right pages for a submission over and over
> again.

Out of curiosity, where's that code? I did read the ttm eviction code way
back, and that one definitely didn't do that. Would be interesting to
update my understanding.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
