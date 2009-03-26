Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:40803 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbZCZNwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 09:52:13 -0400
Subject: Re: [PATCH 0/4] ARM: DaVinci: DM646x Video: DM646x display driver
From: Steve Chen <schen@mvista.com>
To: Chaithrika U S <chaithrika@ti.com>
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
In-Reply-To: <1238073682-9838-1-git-send-email-chaithrika@ti.com>
References: <1238073682-9838-1-git-send-email-chaithrika@ti.com>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 08:52:28 -0500
Message-Id: <1238075548.3080.117.camel@linux-1lbu.site>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-03-26 at 09:21 -0400, Chaithrika U S wrote:
> Display driver for TI DM646x EVM
> 
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> 
> This patch set has been updated with the review comments for the RFC sent earlier.
> 
> These patches add the display driver support for TI DM646x EVM.
> This patch set has been tested for basic display functionality for
> Composite and Component outputs.
> 
> Patch 1: Display device platform and board setup
> Patch 2: VPIF driver
> Patch 3: DM646x display driver
> Patch 4: Makefile and config files modifications for Display
> 
> Some of the features like the HBI/VBI support are not yet implemented. 
> Also there are some known issues in the code implementation like 
> fine tuning to be done to TRY_FMT ioctl.The USERPTR usage has not been 
> tested extensively.
> 
> These patches are based on the drivers written by:
>         Manjunath Hadli <mrh@ti.com>
>         Brijesh Jadav <brijesh.j@ti.com>

Please add authors and significant contributors of the patch in the
signed-off list

> 
> The files have been renamed as per the discussion. The header files have been 
> moved to the same directory as the driver. Currently, the driver supports SDTV
> formats only.
>  
> -Chaithrika
> 
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source

