Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40274 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3JRVGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Oct 2013 17:06:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-media@vger.kernel.org
Subject: Re: Fwd: [linux-media] Patch notification: 1 patch updated
Date: Fri, 18 Oct 2013 23:06:45 +0200
Message-ID: <2080835.ZUJprPZOry@avalon>
In-Reply-To: <20131015160657.GE25034@n2100.arm.linux.org.uk>
References: <20131015160657.GE25034@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

On Tuesday 15 October 2013 17:06:57 Russell King - ARM Linux wrote:
> Bad move.

Wrong status indeed. I wasn't planning to apply the patch through my tree as 
it's part of a much larger series. Sorry for the noise.

> ----- Forwarded message from Patchwork <patchwork@linuxtv.org> -----
> 
> Date: Tue, 15 Oct 2013 15:58:03 -0000
> From: Patchwork <patchwork@linuxtv.org>
> To: rmk+kernel@arm.linux.org.uk
> Subject: [linux-media] Patch notification: 1 patch updated
> Delivery-date: Tue, 15 Oct 2013 16:58:09 +0100
> 
> Hello,
> 
> The following patch (submitted by you) has been updated in patchwork:
> 
>  * linux-media: [31/51] DMA-API: media: omap3isp: use
> dma_coerce_mask_and_coherent() - http://patchwork.linuxtv.org/patch/20178/
>      - for: Linux Media kernel patches
>     was: New
>     now: Accepted
> 
> This email is a notification only - you do not need to respond.
> 
> -
> 
> Patches submitted to linux-media@vger.kernel.org have the following
> possible states:
> 
> New: Patches not yet reviewed (typically new patches);
> 
> Under review: When it is expected that someone is reviewing it (typically,
> 	      the driver's author or maintainer). Unfortunately, patchwork
> 	      doesn't have a field to indicate who is the driver maintainer.
> 	      If in doubt about who is the driver maintainer please check the
> 	      MAINTAINERS file or ask at the ML;
> 
> Superseded: when the same patch is sent twice, or a new version of the
> 	    same patch is sent, and the maintainer identified it, the first
> 	    version is marked as such. It is also used when a patch was
> 	    superseeded by a git pull request.
> 
> Obsoleted: patch doesn't apply anymore, because the modified code doesn't
> 	   exist anymore.
> 
> Changes requested: when someone requests changes at the patch;
> 
> Rejected: When the patch is wrong or doesn't apply. Most of the
> 	  time, 'rejected' and 'changes requested' means the same thing
> 	  for the developer: he'll need to re-work on the patch.
> 
> RFC: patches marked as such and other patches that are also RFC, but the
>      patch author was not nice enough to mark them as such. That includes:
> 	- patches sent by a driver's maintainer who send patches
> 	  via git pull requests;
> 	- patches with a very active community (typically from developers
> 	  working with embedded devices), where lots of versions are
> 	  needed for the driver maintainer and/or the community to be
> 	  happy with.
> 
> Not Applicable: for patches that aren't meant to be applicable via
> 	        the media-tree.git.
> 
> Accepted: when some driver maintainer says that the patch will be applied
> 	  via his tree, or when everything is ok and it got applied
> 	  either at the main tree or via some other tree (fixes tree;
> 	  some other maintainer's tree - when it belongs to other subsystems,
> 	  etc);
> 
> If you think any status change is a mistake, please send an email to the ML.
> 
> -
> 
> This is an automated mail sent by the patchwork system at
> patchwork.linuxtv.org. To stop receiving these notifications, edit
> your mail settings at:
>   http://patchwork.linuxtv.org/mail/
> 
> ----- End forwarded message -----

-- 
Regards,

Laurent Pinchart

