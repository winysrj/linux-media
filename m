Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFCB8C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 19:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A612D208E7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 19:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544038920;
	bh=42iJRc1pWSoKJjIPy3stpQAmrJo30+vR6BYSiKzHokU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=YU7sFrAVZ24oHzN+rtyxqjHglL1F0b9uyVDSRwGukaJczQbwUvNPnzmZ0t3uaywwI
	 uSTQdNYpSm3NViS9dycTdficoapiY7kBdYf/1l2Cu0JYDkAP5ziGnWLZrik6j8R2T8
	 jxwe7PZ4knhz7RvqUBz9bz4rKnHbU+Xks25Oa2EM=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A612D208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbeLETl7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 14:41:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:44342 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbeLETl7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 14:41:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WHWyNGi+fAqkqFV8pHjE4cUOzONQY7F2RPGkiNttmMA=; b=JRuB1HkUCqt42nay8R6HG/a1iL
        48s4Es1zeHrqnY+AqAebP/laYoJ9TRMRQeuSP6VoF/dGi1SGceI8W3tR4oCmtLuml/dBlJ9wnnGRB
        +Wzz2TzOGYw7eXlIGwBr7523Uw77bCnEM9Mpiqt4GVbkAjFo40VVCxz7gm8UzognFJecRYhUm47sD
        JW71A2Da0Iyacg27WkSebtiKJHE/zrNBUAFBCzXIgVejFfcHcRAIFmvuqFHrN0AqrXDj34rZIVnDx
        bEOQgoVvwnVk1T3eiA/1ldhzdMMXqEDeDIPMEOBONQhHNKVhn5h0Nuajx44bv4CGxpsXRak76mZb9
        LlBUwELw==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUd3U-0006Oa-1w; Wed, 05 Dec 2018 19:41:56 +0000
Date:   Wed, 5 Dec 2018 17:41:50 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH] media: rockchip/vpu: fix a few alignments
Message-ID: <20181205174150.00ed1912@coco.lan>
In-Reply-To: <45972676-265a-51ce-c9eb-ff49f8eab5bb@xs4all.nl>
References: <bcebf81255a71b34541bc00bcb505e815193f0be.1544035391.git.mchehab+samsung@kernel.org>
        <45972676-265a-51ce-c9eb-ff49f8eab5bb@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 5 Dec 2018 19:48:25 +0100
Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:

> On 12/05/2018 07:43 PM, Mauro Carvalho Chehab wrote:
> > As reported by checkpatch.pl, some function calls have a wrong
> > alignment.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >  drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c | 4 ++--
> >  drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c | 4 ++--
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
> > index 8919151e1631..e27c10855de5 100644
> > --- a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
> > +++ b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
> > @@ -106,8 +106,8 @@ void rk3288_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx)
> >  	rk3288_vpu_set_src_img_ctrl(vpu, ctx);
> >  	rk3288_vpu_jpeg_enc_set_buffers(vpu, ctx, src_buf);
> >  	rk3288_vpu_jpeg_enc_set_qtable(vpu,
> > -		rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> > -		rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));
> > +				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> > +				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));  
> 
> But now you get warnings because this is > 80 columns.
> 
> I think the 'cure' is worse than the disease.
> 
> I see this is already merged, but I don't think this patch improves readability,
> which is more important than a checkpatch warning IMHO.

IMHO, it is a way more readable if things got aligned. Very very few
people nowadays (if any) write patches directly at a 80 columns console.

Btw, speaking about 80 cols, usually your commit messages are longer
than that (the limit is actually 80 cols - 4). I keep fixing the
corresponding checkpatch.pl warnings from your patches
(when I have time) :-)

> 
> Regards,
> 
> 	Hans
> 
> >  
> >  	reg = VEPU_REG_AXI_CTRL_OUTPUT_SWAP16
> >  		| VEPU_REG_AXI_CTRL_INPUT_SWAP16
> > diff --git a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
> > index 8afa2162bf9f..5f75e4d11d76 100644
> > --- a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
> > +++ b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
> > @@ -137,8 +137,8 @@ void rk3399_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx)
> >  	rk3399_vpu_set_src_img_ctrl(vpu, ctx);
> >  	rk3399_vpu_jpeg_enc_set_buffers(vpu, ctx, src_buf);
> >  	rk3399_vpu_jpeg_enc_set_qtable(vpu,
> > -			rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> > -			rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));
> > +				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 0),
> > +				       rockchip_vpu_jpeg_get_qtable(&jpeg_ctx, 1));
> >  
> >  	reg = VEPU_REG_OUTPUT_SWAP32
> >  		| VEPU_REG_OUTPUT_SWAP16
> >   
> 



Thanks,
Mauro
