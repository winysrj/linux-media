Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38144 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab1LATGt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 14:06:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gary Thomas <gary@mlbassoc.com>
Subject: Re: [PATCH] omap_vout: Fix compile error in 3.1
Date: Thu, 1 Dec 2011 20:06:54 +0100
Cc: linux-media@vger.kernel.org
References: <4ED7783D.8080801@mlbassoc.com>
In-Reply-To: <4ED7783D.8080801@mlbassoc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112012006.55844.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

On Thursday 01 December 2011 13:51:09 Gary Thomas wrote:
> This patch is against the mainline v3.1 release (c3b92c8) and
> fixes a compile error when building for OMAP3+DSS+VOUT

Thanks for the patch.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

In the future, could you please send patches inlined instead of as an 
attachment ? It makes it easier for developers to review the patches, and they 
can be picked by automated tools such as patchwork.

I highly recommend using git send-email to send patches to mailing lists.

-- 
Regards,

Laurent Pinchart
