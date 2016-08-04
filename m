Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39206 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752810AbcHDMK6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 08:10:58 -0400
Date: Thu, 4 Aug 2016 15:01:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] media-ctl: Initialize ioctl arguments to 0
Message-ID: <20160804120149.GH3243@valkosipuli.retiisi.org.uk>
References: <1470310686-19896-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1470310686-19896-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 04, 2016 at 02:38:06PM +0300, Laurent Pinchart wrote:
> This ensures that the reserved fields are properly set to 0 as required
> by the API.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!!!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
