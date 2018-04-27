Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:37796 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759307AbeD0VsG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 17:48:06 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH] v4l: vsp1: Fix vsp1_regs.h license header
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
References: <20180427214647.892-1-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <038b1c6d-6253-d8b5-80f9-2826ae59dcc0@ideasonboard.com>
Date: Fri, 27 Apr 2018 22:48:01 +0100
MIME-Version: 1.0
In-Reply-To: <20180427214647.892-1-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/04/18 22:46, Laurent Pinchart wrote:
> All source files of the vsp1 driver are licensed under the GPLv2+ except
> for vsp1_regs.h which is licensed under GPLv2. This is caused by a bad
> copy&paste that dates back from the initial version of the driver. Fix
> it.
> 
> Cc: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
> Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
> Iwamatsu-san, Kieran, Sergei, Niklas, Wolfram,
> 
> While working on the VSP1 driver I noticed that all source files are
> licensed under the GPLv2+ except for vsp1_regs.h which is licensed under
> GPLv2. I'd like to fix this inconsistency. As you have all contributed
> to that file, could you please provide your explicit ack if you agree to
> this change ?
> ---
>  drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
> index 0d249ff9f564..e82661216c1d 100644
> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_regs.h  --  R-Car VSP1 Registers Definitions
>   *
> 
