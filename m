Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35895 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3LJOD0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 09:03:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tom <Bassai_Dai@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: use other formats from ov3640 camera sensor through the isp pipeline
Date: Tue, 10 Dec 2013 15:03:36 +0100
Message-ID: <18022571.SKANkXJkvv@avalon>
In-Reply-To: <loom.20131210T113548-646@post.gmane.org>
References: <loom.20131210T113548-646@post.gmane.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tom,

On Tuesday 10 December 2013 10:42:22 Tom wrote:
> Hello,
> 
> I am using the ov3640 camera sensor along with the isp pipeline and
> configured it like: sensor->ccdc->memory
> 
> My sensor supports more formats like rgb565 and so. Does anyone have an idea
> how I could manage to set these formats out of the users application? If I
> understand it right, the isp pipeline will not allow a format the ccdc sink
> pad does not know.

That's correct. The right way to fix this is to extend the OMAP3 ISP driver to 
support the formats you need on the CCDC pads.

-- 
Regards,

Laurent Pinchart

