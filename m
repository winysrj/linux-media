Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40129 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbbLNPkd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 10:40:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC PATCH] vb2: Stop allocating 'alloc_ctx', just set the device instead
Date: Mon, 14 Dec 2015 17:40:43 +0200
Message-ID: <28435978.1Ghf2YSlFk@avalon>
In-Reply-To: <566ED3D4.9050803@xs4all.nl>
References: <566ED3D4.9050803@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 14 December 2015 15:36:04 Hans Verkuil wrote:
> (Before I post this as the 'final' patch and CC all the driver developers
> that are affected, I'd like to do an RFC post first. I always hated the
> alloc context for obfuscating what is really going on, but let's see what
> others think).
> 
> 
> Instead of allocating a struct that contains just a single device pointer,
> just pass that device pointer around. This avoids having to check for
> memory allocation errors and is much easier to understand since it makes
> explicit what was hidden in an opaque handle before.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

As most devices use the same allocation context for all planes, wouldn't it 
make sense to just store the struct device pointer in the queue structure ? 
The oddball driver that requires different allocation contexts (I'm thinking 
about s5p-mfc here, there might be a couple more) would have to set the 
allocation contexts properly in the queue_setup handler, but for all other 
devices you could just remove that code completely.

-- 
Regards,

Laurent Pinchart

