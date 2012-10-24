Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58231 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756417Ab2JXRMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 13:12:13 -0400
Date: Wed, 24 Oct 2012 20:12:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] omap3isp: preview: Add support for 8-bit formats at
 the sink pad
Message-ID: <20121024171208.GB23933@valkosipuli.retiisi.org.uk>
References: <1350991419-23028-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1350997862-18880-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350997862-18880-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 23, 2012 at 03:11:02PM +0200, Laurent Pinchart wrote:
> Support both grayscale (Y8) and Bayer (SBGGR8, SGBRG8, SGRBG8 and
> SRGGB8) formats.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
