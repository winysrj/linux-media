Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B416C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 18:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 139D020645
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544034851;
	bh=YQOSxRqrMDXSzZ416613Cv7VRZLeRMov5z/OhZPDN4g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=Uen4NKCKgu5+QcH5jj+dNdp5W+/B1wcHwJ2D04LyWbFt+xbZZCuhiFMYxReCpHP6S
	 gaP5IGVYvlGuQbcjEHRWfn22paMgGMnqsg0aypQV073A73YAHiA/URLY1k9f+LtBCR
	 58COPJtfCwdWhKn9L34vjhXz1iqglexwHhqke3UQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 139D020645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbeLESeK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 13:34:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:40210 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbeLESeK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 13:34:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oqw0eQbDz8IPV1yhKFNyhMettbQgql9vDoLeHm+0CJw=; b=fBbq36haa8ELLsapOpxeajeZ5B
        wuq22j6NxIEN0C8ccSJCM5dIfjrclSIfuAvxajrYPdwCg13suAaz03GYp8gxIOdM6cuxwGgVFKy8j
        mgS/YNalSkww9uzLkzFMPrK14XoUl0IBOFiYUXbawbNgi6MgF/bWpa6o+RpEMWthvZXnHKVu6BO+3
        8fBDbmTeV8n6+RifmBPupRMXhE+quCseNnYHi35ol/JphSSQz19SuEAl0LPuu64Pv8DZ8CO85JCfc
        axpML0dSpatFJV/5VdvmOJRLJY6LeQv/gPMFCxmwb+uf5LfTne9raSwRHsezJog/WTsZm7m17v5sS
        LD+UPrQg==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUbzs-0004QV-1O; Wed, 05 Dec 2018 18:34:08 +0000
Date:   Wed, 5 Dec 2018 16:34:04 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [GIT PULL FOR v4.21] Rockchip VPU JPEG encoder driver
Message-ID: <20181205163404.26952aac@coco.lan>
In-Reply-To: <c7c87316-983a-6918-592c-337a1dc6a739@xs4all.nl>
References: <c7c87316-983a-6918-592c-337a1dc6a739@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 5 Dec 2018 17:29:38 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Note regarding the first 'Revert' patch: that is this patch:
> 
> https://patchwork.linuxtv.org/patch/52869/
> 
> It is currently pending for 4.20 as a fix, but since it is not merged upstream
> yet, our master branch still has those old bindings.
> 
> I decided to first apply the Revert patch, then add the new patch on top.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit da2c94c8f9739e4099ea3cfefc208fc721b22a9c:
> 
>   media: v4l2: async: remove locking when initializing async notifier (2018-12-05 06:51:28 -0500)
> 
> are available in the Git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git tags/br-rkjpeg2
> 
> for you to fetch changes up to 7f608cfd52c08e7d84bd38438e330c26263eddcb:
> 
>   media: add Rockchip VPU JPEG encoder driver (2018-12-05 17:18:46 +0100)
> 
> ----------------------------------------------------------------
> Tag branch
> 
> ----------------------------------------------------------------
> Ezequiel Garcia (3):
>       Revert "media: dt-bindings: Document the Rockchip VPU bindings"
>       media: dt-bindings: Document the Rockchip VPU bindings
>       media: add Rockchip VPU JPEG encoder driver

Checkpatch produces a few warnings:

# CHECK: Alignment should match open parenthesis
# #385: FILE: drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c:109:
# +	rk3288_vpu_jpeg_enc_set_qtable(vpu,
# +		rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
# 
# CHECK: Alignment should match open parenthesis
# #1124: FILE: drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c:140:
# +	rk3399_vpu_jpeg_enc_set_qtable(vpu,
# +			rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
# 
# WARNING: DT compatible string "rockchip,rk3399-vpu" appears un-documented -- check ./Documentation/devicetree/bindings/
# #2359: FILE: drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c:326:
# +	{ .compatible = "rockchip,rk3399-vpu", .data = &rk3399_vpu_variant, },
# 
# WARNING: DT compatible string "rockchip,rk3288-vpu" appears un-documented -- check ./Documentation/devicetree/bindings/
# #2360: FILE: drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c:327:
# +	{ .compatible = "rockchip,rk3288-vpu", .data = &rk3288_vpu_variant, },
# 
# CHECK: Unnecessary parentheses around 'formats[i].codec_mode != RK_VPU_MODE_NONE'
# #2721: FILE: drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c:145:
# +		if (bitstream == (formats[i].codec_mode != RK_VPU_MODE_NONE))
# 
# total: 0 errors, 2 warnings, 3 checks, 3469 lines checked

The more weird ones are the ones related to the DT bindings.

Regards,
Mauro

Thanks,
Mauro
