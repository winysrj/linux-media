Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43516 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab2BUPBl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Feb 2012 10:01:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 08/33] v4l: Add subdev selections documentation: svg and dia files
Date: Tue, 21 Feb 2012 16:00:57 +0100
Message-ID: <1392029.PES5QU0EJ7@avalon>
In-Reply-To: <1329703032-31314-8-git-send-email-sakari.ailus@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-8-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 20 February 2012 03:56:47 Sakari Ailus wrote:
> Add svga and dia files for V4L2 subdev selections documentation.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

The diagram look fine, although a bit complex. They could be simplified by 
merging the identical rectangles (for instance moving the sink crop selection 
label to the dotted blue rectangle, and removing the plain blue rectangle). 
I'm not sure if that would be really more readable though, it's up to you.

-- 
Regards,

Laurent Pinchart
