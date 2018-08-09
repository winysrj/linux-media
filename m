Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:47772 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730506AbeHIPEa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 11:04:30 -0400
Date: Thu, 9 Aug 2018 14:39:43 +0200
From: Simon Horman <horms@verge.net.au>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?utf-8?Q?=22Niklas_S=C3=B6derlund=22?=
        <niklas.soderlund@ragnatech.se>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 4/8] media: adv748x: convert to SPDX identifiers
Message-ID: <20180809123942.dzxttuw4drwcs66h@verge.net.au>
References: <87h8k8nqcf.wl-kuninori.morimoto.gx@renesas.com>
 <87bmagnq8d.wl-kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bmagnq8d.wl-kuninori.morimoto.gx@renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 06, 2018 at 03:17:48AM +0000, Kuninori Morimoto wrote:
> 
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> As original license mentioned, it is GPL-2.0+ in SPDX.
> Then, MODULE_LICENSE() should be "GPL" instead of "GPL v2".
> See ${LINUX}/include/linux/module.h
> 
> 	"GPL"		[GNU Public License v2 or later]
> 	"GPL v2"	[GNU Public License v2]
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
