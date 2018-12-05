Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0A4C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 18:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDE0220989
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544035034;
	bh=yC0VnTixodUKMGU+Q0bUH65b8yNHs/bEImdBdOH8mPM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=O2LsJCWZYIyZO+ea37efe6XUltcTdoYvPkbVgIhbXvphYlOaXh58eSGOIHLsH1KZe
	 nJzd3FSunNdn9poTdupHrlsZpIg++7hEog9AQiUSD3Jo5idBKaBcwNagUQOZ8WEYQc
	 qKmcQCVAWN1dka7pdUAdZDl/Ln2PR2Hj8UcNBUpw=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDE0220989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbeLEShN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 13:37:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:40388 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbeLEShN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 13:37:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=32zfBowdzmA7QNkOB8RE9IhPC4Cu/XYaS9Hsu+1WYUU=; b=IoDVa8OI6qLkR0xtAShCqAG82t
        5dwbfd/+T/FmVQ5oE9vhvDp8Pk7gU7ZCEuHNnz8KVA/sNbDxg79vonAcsXrHWqn7T5vbfsyQAEV7G
        pUlj+tZOCk40TVolzEGBAeOQLh9ePVDcR9gBOXlACR4fUidYv41A5DAB3AjePANV0q7wpIw3FCmaA
        akO9OYg/7wWV9BXXr43NDUxkryxyqP4kXwA/4hV/qpZXfhwIGz41KEFIBcRUTX15fBC7dc8juCD5Q
        4XkKa6rRd8qiGewaH1S7OI/dBpCf3C5AWMcDWhzGpzckQNNed7hRwjvWrCOwtJk/EmWRSy2cXXbVe
        wn+rj9kQ==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUc2p-0004We-Hd; Wed, 05 Dec 2018 18:37:12 +0000
Date:   Wed, 5 Dec 2018 16:37:07 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [GIT PULL FOR v4.21] Rockchip VPU JPEG encoder driver
Message-ID: <20181205163707.024c4da8@coco.lan>
In-Reply-To: <20181205163404.26952aac@coco.lan>
References: <c7c87316-983a-6918-592c-337a1dc6a739@xs4all.nl>
        <20181205163404.26952aac@coco.lan>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 5 Dec 2018 16:34:04 -0200
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> Em Wed, 5 Dec 2018 17:29:38 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > Note regarding the first 'Revert' patch: that is this patch:
> > 
> > https://patchwork.linuxtv.org/patch/52869/
> > 
> > It is currently pending for 4.20 as a fix, but since it is not merged upstream
> > yet, our master branch still has those old bindings.
> > 
> > I decided to first apply the Revert patch, then add the new patch on top.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > The following changes since commit da2c94c8f9739e4099ea3cfefc208fc721b22a9c:
> > 
> >   media: v4l2: async: remove locking when initializing async notifier (2018-12-05 06:51:28 -0500)
> > 
> > are available in the Git repository at:
> > 
> >   git://linuxtv.org/hverkuil/media_tree.git tags/br-rkjpeg2
> > 
> > for you to fetch changes up to 7f608cfd52c08e7d84bd38438e330c26263eddcb:
> > 
> >   media: add Rockchip VPU JPEG encoder driver (2018-12-05 17:18:46 +0100)
> > 
> > ----------------------------------------------------------------
> > Tag branch
> > 
> > ----------------------------------------------------------------
> > Ezequiel Garcia (3):
> >       Revert "media: dt-bindings: Document the Rockchip VPU bindings"
> >       media: dt-bindings: Document the Rockchip VPU bindings
> >       media: add Rockchip VPU JPEG encoder driver  
> 
> Checkpatch produces a few warnings:
> 
> # CHECK: Alignment should match open parenthesis
> # #385: FILE: drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c:109:
> # +	rk3288_vpu_jpeg_enc_set_qtable(vpu,
> # +		rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> # 
> # CHECK: Alignment should match open parenthesis
> # #1124: FILE: drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c:140:
> # +	rk3399_vpu_jpeg_enc_set_qtable(vpu,
> # +			rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> # 
> # WARNING: DT compatible string "rockchip,rk3399-vpu" appears un-documented -- check ./Documentation/devicetree/bindings/
> # #2359: FILE: drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c:326:
> # +	{ .compatible = "rockchip,rk3399-vpu", .data = &rk3399_vpu_variant, },
> # 
> # WARNING: DT compatible string "rockchip,rk3288-vpu" appears un-documented -- check ./Documentation/devicetree/bindings/
> # #2360: FILE: drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c:327:
> # +	{ .compatible = "rockchip,rk3288-vpu", .data = &rk3288_vpu_variant, },
> # 
> # CHECK: Unnecessary parentheses around 'formats[i].codec_mode != RK_VPU_MODE_NONE'
> # #2721: FILE: drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c:145:
> # +		if (bitstream == (formats[i].codec_mode != RK_VPU_MODE_NONE))
> # 
> # total: 0 errors, 2 warnings, 3 checks, 3469 lines checked
> 
> The more weird ones are the ones related to the DT bindings.

Hmm... those were my fault.

/me needs caffeine

> 
> Regards,
> Mauro
> 
> Thanks,
> Mauro



Thanks,
Mauro
