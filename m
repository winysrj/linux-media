Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34569 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752861Ab2DPUBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 16:01:13 -0400
Date: Mon, 16 Apr 2012 23:01:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 8/9] omap3isp: preview: Simplify configuration
 parameters access
Message-ID: <20120416200108.GC5356@valkosipuli.localdomain>
References: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1334582994-6967-9-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334582994-6967-9-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Mon, Apr 16, 2012 at 03:29:53PM +0200, Laurent Pinchart wrote:
> Instead of using a large switch/case statement to return offsets to and
> sizes of individual preview engine parameters in the parameters and
> configuration structures, store the information in the update_attrs
> table and use it at runtime.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
