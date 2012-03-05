Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46519 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab2CELao (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 06:30:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com
Subject: Re: [PATCH v4 29/34] omap3isp: Default link validation for ccp2, csi2, preview and resizer
Date: Mon, 05 Mar 2012 12:31:04 +0100
Message-ID: <5457219.tDkWgqCPuT@avalon>
In-Reply-To: <1330709442-16654-29-git-send-email-sakari.ailus@iki.fi>
References: <20120302173219.GA15695@valkosipuli.localdomain> <1330709442-16654-29-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 02 March 2012 19:30:37 Sakari Ailus wrote:
> Use default link validation for ccp2, csi2, preview and resizer. On ccp2,
> csi2 and ccdc we also collect information on external subdevs as one may be
> connected to those entities.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

