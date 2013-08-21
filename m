Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53262 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3HUL6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 07:58:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, andriy.shevchenko@intel.com
Subject: Re: [PATCH 0/4] smiapp: Small cleanup; clock framework fixes and clock tree comments
Date: Wed, 21 Aug 2013 13:59:31 +0200
Message-ID: <2340428.qnAPLruAaP@avalon>
In-Reply-To: <1376156988-4009-1-git-send-email-sakari.ailus@iki.fi>
References: <1376156988-4009-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patches.

On Saturday 10 August 2013 20:49:44 Sakari Ailus wrote:
> Hi,
> 
> This patchset contains Andy's cleanup patch (with clamp_t replaced with
> clamp) and a few clock tree interface related fixes and a few comments to
> PLL calculation.

There's a trailing white space in patch 2/4. Appart from that, for the whole 
set,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've taken the patches in my tree (with the trailing white space removed) and 
will send a pull request.

-- 
Regards,

Laurent Pinchart

