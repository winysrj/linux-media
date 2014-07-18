Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46469 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761144AbaGRJUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 05:20:21 -0400
Date: Fri, 18 Jul 2014 12:19:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] media: Use strlcpy instead of custom code
Message-ID: <20140718091946.GO16460@valkosipuli.retiisi.org.uk>
References: <1405598078-9842-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405598078-9842-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Laurent,

Thanks for the patch!

On Thu, Jul 17, 2014 at 01:54:38PM +0200, Laurent Pinchart wrote:
> Replace strncpy + manually setting the terminating '\0' with an strlcpy
> call.
> 
> Reported-by: Joe Perches <joe@perches.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
