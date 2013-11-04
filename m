Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44960 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751782Ab3KDNV7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Nov 2013 08:21:59 -0500
Date: Mon, 4 Nov 2013 15:21:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: omap3isp: Move code out of mutex-protected section
Message-ID: <20131104132125.GB23061@valkosipuli.retiisi.org.uk>
References: <1383559668-11003-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <20131104112010.GB21655@valkosipuli.retiisi.org.uk>
 <3877980.gXG2nDA4fQ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3877980.gXG2nDA4fQ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 04, 2013 at 02:17:53PM +0100, Laurent Pinchart wrote:
> > That return value will end up to at least one place which seems to be
> > isp_video_streamon() and, unless I'm mistaken, will cause
> > ioctl(VIDIOC_STREAMON) also return ENOTTY.
> 
> I should have split this in two patches, or at least explained the rationale 
> in the commit message. The remote subdev is always an internal ISP subdev, the 
> pad::get_fmt operation is thus guaranteed to be implemented. There's no need 
> to check for ENOIOCTLCMD.

Right; true.

If you add an explanation on that to the commit message (which I think is
much less self-evident than access to the local struct not requiring
serialisation),

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
