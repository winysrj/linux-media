Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60073 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab0KOKgt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 05:36:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergio Aguirre <saaguirre@ti.com>
Subject: Re: [omap3isp RFC][PATCH 02/10] omap3isp: ccdc: Write SYN_MODE.INPMOD based on fmt
Date: Mon, 15 Nov 2010 11:36:57 +0100
Cc: linux-media@vger.kernel.org
References: <1289596693-27660-1-git-send-email-saaguirre@ti.com> <1289596693-27660-3-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289596693-27660-3-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011151136.58000.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sergio,

Thanks for the patch.

On Friday 12 November 2010 22:18:05 Sergio Aguirre wrote:
> This takes into account the input format to select the
> adequate configuration for SYNC mode.
> 
> Also, change bitmask ISPCCDC_SYN_MODE_INPMOD_MASK to be
> more consistent with other bitmasks.

Could you please squash this with the previous patch ?

-- 
Regards,

Laurent Pinchart
