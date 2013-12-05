Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46916 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757801Ab3LESSu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Dec 2013 13:18:50 -0500
Date: Thu, 5 Dec 2013 20:18:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: Use devm_ioremap_resource()
Message-ID: <20131205181816.GI30652@valkosipuli.retiisi.org.uk>
References: <1386177214-27132-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386177214-27132-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 04, 2013 at 06:13:34PM +0100, Laurent Pinchart wrote:
> Replace devm_request_mem_region() and devm_ioremap_nocache() with
> devm_ioremap_resource(). The behaviour remains the same and the code is
> simplified.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Nice one! :)

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
