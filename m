Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:43144 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdDNKL0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 06:11:26 -0400
Date: Fri, 14 Apr 2017 12:11:14 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        liviu.dudau@arm.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 2/6] drm: writeback: Add out-fences for writeback
 connectors
Message-ID: <20170414121114.6e6eee7a@bbrezillon>
In-Reply-To: <1480092544-1725-3-git-send-email-brian.starkey@arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
        <1480092544-1725-3-git-send-email-brian.starkey@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 Nov 2016 16:49:00 +0000
Brian Starkey <brian.starkey@arm.com> wrote:

> Add the OUT_FENCE_PTR property to writeback connectors, to enable
> userspace to get a fence which will signal once the writeback is
> complete. It is not allowed to request an out-fence without a
> framebuffer attached to the connector.
> 
> A timeline is added to drm_writeback_connector for use by the writeback
> out-fences.
> 
> In the case of a commit failure or DRM_MODE_ATOMIC_TEST_ONLY, the fence
> is set to -1.
> 
> Changes from v2:
>  - Rebase onto Gustavo Padovan's v9 explicit sync series
>  - Change out_fence_ptr type to s32 __user *

Don't know what happened, but I still see s32 __user * types in this
patch (I had to patch it to make in work on top of 4.11-rc1).
