Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:42762 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdDNJfc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 05:35:32 -0400
Date: Fri, 14 Apr 2017 11:35:17 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        liviu.dudau@arm.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/6] Introduce writeback connectors
Message-ID: <20170414113517.323ab297@bbrezillon>
In-Reply-To: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Brian,

On Fri, 25 Nov 2016 16:48:58 +0000
Brian Starkey <brian.starkey@arm.com> wrote:

> Hi,
> 
> This is v3 of my series introducing a new connector type:
>  DRM_MODE_CONNECTOR_WRITEBACK
> See v1 and v2 here: [1] [2]
> 
> Writeback connectors are used to expose the memory writeback engines
> found in some display controllers, which can write a CRTC's
> composition result to a memory buffer.
> This is useful e.g. for testing, screen-recording, screenshots,
> wireless display, display cloning, memory-to-memory composition.
> 
> Writeback connectors are given a WRITEBACK_FB_ID property (which acts
> slightly differently to FB_ID, so gets a new name), as well as
> a PIXEL_FORMATS blob to list the supported writeback formats, and
> OUT_FENCE_PTR to be used for out-fences.
> 
> The changes since v2 are in the commit messages of each commit.
> 
> The main differences are:
>  - Subclass drm_connector as drm_writeback_connector
>  - Slight relaxation of core checks, to allow
>    (connector->crtc && !connector->fb)
>  - Dropped PIXEL_FORMATS_SIZE, which was redundant
>  - Reworked the event interface, drivers don't need to deal with the
>    fence directly
>  - Re-ordered the commits to introduce writeback out-fences up-front.
> 
> I've kept RFC on this series because the event reporting (introduction
> of drm_writeback_job) is probably up for debate.
> 
> v4 will be accompanied by igt tests.

I plan to add writeback support to the VC4 driver and wanted to know if
anything has changed since this v3 (IOW, do you have a v4 + igt tests
ready)?

> 
> As always, I look forward to any comments.

I'll try to review these patches. Keep in mind that I didn't follow the
initial discussions and might suggest things or ask questions that have
already been answered in previous versions of this series or on IRC.

Regards,

Boris
