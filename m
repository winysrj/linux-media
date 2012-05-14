Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43613 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247Ab2ENXU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 19:20:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	t.stanislaws@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L: Rename V4L2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to V4L2_SEL_TGT_[CROP/COMPOSE]
Date: Tue, 15 May 2012 01:21:07 +0200
Message-ID: <12276297.m66sSU3uS4@avalon>
In-Reply-To: <1337015823-13603-1-git-send-email-s.nawrocki@samsung.com>
References: <1337015823-13603-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patch.

On Monday 14 May 2012 19:17:03 Sylwester Nawrocki wrote:
> This patch drops the _ACTIVE part from the selection target names as
> a prerequisite to unify the selection target names on subdevs and regular
> video nodes.
> 
> Although not exactly the same, the meaning of V4L2_SEL_TGT_*_ACTIVE and
> V4L2_SUBDEV_SEL_TGT_*_ACTUAL selection targets is logically the same.
> Different names add to confusion where both APIs are used in a single
> driver or an application.
> The selections API is experimental, so no compatibility layer is added.
> The ABI remains unchanged.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

