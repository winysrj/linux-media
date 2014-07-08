Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbaGHUmQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jul 2014 16:42:16 -0400
Date: Tue, 8 Jul 2014 13:46:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, thellstrom@vmware.com,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
	thierry.reding@gmail.com, ccross@google.com, daniel@ffwll.ch,
	sumit.semwal@linaro.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Updated fence patch series
Message-ID: <20140708204640.GA25937@kroah.com>
References: <20140701103432.12718.82795.stgit@patser>
 <20140702053758.GA7578@kroah.com>
 <53B3CD00.5030003@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B3CD00.5030003@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 02, 2014 at 11:12:32AM +0200, Maarten Lankhorst wrote:
> op 02-07-14 07:37, Greg KH schreef:
> > On Tue, Jul 01, 2014 at 12:57:02PM +0200, Maarten Lankhorst wrote:
> >> So after some more hacking I've moved dma-buf to its own subdirectory,
> >> drivers/dma-buf and applied the fence patches to its new place. I believe that the
> >> first patch should be applied regardless, and the rest should be ready now.
> >> :-)
> >>
> >> Changes to the fence api:
> >> - release_fence -> fence_release etc.
> >> - __fence_init -> fence_init
> >> - __fence_signal -> fence_signal_locked
> >> - __fence_is_signaled -> fence_is_signaled_locked
> >> - Changing BUG_ON to WARN_ON in fence_later, and return NULL if it triggers.
> >>
> >> Android can expose fences to userspace. It's possible to make the new fence
> >> mechanism expose the same fences to userspace by changing sync_fence_create
> >> to take a struct fence instead of a struct sync_pt. No other change is needed,
> >> because only the fence parts of struct sync_pt are used. But because the
> >> userspace fences are a separate problem and I haven't really looked at it yet
> >> I feel it should stay in staging, for now.
> > Ok, that's reasonable.
> >
> > At first glance, this all looks "sane" to me, any objection from anyone
> > if I merge this through my driver-core tree for 3.17?
> >
> Sounds good to me, let me know when you pull it in, so I can rebase my
> drm conversion on top of it. :-)

All are now queued up and in my driver-core tree in the driver-core-next
branch, you should have gotten the emails about it.

thanks,

greg k-h
