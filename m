Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53671 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752610Ab2GZUyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 16:54:07 -0400
Date: Thu, 26 Jul 2012 23:54:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] mt9v032: Export horizontal and vertical blanking as
 V4L2 controls
Message-ID: <20120726205401.GA26136@valkosipuli.retiisi.org.uk>
References: <1343068502-7431-4-git-send-email-laurent.pinchart@ideasonboard.com>
 <1343085042-19695-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343085042-19695-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Tue, Jul 24, 2012 at 01:10:42AM +0200, Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/mt9v032.c |   36 +++++++++++++++++++++++++++++++++---
>  1 files changed, 33 insertions(+), 3 deletions(-)
> 
> Changes since v1:
> 
> - Make sure the total horizontal time will not go below 660 when setting the
>   horizontal blanking control
> - Restrict the vertical blanking value to 3000 as documented in the datasheet.
>   Increasing the exposure time actually extends vertical blanking, as long as
>   the user doesn't forget to turn auto-exposure off...

Does binning either horizontally or vertically affect the blanking limits?
If the process is analogue then the answer is typically "yes".

It's not directly related to this patch, but the effect of the driver just
exposing one sub-device really shows better now. Besides lacking the way to
specify binning as in the V4L2 subdev API (compose selection target), the
user also can't use the crop bounds selection target to get the size of the
pixel array.

We could either accept this for the time being and fix it later on of fix it
now.

I prefer fixing it right now but admit that this patch isn't breaking
anything, it rather is missing quite relevant functionality to control the
sensor in a generic way.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
