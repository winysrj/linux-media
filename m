Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60137 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751551AbaIYVaE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 17:30:04 -0400
Date: Fri, 26 Sep 2014 00:29:54 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: Fix division by 0
Message-ID: <20140925212953.GN2939@valkosipuli.retiisi.org.uk>
References: <1411647887-5593-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411647887-5593-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 25, 2014 at 03:24:47PM +0300, Laurent Pinchart wrote:
> If the requested clock rate passed to the XCLK set_rate or round_rate
> operation is 0, the driver will try to divide by 0. Fix this.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
