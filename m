Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51566 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0KOKuP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 05:50:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergio Aguirre <saaguirre@ti.com>
Subject: Re: [omap3isp RFC][PATCH 00/10] YUV support for CCDC + cleanups
Date: Mon, 15 Nov 2010 11:50:22 +0100
Cc: linux-media@vger.kernel.org
References: <1289596693-27660-1-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289596693-27660-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011151150.22845.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sergio,

Thanks for the patches !

On Friday 12 November 2010 22:18:03 Sergio Aguirre wrote:
> Hi,
> 
> First of all, these patches are based on Laurent's tree:
> 
> URL: git://linuxtv.org/pinchartl/media.git
> Branch: media-0004-omap3isp (Commit d0c5b0e4: OMAP3 ISP driver)
> 
> I had these patches in my queue for some time, which:
> 
> - Add YUV support to CCDC
> - Cleans up platform device MEM resources
> - Removes some unused/legacy defines
> - IMPORTANT: Moves/Renames isp_user.h to include/linux/omap3isp.h
> 
> I'm working on some more changes to keep register access per component
> a bit cleaner. But that will be sent separately in another RFC patchlist.
> 
> Please share your review comments.

Apart from one minor comment on patch 02/10, this set looks fine to me. Could 
you please resend it with patches 01/10 and 02/10 squashed ?

-- 
Regards,

Laurent Pinchart
