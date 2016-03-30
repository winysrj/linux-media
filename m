Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35310 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758524AbcC3HsD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2016 03:48:03 -0400
Date: Wed, 30 Mar 2016 10:47:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, sakari.ailus@linux.intel.com,
	mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v2] [media] media: change pipeline validation return error
Message-ID: <20160330074725.GJ32125@valkosipuli.retiisi.org.uk>
References: <1459295387-12090-1-git-send-email-helen.koike@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1459295387-12090-1-git-send-email-helen.koike@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

On Tue, Mar 29, 2016 at 08:49:47PM -0300, Helen Mae Koike Fornazier wrote:
> According to the V4L2 API, the VIDIOC_STREAMON ioctl should return EPIPE
> if there is a format mismatch in the pipeline configuration.
> 
> As the .vidioc_streamon in the v4l2_ioctl_ops usually forwards the error
> caused by the v4l2_subdev_link_validate_default (if it is in use), it
> should return -EPIPE when it detect the mismatch.
> 
> When an entity is connected to a non enabled link,
> media_entity_pipeline_start should return -ENOLINK, as the link does not
> exist.
> 
> Signed-off-by: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

While at it, could you change the documentation of VIDIOC_STREAMON as well?
It documents EPIPE but no ENOLINK. I think it could be e.g.

"The driver implements Media controller interface and the pipeline link
configuration is invalid."

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
