Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52364 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760818Ab2FDQV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 12:21:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ritesh <yuva_dashing@yahoo.com>
Cc: Enrico <ebutera@users.berlios.de>,
	jean-philippe francois <jp.francois@cynove.com>,
	Alex Gershgorin <alexg@meprolight.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: OMAP 3 ISP
Date: Mon, 04 Jun 2012 18:21:27 +0200
Message-ID: <1568562.Y6i3jeOFzQ@avalon>
In-Reply-To: <C64BB294-2228-4EB5-B839-27480B232B8D@yahoo.com>
References: <B9D34818-CE30-4125-997B-71C50CFC4F0D@yahoo.com> <12509952.dDkgsjd7gb@avalon> <C64BB294-2228-4EB5-B839-27480B232B8D@yahoo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ritesh,

On Thursday 31 May 2012 03:26:57 Ritesh wrote:
> Hi Laurent,
> For me even ISP revision print log is not displaying and moreover when I am
> checking the interrupts using cat /proc/interrupts
> Only iommu interrupt is showing for interrupt line 24
> 
> Seems ISP probe function is not at all getting called
> Right now board is not available for me so that I can't post here complete
> log
> 
> Can u please send me working Linux kernel repository link for omap35x
> torpedo kit

I can't, as I don't have that. You should take the latest mainline code and 
add ISP board code for your board. You can find examples of such board code at 
http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
sensors-board for the Beagleboard, the Gumstix Overo and the OMAP3 EVM.

-- 
Regards,

Laurent Pinchart

