Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59046 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab2BUQmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Feb 2012 11:42:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 10/33] v4l: Mark VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP obsolete
Date: Tue, 21 Feb 2012 17:42:40 +0100
Message-ID: <2997581.ShKoEXplc9@avalon>
In-Reply-To: <1329703032-31314-10-git-send-email-sakari.ailus@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-10-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 20 February 2012 03:56:49 Sakari Ailus wrote:
> These two IOCTLS are obsoleted by VIDIOC_SUBDEV_G_SELECTION and
> VIDIOC_SUBDEV_S_SELECTION. Mark them obsolete.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
