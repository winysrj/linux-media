Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E825DC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 20:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E44320879
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 20:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544040519;
	bh=0ae1t8qFo8kOKTFZH+meVIcrAXvV8OLaEGHGzy+Au8Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=HJ9yfbweJmzhyDePJTirJYgPLx9Eew2Qz9NYKOdgyoDEoCQUW1TvPH8pbix8kRQNq
	 NWuSiYDRnQY1nQmAtxrwHYUMOk6D29/SABaRmPbInfz6tnniR3tVldbjt6VilTBFUd
	 Zuuf7TqSKmgKXiFwRdx23ZwRGMc5n9BaFqivGeVs=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E44320879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbeLEUIj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 15:08:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:47068 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727592AbeLEUIi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 15:08:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mJm9iMUc3TO391GJiFk9zLH2awkXR6rbg41qHo6qgJs=; b=chQyM56wyH6FdwiBtzIM49J5Ae
        XZEVse10biWjeekETjbH5u+5tCOIsPa3Z1n8tsThyLFuyFyCqc8+L2LKH7TgYbPUFXvQybwH4JwFu
        8nUe31H31TkJXb0vIgtp/9EsWF+z8Z/aaL+E4TLx7Z8vd9tIeA0aKgHd2pe20RWP6mHC2i7oh46FM
        alu8d1zZwmA6Te5WD5VgpNC4DHjP3ISvVoUnw/Bj14umYm9Ie3lvwFhMEea3aQKOFQHZXc60VR1j4
        IGkbqMxw8rJvSh/Nxj1/j7qVIWL2VY1qcxLD3BYg1cnGU/f77p0DLWe7ml+fLA+G1142vcZzYh3vH
        UPncbCsw==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUdTG-0007dW-Oc; Wed, 05 Dec 2018 20:08:35 +0000
Date:   Wed, 5 Dec 2018 18:08:31 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.21] Rockchip VPU JPEG encoder driver
Message-ID: <20181205180831.03cb96ac@coco.lan>
In-Reply-To: <69509e804c5d10e6331b6ce41042edaf78866855.camel@collabora.com>
References: <c7c87316-983a-6918-592c-337a1dc6a739@xs4all.nl>
        <20181205163404.26952aac@coco.lan>
        <20181205163707.024c4da8@coco.lan>
        <69509e804c5d10e6331b6ce41042edaf78866855.camel@collabora.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 05 Dec 2018 17:02:46 -0300
Ezequiel Garcia <ezequiel@collabora.com> escreveu:

> On Wed, 2018-12-05 at 16:37 -0200, Mauro Carvalho Chehab wrote:
> > Em Wed, 5 Dec 2018 16:34:04 -0200
> > Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:
> >   
> > > Em Wed, 5 Dec 2018 17:29:38 +0100
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > >   
> > > > Note regarding the first 'Revert' patch: that is this patch:
> > > > 
> > > > https://patchwork.linuxtv.org/patch/52869/
> > > > 
> > > > It is currently pending for 4.20 as a fix, but since it is not merged upstream
> > > > yet, our master branch still has those old bindings.
> > > > 
> > > > I decided to first apply the Revert patch, then add the new patch on top.
> > > > 
> > > > Regards,
> > > > 
> > > > 	Hans
> > > > 
> > > > The following changes since commit da2c94c8f9739e4099ea3cfefc208fc721b22a9c:
> > > > 
> > > >   media: v4l2: async: remove locking when initializing async notifier (2018-12-05 06:51:28 -0500)
> > > > 
> > > > are available in the Git repository at:
> > > > 
> > > >   git://linuxtv.org/hverkuil/media_tree.git tags/br-rkjpeg2
> > > > 
> > > > for you to fetch changes up to 7f608cfd52c08e7d84bd38438e330c26263eddcb:
> > > > 
> > > >   media: add Rockchip VPU JPEG encoder driver (2018-12-05 17:18:46 +0100)
> > > > 
> > > > ----------------------------------------------------------------
> > > > Tag branch
> > > > 
> > > > ----------------------------------------------------------------
> > > > Ezequiel Garcia (3):
> > > >       Revert "media: dt-bindings: Document the Rockchip VPU bindings"
> > > >       media: dt-bindings: Document the Rockchip VPU bindings
> > > >       media: add Rockchip VPU JPEG encoder driver    
> > > 
> > > Checkpatch produces a few warnings:
> > > 
> > > # CHECK: Alignment should match open parenthesis
> > > # #385: FILE: drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c:109:
> > > # +	rk3288_vpu_jpeg_enc_set_qtable(vpu,
> > > # +		rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> > > # 
> > > # CHECK: Alignment should match open parenthesis
> > > # #1124: FILE: drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c:140:
> > > # +	rk3399_vpu_jpeg_enc_set_qtable(vpu,
> > > # +			rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> > > # 
> > > # WARNING: DT compatible string "rockchip,rk3399-vpu" appears un-documented -- check ./Documentation/devicetree/bindings/
> > > # #2359: FILE: drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c:326:
> > > # +	{ .compatible = "rockchip,rk3399-vpu", .data = &rk3399_vpu_variant, },
> > > # 
> > > # WARNING: DT compatible string "rockchip,rk3288-vpu" appears un-documented -- check ./Documentation/devicetree/bindings/
> > > # #2360: FILE: drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c:327:
> > > # +	{ .compatible = "rockchip,rk3288-vpu", .data = &rk3288_vpu_variant, },
> > > # 
> > > # CHECK: Unnecessary parentheses around 'formats[i].codec_mode != RK_VPU_MODE_NONE'
> > > # #2721: FILE: drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c:145:
> > > # +		if (bitstream == (formats[i].codec_mode != RK_VPU_MODE_NONE))
> > > # 
> > > # total: 0 errors, 2 warnings, 3 checks, 3469 lines checked
> > >   
> 
> Please note that this last one is a false positive,
> the code needs those parenthesis.

Yes, I know. that "Unnecessary parentheses" warning should always be
taken with caution.

I've seen several cases where it was right, but, for the sake of a
better code readability, it was better to preserve it.

Thanks,
Mauro
