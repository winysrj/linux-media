Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58936 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753463AbbL2O17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 09:27:59 -0500
Date: Tue, 29 Dec 2015 16:27:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: omap3isp: Fix data lane shift configuration
Message-ID: <20151229142722.GC26561@valkosipuli.retiisi.org.uk>
References: <1451398311-3964-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1451398311-3964-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 29, 2015 at 04:11:51PM +0200, Laurent Pinchart wrote:
> The data-shift DT property speficies the number of bits to be shifted,
> but the driver still interprets the value as a multiple of two bits as
> used by now removed platform data support. Fix it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
