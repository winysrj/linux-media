Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56659 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751003Ab2JTVe4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 17:34:56 -0400
Date: Sun, 21 Oct 2012 00:34:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Don't warn during link validation when
 encountering a V4L2 devnode
Message-ID: <20121020213451.GQ21261@valkosipuli.retiisi.org.uk>
References: <1350767073-9478-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350767073-9478-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 20, 2012 at 11:04:33PM +0200, Laurent Pinchart wrote:
> v4l2_subdev_link_validate_get_format() retrieves the remote pad format
> depending on the entity type and prints a warning if the entity type is
> not supported. The type check doesn't take the subtype into account, and
> thus always prints a warning for device node types, even when supported.
> Fix it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
