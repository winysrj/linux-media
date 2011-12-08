Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:57340 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1LHOp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2011 09:45:58 -0500
Date: Thu, 8 Dec 2011 16:45:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2] as3645a: Handle power on errors when registering
 the device
Message-ID: <20111208144553.GH938@valkosipuli.localdomain>
References: <1323264460-17846-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1323342052-15808-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323342052-15808-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent!

On Thu, Dec 08, 2011 at 12:00:52PM +0100, Laurent Pinchart wrote:
> Return an error in the registered handler if the device can't be powered
> on.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Looks good to me.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
