Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:44773 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933229AbcJTJQV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Oct 2016 05:16:21 -0400
Date: Thu, 20 Oct 2016 10:49:11 +0200
From: Simon Horman <horms@verge.net.au>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        geert@linux-m68k.org, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v2 0/3] r8a7793 Gose video input support
Message-ID: <20161020084911.GH4612@verge.net.au>
References: <1476802943-5189-1-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476802943-5189-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

On Tue, Oct 18, 2016 at 05:02:20PM +0200, Ulrich Hecht wrote:
> Hi!
> 
> This is a by-the-datasheet implementation of analog and digital video input
> on the Gose board.
> 
> I have tried to address all concerns raised by reviewers, with the exception
> of the composite input patch, which has been left as is for now.
> 
> CU
> Uli
> 
> 
> Changes since v1:
> - r8a7793.dtsi: added VIN2
> - modeled HDMI decoder input/output and connector
> - added "renesas,rcar-gen2-vin" compat strings
> - removed unnecessary "remote" node and aliases
> - set ADV7612 interrupt to GP4_2
> 
> 
> Ulrich Hecht (3):
>   ARM: dts: r8a7793: Enable VIN0-VIN2

I have queued up the above patch with Laurent and Geert's tags.

>   ARM: dts: gose: add HDMI input
>   ARM: dts: gose: add composite video input

Please address the review of the above two patches and repost.

Thanks!

> 
>  arch/arm/boot/dts/r8a7793-gose.dts | 100 +++++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/r8a7793.dtsi     |  27 ++++++++++
>  2 files changed, 127 insertions(+)
> 
> -- 
> 2.7.4
> 
