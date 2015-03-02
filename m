Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59778 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751098AbbCBJkg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2015 04:40:36 -0500
Date: Mon, 2 Mar 2015 11:40:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 1/7] v4l2-subdev: replace v4l2_subdev_fh by
 v4l2_subdev_pad_config
Message-ID: <20150302094032.GR6539@valkosipuli.retiisi.org.uk>
References: <1423827006-32878-1-git-send-email-hverkuil@xs4all.nl>
 <1423827006-32878-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1423827006-32878-2-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 13, 2015 at 12:30:00PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If a subdevice pad op is called from a bridge driver, then there is
> no v4l2_subdev_fh struct that can be passed to the subdevice. This
> made it hard to use such subdevs from a bridge driver.
> 
> This patch replaces the v4l2_subdev_fh pointer by a v4l2_subdev_pad_config
> pointer in the pad ops. This allows bridge drivers to use the various
> try_ pad ops by creating a v4l2_subdev_pad_config struct and passing it
> along to the pad op.
> 
> The v4l2_subdev_get_try_* macros had to be changed because of this, so
> I also took the opportunity to use the full name of the v4l2_subdev_get_try_*
> functions in the __V4L2_SUBDEV_MK_GET_TRY macro arguments: if you now do
> 'git grep v4l2_subdev_get_try_format' you will actually find the header
> where it is defined.
> 
> One remark regarding the drivers/staging/media/davinci_vpfe patches: the
> *_init_formats() functions assumed that fh could be NULL. However, that's
> not true for this driver, it's always set. This is almost certainly a copy
> and paste from the omap3isp driver. I've updated the code to reflect the
> fact that fh is never NULL.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks! For smiapp:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
