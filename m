Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49776 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751454AbbCVMXv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 08:23:51 -0400
Date: Sun, 22 Mar 2015 14:23:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v1.1 14/15] omap3isp: Add support for the Device Tree
Message-ID: <20150322122317.GN16613@valkosipuli.retiisi.org.uk>
References: <2603487.gEIKMl6vV7@avalon>
 <1426889104-17921-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1426889104-17921-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sat, Mar 21, 2015 at 12:05:04AM +0200, Sakari Ailus wrote:
> Add the ISP device to omap3 DT include file and add support to the driver to
> use it.
> 
> Also obtain information on the external entities and the ISP configuration
> related to them through the Device Tree in addition to the platform data.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

If you're happy with this version, please add the set to your tree. The
patches can be also found in here, on top of your histogram DMA changes:

	ssh://linuxtv.org/git/sailus/media_tree.git rm696-054-media

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
