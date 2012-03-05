Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53191 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab2CEK7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 05:59:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com
Subject: Re: [PATCH v4 04/34] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION IOCTLs
Date: Mon, 05 Mar 2012 11:59:22 +0100
Message-ID: <12441257.HgrTH0oxIp@avalon>
In-Reply-To: <1330709442-16654-4-git-send-email-sakari.ailus@iki.fi>
References: <20120302173219.GA15695@valkosipuli.localdomain> <1330709442-16654-4-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 02 March 2012 19:30:12 Sakari Ailus wrote:
> Add support for VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
> IOCTLs. They replace functionality provided by VIDIOC_SUBDEV_S_CROP and
> VIDIOC_SUBDEV_G_CROP IOCTLs and also add new functionality (composing).
> 
> VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP continue to be supported.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Except for the ACTIVE name, 

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Maybe we could discuss this on IRC with Tomasz ?

-- 
Regards,

Laurent Pinchart

