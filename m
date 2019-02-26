Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F13C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 18:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AA5B2147C
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 18:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551204260;
	bh=RF2XiaImatFynO+AMfbRNelu7T+nz1LyautgFW87+Hk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=PP5Xcly6iHwA080bDL3IznQcThr16rJXMTl2t+9ckRk9jkr6V0XN2U9jiocnLg3rQ
	 pWDVvbcYpQVaYB4Ch1M4v7odYAFvDr5gXH0D9T7SoKUlRaypNy/Ry2/F8Q4eE4hs8P
	 4h2caHbYwBeyFPRCPMj1ZGxni7wso8/vbuNqXaSc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbfBZSET (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 13:04:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:54412 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfBZSET (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 13:04:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=H5G5HliwyOCGMOZnJzANUhr2occdDcwk4ZnaHylFBqE=; b=QU+Ani28P0R8TXtYvEyfyjbw/
        UssUUy+PolorHJnLzMS3qv9caOOdhjxawyIZMDlsMWMtYTt9IqKO0ky4gH12OA6aMca9GGU2oZpyD
        BUhg/aQsmXtPJvB4vxF//6DUevFOferIIwX1TK0uHcfIWOI+oJc0IHwokOUpsjNRxHA8qvF53eOEf
        gzB4lvWQ4MotzWEXgFkbjQ7ixHmX5UgWHnsFqw1r3vqS6WnidZ3D2KUyU0kL3lWp3m5TsNnt8FdGA
        0WhllsMs8jShOIzKpzolrTTZMwZBVnXNFDe5+GH0p5+XSw7rtE0PWzE957VV9Dz64S9u9GMiae9Zq
        Z2Ixl0+GQ==;
Received: from 177.41.100.217.dynamic.adsl.gvt.net.br ([177.41.100.217] helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gyh5V-0001Ax-Ez; Tue, 26 Feb 2019 18:04:17 +0000
Date:   Tue, 26 Feb 2019 15:04:13 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [PATCH 2/2] media: vim2m: ensure that width is multiple of two
Message-ID: <20190226150413.44afefb2@coco.lan>
In-Reply-To: <0a47c5ad8099c5988e961d44221b4a95d74f8322.1551202610.git.mchehab+samsung@kernel.org>
References: <627b2c823606801a9d2cf0bb2ea15ad83942e6dd.1551202610.git.mchehab+samsung@kernel.org>
        <0a47c5ad8099c5988e961d44221b4a95d74f8322.1551202610.git.mchehab+samsung@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 26 Feb 2019 14:36:55 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> The copy logic assumes that the data width is multiple of two,
> as this is needed in order to support YUYV.

Please ignore this one. The driver already aligns (it enforces
an 8 pixels alignment... 2 pixels should be enough).

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/platform/vim2m.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index ab288e8377f1..89384f324e25 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -801,7 +801,7 @@ static int vidioc_s_fmt(struct vim2m_ctx *ctx, struct v4l2_format *f)
>  	}
>  
>  	q_data->fmt		= find_format(f);
> -	q_data->width		= f->fmt.pix.width;
> +	q_data->width		= f->fmt.pix.width & (~1);
>  	q_data->height		= f->fmt.pix.height;
>  	q_data->sizeimage	= q_data->width * q_data->height
>  				* q_data->fmt->depth >> 3;



Thanks,
Mauro
