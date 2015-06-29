Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57153 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbbF2HXi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 03:23:38 -0400
Message-ID: <5590F276.40909@linux.intel.com>
Date: Mon, 29 Jun 2015 10:23:34 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	s.nawrocki@samsung.com
Subject: Re: [PATCH] [media] v4l2-subdev: return -EPIPE instead of
 -EINVAL in link validate default
References: <1435538742-32447-1-git-send-email-helen.fornazier@gmail.com>
In-Reply-To: <1435538742-32447-1-git-send-email-helen.fornazier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

Helen Fornazier wrote:
> According to the V4L2 API, the VIDIOC_STREAMON ioctl should return EPIPE
> when the pipeline configuration is invalid.
> 
> As the .vidioc_streamon in the v4l2_ioctl_ops usually forwards the error
> caused by the v4l2_subdev_link_validate_default (if it is in use), it
> should return -EPIPE if it detects a format mismatch in the pipeline
> configuration

Only link configuration errors have yielded -EPIPE so far, sub-device
format configuration error has returned -INVAL instead as you noticed.
There are not many sources of -EINVAL while enabling streaming and all
others are directly caused by the application; I lean towards thinking
the code is good as it was. The documentation could be improved though.
It may not be clear which error codes could be caused by different
conditions.

The debug level messages from media module
(drivers/media/media-entity.c) do provide more information if needed,
albeit this certainly is not an application interface.

I wonder what others think.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
