Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED347C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 16:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7269217D9
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 16:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfBSQ4D (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 11:56:03 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45621 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfBSQ4D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 11:56:03 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <pza@pengutronix.de>)
        id 1gw8gb-0007yY-Pf; Tue, 19 Feb 2019 17:56:01 +0100
Received: from pza by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <pza@pengutronix.de>)
        id 1gw8gb-0005yq-FX; Tue, 19 Feb 2019 17:56:01 +0100
Date:   Tue, 19 Feb 2019 17:56:01 +0100
From:   Philipp Zabel <pza@pengutronix.de>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Todor Tomov <todor.too@gmail.com>
Subject: Re: [PATCH 13/14] media: Documentation: fix several typos
Message-ID: <20190219165601.vvp32zeonokci7qw@pengutronix.de>
References: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
 <33336ded047b1ea1c491fa3055dbe274f7c427fa.1550518128.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33336ded047b1ea1c491fa3055dbe274f7c427fa.1550518128.git.mchehab+samsung@kernel.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:54:25 up 8 days,  1:20, 58 users,  load average: 0.15, 0.16, 0.16
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Feb 18, 2019 at 02:29:07PM -0500, Mauro Carvalho Chehab wrote:
[...]
> diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
> index 9314af00d067..1d7eb8c7bd5c 100644
> --- a/Documentation/media/v4l-drivers/imx.rst
> +++ b/Documentation/media/v4l-drivers/imx.rst
> @@ -29,7 +29,7 @@ de-interlacing by interweaving even and odd lines during transfer
>  (without motion compensation which requires the VDIC).
>  
>  The CSI is the backend capture unit that interfaces directly with
> -camera sensors over Parallel, BT.656/1120, and MIPI CSI-2 busses.
> +camera sensors over Parallel, BT.656/1120, and MIPI CSI-2 buses.
>  
>  The IC handles color-space conversion, resizing (downscaling and
>  upscaling), horizontal flip, and 90/270 degree rotation operations.
> @@ -207,7 +207,7 @@ The CSI supports cropping the incoming raw sensor frames. This is
>  implemented in the ipuX_csiY entities at the sink pad, using the
>  crop selection subdev API.
>  
> -The CSI also supports fixed divide-by-two downscaling indepently in
> +The CSI also supports fixed divide-by-two downscaling independently in
>  width and height. This is implemented in the ipuX_csiY entities at
>  the sink pad, using the compose selection subdev API.

Thank you, for imx
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
