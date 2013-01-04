Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53726 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755201Ab3ADXFW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 18:05:22 -0500
Date: Sat, 5 Jan 2013 01:05:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] omap3isp: Remove unneeded memset after kzalloc
Message-ID: <20130104230517.GA13641@valkosipuli.retiisi.org.uk>
References: <1356971395-3135-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356971395-3135-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Nice patches --- thanks!!

On Mon, Dec 31, 2012 at 05:29:54PM +0100, Laurent Pinchart wrote:
> kzalloc initializes the memory it allocates to 0, there's no need for an
> explicit memset.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
