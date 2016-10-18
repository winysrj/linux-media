Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59702 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761895AbcJRPR3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 11:17:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: horms@verge.net.au, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        hans.verkuil@cisco.com, william.towle@codethink.co.uk,
        niklas.soderlund@ragnatech.se, geert@linux-m68k.org,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v2 0/2] Renesas Lager/Koelsch HDMI input
Date: Tue, 18 Oct 2016 18:17:25 +0300
Message-ID: <3208320.rNl1JGvzBF@avalon>
In-Reply-To: <1476802894-5105-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1476802894-5105-1-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thank you for the patches.

For the whole series,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

On Tuesday 18 Oct 2016 17:01:32 Ulrich Hecht wrote:
> Hi!
> 
> This series enables HDMI input on the Lager and Koelsch boards.
> It sits on renesas-next-20161017-v4.9-rc1.
> 
> I have tried to address all concerns raised by reviewers (correctly, I
> hope), see below for details.
> 
> CU
> Uli
>  
> Changes since v1:
> - modeled decoder inputs/outputs and connectors
> - removed unnecessary "remote" nodes
> - r8a7790-lager.dts: "ok" -> "okay"
> - r8a7791-koelsch.dts: set ADV7612 interrupt to GP4_2 
> 
> Hans Verkuil (1):
>   ARM: dts: koelsch: add HDMI input
> 
> William Towle (1):
>   ARM: dts: lager: Add entries for VIN HDMI input support
> 
> arch/arm/boot/dts/r8a7790-lager.dts   | 66 ++++++++++++++++++++++++++++++--
> arch/arm/boot/dts/r8a7791-koelsch.dts | 68 ++++++++++++++++++++++++++++++--
> 2 files changed, 130 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart

