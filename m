Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33368 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbbETG5U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 02:57:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] omap3isp: Fix async notifier registration order
Date: Wed, 20 May 2015 09:57:33 +0300
Message-ID: <17465326.j5hDPLALfu@avalon>
In-Reply-To: <20150519234143.GA20959@earth>
References: <1432076885-5107-1-git-send-email-sakari.ailus@iki.fi> <20150519234143.GA20959@earth>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Wednesday 20 May 2015 01:41:43 Sebastian Reichel wrote:
> Hi Sakari,
> 
> On Wed, May 20, 2015 at 02:08:05AM +0300, Sakari Ailus wrote:
> > The async notifier was registered before the v4l2_device was registered
> > and before the notifier callbacks were set. This could lead to missing the
> > bound() and complete() callbacks and to attempting to spin_lock() and
> > uninitialised spin lock.
> > 
> > Also fix unregistering the async notifier in the case of an error --- the
> > function may not fail anymore after the notifier is registered.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> I already noticed this during my Camera for N900 work and solved it
> the same way, so:
> 
> Reviewed-By: Sebastian Reichel <sre@kernel.org>
> 
> You may want to add a Fixes Tag against the patch implementing the
> async notifier support in omap3isp, since its quite easy to run into
> the callback problems (at least I did) and the missing resource
> freeing (due to EPROBE_AGAIN).

Applied to my tree with the Reviewed-by and Fixes tags.

-- 
Regards,

Laurent Pinchart

