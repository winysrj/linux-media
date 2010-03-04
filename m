Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:49388 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab0CDJvT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 04:51:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arnout Vandecappelle <arnout@mind.be>
Subject: Re: [PATCH RFCv1] Support for zerocopy to DSP on OMAP3
Date: Thu, 4 Mar 2010 10:52:39 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <201003031512.45428.arnout@mind.be> <201003032011.07559.arnout@mind.be>
In-Reply-To: <201003032011.07559.arnout@mind.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003041052.41438.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnout,

On Wednesday 03 March 2010 20:11:06 Arnout Vandecappelle wrote:
>  Here's a first attempt at allowing IO memory for USERPTR buffers.
> 
>  It also fixes another issue: it was assumed that
> dma->sglen == dma->nr_pages.  I'll split that up in a separate patch in the
> final version.

-EMISSINGPATCH :-)

Please split the patch and CC Sakari Ailus when you submit them.

-- 
Regards,

Laurent Pinchart
