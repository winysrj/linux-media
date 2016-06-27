Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53070 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750736AbcF0J57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 05:57:59 -0400
Date: Mon, 27 Jun 2016 12:57:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] videodev2.h: Group YUV 3 planes formats together
Message-ID: <20160627095724.GV24980@valkosipuli.retiisi.org.uk>
References: <1466033594-10120-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1466033594-10120-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Jun 16, 2016 at 02:33:14AM +0300, Laurent Pinchart wrote:
> The formats are interleaved with the YUV packed and miscellaneous
> formats, making the result confusing especially with the YUV444 format
> being packed and not planar like YUV410 or YUV420. Move them to their
> own group as the 2 planes or 3 non-contiguous planes formats to clarify
> the header.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

For the two:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
