Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37367 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750840AbaLCLGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Dec 2014 06:06:09 -0500
Date: Wed, 3 Dec 2014 13:06:00 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 1/2] v4l2 subdevs: replace get/set_crop by
 get/set_selection
Message-ID: <20141203110559.GE14746@valkosipuli.retiisi.org.uk>
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Dec 02, 2014 at 01:21:40PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The crop and selection pad ops are duplicates. Replace all uses of get/set_crop
> by get/set_selection. This will make it possible to drop get/set_crop
> altogether.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>

For both: 

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Another point I'd like to draw attention to are the reserved fields --- some
drivers appear to zero them whereas some pay no attention. Shouldn't we
check in the sub-device IOCTL handler that the user has zeroed them, or zero
them for the user? I think this has probably been discussed before on V4L2.
Both have their advantages, probably zeroing them in the framework would be
the best option. What do you think?

Definitely out of scope of this set.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
