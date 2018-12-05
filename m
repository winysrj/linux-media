Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A77DC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 20:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3658F20989
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 20:02:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3658F20989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=collabora.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbeLEUCx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 15:02:53 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50910 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbeLEUCx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 15:02:53 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 2D3B6263BF0
Message-ID: <69509e804c5d10e6331b6ce41042edaf78866855.camel@collabora.com>
Subject: Re: [GIT PULL FOR v4.21] Rockchip VPU JPEG encoder driver
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
Date:   Wed, 05 Dec 2018 17:02:46 -0300
In-Reply-To: <20181205163707.024c4da8@coco.lan>
References: <c7c87316-983a-6918-592c-337a1dc6a739@xs4all.nl>
         <20181205163404.26952aac@coco.lan> <20181205163707.024c4da8@coco.lan>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 2018-12-05 at 16:37 -0200, Mauro Carvalho Chehab wrote:
> Em Wed, 5 Dec 2018 16:34:04 -0200
> Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:
> 
> > Em Wed, 5 Dec 2018 17:29:38 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> > > Note regarding the first 'Revert' patch: that is this patch:
> > > 
> > > https://patchwork.linuxtv.org/patch/52869/
> > > 
> > > It is currently pending for 4.20 as a fix, but since it is not merged upstream
> > > yet, our master branch still has those old bindings.
> > > 
> > > I decided to first apply the Revert patch, then add the new patch on top.
> > > 
> > > Regards,
> > > 
> > > 	Hans
> > > 
> > > The following changes since commit da2c94c8f9739e4099ea3cfefc208fc721b22a9c:
> > > 
> > >   media: v4l2: async: remove locking when initializing async notifier (2018-12-05 06:51:28 -0500)
> > > 
> > > are available in the Git repository at:
> > > 
> > >   git://linuxtv.org/hverkuil/media_tree.git tags/br-rkjpeg2
> > > 
> > > for you to fetch changes up to 7f608cfd52c08e7d84bd38438e330c26263eddcb:
> > > 
> > >   media: add Rockchip VPU JPEG encoder driver (2018-12-05 17:18:46 +0100)
> > > 
> > > ----------------------------------------------------------------
> > > Tag branch
> > > 
> > > ----------------------------------------------------------------
> > > Ezequiel Garcia (3):
> > >       Revert "media: dt-bindings: Document the Rockchip VPU bindings"
> > >       media: dt-bindings: Document the Rockchip VPU bindings
> > >       media: add Rockchip VPU JPEG encoder driver  
> > 
> > Checkpatch produces a few warnings:
> > 
> > # CHECK: Alignment should match open parenthesis
> > # #385: FILE: drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c:109:
> > # +	rk3288_vpu_jpeg_enc_set_qtable(vpu,
> > # +		rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> > # 
> > # CHECK: Alignment should match open parenthesis
> > # #1124: FILE: drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c:140:
> > # +	rk3399_vpu_jpeg_enc_set_qtable(vpu,
> > # +			rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> > # 
> > # WARNING: DT compatible string "rockchip,rk3399-vpu" appears un-documented -- check ./Documentation/devicetree/bindings/
> > # #2359: FILE: drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c:326:
> > # +	{ .compatible = "rockchip,rk3399-vpu", .data = &rk3399_vpu_variant, },
> > # 
> > # WARNING: DT compatible string "rockchip,rk3288-vpu" appears un-documented -- check ./Documentation/devicetree/bindings/
> > # #2360: FILE: drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c:327:
> > # +	{ .compatible = "rockchip,rk3288-vpu", .data = &rk3288_vpu_variant, },
> > # 
> > # CHECK: Unnecessary parentheses around 'formats[i].codec_mode != RK_VPU_MODE_NONE'
> > # #2721: FILE: drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c:145:
> > # +		if (bitstream == (formats[i].codec_mode != RK_VPU_MODE_NONE))
> > # 
> > # total: 0 errors, 2 warnings, 3 checks, 3469 lines checked
> > 

Please note that this last one is a false positive,
the code needs those parenthesis.

Thanks!
Ezequiel

