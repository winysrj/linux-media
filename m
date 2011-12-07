Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:55892 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab1LGSYT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 13:24:19 -0500
Date: Wed, 7 Dec 2011 20:24:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] as3645a: Handle power on errors when registering the
 device
Message-ID: <20111207182415.GG938@valkosipuli.localdomain>
References: <1323264460-17846-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323264460-17846-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Dec 07, 2011 at 02:27:40PM +0100, Laurent Pinchart wrote:
> Return an error in the registered handler if the device can't be powered
> on.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks for the patch!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
