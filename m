Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53750 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751172Ab3KFRfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 12:35:10 -0500
Date: Wed, 6 Nov 2013 19:35:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l2-fh: Include linux/videodev2.h for enum
 v4l2_priority definition
Message-ID: <20131106173507.GL24988@valkosipuli.retiisi.org.uk>
References: <1380837570-7515-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380837570-7515-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 03, 2013 at 11:59:30PM +0200, Laurent Pinchart wrote:
> struct v4l2_fh has an enum v4l2_priority field. Make sure the enum
> definition is available by including linux/videodev2.h.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
