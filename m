Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58586 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750849AbdAPJvX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 04:51:23 -0500
Date: Mon, 16 Jan 2017 11:51:18 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] v4l: subdev: Clean up properly in subdev devnode
 registration error path
Message-ID: <20170116095117.GL10831@valkosipuli.retiisi.org.uk>
References: <20170115190530.19311-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170115190530.19311-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Jan 15, 2017 at 09:05:30PM +0200, Laurent Pinchart wrote:
> Set the subdev devnode pointer right after registration to ensure that
> later errors won't skip the subdev when unregistering all devnodes.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
