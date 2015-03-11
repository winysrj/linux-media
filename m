Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42660 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752930AbbCKWmk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 18:42:40 -0400
Date: Thu, 12 Mar 2015 00:42:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] DocBook v4l: update bytesperline handling
Message-ID: <20150311224236.GK11954@valkosipuli.retiisi.org.uk>
References: <55002E6D.9060306@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55002E6D.9060306@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Mar 11, 2015 at 01:00:45PM +0100, Hans Verkuil wrote:
> The documentation says that the bytesperline field in v4l2_pix_format refers
> to the largest plane in the case of planar formats (i.e. multiple planes
> stores in a single buffer).
> 
> For almost all planar formats the first plane is also the largest (or equal)
> plane, except for two formats: V4L2_PIX_FMT_NV24/NV42. For this YUV 4:4:4
> format the second chroma plane is twice the size of the first luma plane.
> 
> Looking at the very few drivers that support this format the bytesperline
> value that they report is actually that of the first plane and not that
> of the largest plane.
> 
> Rather than fixing the drivers it makes more sense to update the documentation
> since it is very difficult to use the largest plane for this. You would have
> to check what the format is in order to know to which plane bytesperline
> belongs, which makes calculations much more difficult.
> 
> This patch updates the documentation accordingly.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
