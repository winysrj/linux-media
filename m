Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40814 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751420AbeGBHQD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 03:16:03 -0400
Date: Mon, 2 Jul 2018 10:16:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH] media: v4l2-ctrls: Fix CID base conflict between MAX217X
 and IMX
Message-ID: <20180702071600.fnacw2nrexffech6@valkosipuli.retiisi.org.uk>
References: <1530124783-30835-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530124783-30835-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 27, 2018 at 11:39:43AM -0700, Steve Longerbeam wrote:
> When the imx-media driver was initially merged, there was a conflict
> with 8d67ae25 ("media: v4l2-ctrls: Reserve controls for MAX217X") which
> was not fixed up correctly, resulting in V4L2_CID_USER_MAX217X_BASE and
> V4L2_CID_USER_IMX_BASE taking on the same value. Fix by assigning imx
> CID base the next available range at 0x10b0.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
