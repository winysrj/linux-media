Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60197 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752513Ab2EQVEW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 17:04:22 -0400
Date: Fri, 18 May 2012 00:04:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, t.stanislaws@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L: Rename V4L2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to
 V4L2_SEL_TGT_[CROP/COMPOSE]
Message-ID: <20120517210418.GN3373@valkosipuli.retiisi.org.uk>
References: <1337015823-13603-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337015823-13603-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 14, 2012 at 07:17:03PM +0200, Sylwester Nawrocki wrote:
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

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
