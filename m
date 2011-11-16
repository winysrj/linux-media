Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48936 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab1KPGrF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 01:47:05 -0500
Date: Wed, 16 Nov 2011 08:47:01 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com,
	andriy.shevchenko@linux.intel.com
Subject: Re: [PATCH v4 0/2] as3645a flash driver
Message-ID: <20111116064700.GA27021@valkosipuli.localdomain>
References: <1321374065-20063-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321374065-20063-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 15, 2011 at 05:21:03PM +0100, Laurent Pinchart wrote:
> Hi everybody,
> 
> v3 was missing a small bug fix (setting ctrl->cur.val to 0 before adding bits
> in the fault control read code). v4 fixes that (and also includes a cosmetic
> fix).
> 
> Laurent Pinchart (2):
>   v4l: Add over-current and indicator flash fault bits
>   as3645a: Add driver for LED flash controller

Thanks for the patchset!

For both patches:

Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
