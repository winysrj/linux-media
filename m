Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbbFBW3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2015 18:29:13 -0400
Date: Tue, 2 Jun 2015 15:29:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	mgorman@suse.de, Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 2/9] mm: Provide new get_vaddr_frames() helper
Message-Id: <20150602152912.4851e6fd4213828ddf7eb5b2@linux-foundation.org>
In-Reply-To: <20150602152300.GD17315@quack.suse.cz>
References: <1431522495-4692-1-git-send-email-jack@suse.cz>
	<1431522495-4692-3-git-send-email-jack@suse.cz>
	<20150528162402.19a0a26a5b9eae36aa8050e5@linux-foundation.org>
	<20150602152300.GD17315@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2 Jun 2015 17:23:00 +0200 Jan Kara <jack@suse.cz> wrote:

> > That's a lump of new code which many kernels won't be needing.  Can we
> > put all this in a new .c file and select it within drivers/media
> > Kconfig?
>   So the attached patch should do what you had in mind. OK?

lgtm.

>  drivers/gpu/drm/exynos/Kconfig      |   1 +
>  drivers/media/platform/omap/Kconfig |   1 +
>  drivers/media/v4l2-core/Kconfig     |   1 +
>  mm/Kconfig                          |   3 +
>  mm/Makefile                         |   1 +
>  mm/frame-vec.c                      | 233 ++++++++++++++++++++++++++++++++++++

But frame_vector.c would be a more pleasing name.  For `struct frame_vector'.
