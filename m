Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3CCC10F00
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 18:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 688E3214AF
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 18:47:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="u4FM61IZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfCLSrp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 14:47:45 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39258 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfCLSrp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 14:47:45 -0400
Received: by mail-lj1-f196.google.com with SMTP id g80so3278135ljg.6
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 11:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=5cyBCCut1WdqUxxdADU104NSQRWxK8HivBAwmqUf5is=;
        b=u4FM61IZUTZjLl3AMbww5F0p+71WIHmTrYGfCDEQQYf785j6OiM7EgTy8fTebjDtBL
         PrDDoeedeXn9Hj+X6VfhAmF70FlFcIKIGcoRNxdLdlZVY4HLWjbEUpRnK4njuFgXhSbN
         UN4O/22mGJOYny0UkkUuoM37E8gsUOLr08hEBb79E4ul8vjaHxo3yLTp2CepbsiT6Fx/
         6nQ1meqLvpFCi9xdtEnJfajjsduYVnPE56rJDhJ00FI3ObcRuytOVGOHxR3xVKSaZCfM
         FKk8A9qxvTOz1Ha10tufxmP/ZVjEPw3Z1rrXtYrjrKE0+heZ0imAzRO95WJ+eontmEoR
         MXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=5cyBCCut1WdqUxxdADU104NSQRWxK8HivBAwmqUf5is=;
        b=Dj9WHyPSqvbrWAYXe/dKPrIP0nChjsXdPc5aA1livJneA4AbN1TCWttja9WKagvZcD
         jUytBXRsJ+ll2YDbdTDe+sg/73vR45v+Z09QY7W7tI9zxHu+nfOaCvf39QwSC6gjMFsF
         ErdRDIJqPLmKYy3+tIbEfBlb3C7k6OcSYHuRtCccS8sgRNDysd5531/WCgmC/8p5ulLA
         k1LLzPtjSM6PI7aEUz7Y5onAFldPx/b6ddWQozCfTVUamshdFEX+zGB+XE4vJLFWaHFk
         NyhekPDXHTBEkx4h4kXytkF58NyLoCSQOji6h2Y73JwaqMLyxw1hekfD6TNUOqrfncZc
         i4Rw==
X-Gm-Message-State: APjAAAUIWjSbhPn/pwJk0ODBJvsmRE7tzkum65F9JWuqb4KxhDBTBtsZ
        bv43J095uP7lo81mpoy6i8qH0g==
X-Google-Smtp-Source: APXvYqyrWMFuGkiUzPNAfM5TAM9Ph9pBLGtu2H03dYgbXrosgiykubAGDOJrY/wwTtoN8wBmYa7fhA==
X-Received: by 2002:a2e:9b15:: with SMTP id u21mr20660030lji.82.1552416463413;
        Tue, 12 Mar 2019 11:47:43 -0700 (PDT)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id g65sm1493141lji.74.2019.03.12.11.47.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 11:47:42 -0700 (PDT)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Tue, 12 Mar 2019 19:47:42 +0100
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v2 3/3] rcar-csi2: Move setting of Field Detection
 Control Register
Message-ID: <20190312184742.GD1776@bigcity.dyn.berto.se>
References: <20190308235702.27057-1-niklas.soderlund+renesas@ragnatech.se>
 <20190308235702.27057-4-niklas.soderlund+renesas@ragnatech.se>
 <20190311093910.GK4775@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190311093910.GK4775@pendragon.ideasonboard.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Thanks for your feedback.

On 2019-03-11 11:39:10 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Sat, Mar 09, 2019 at 12:57:02AM +0100, Niklas Söderlund wrote:
> > Latest datasheet (rev 1.50) clarifies that the FLD register should be
> > set after LINKCNT.
> 
> Wasn't this already the case in rev 1.00 ?

Yes it is, thanks for noticing, will fix for next version.

> 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
> > Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > index 07d5c8c66b7cd382..077e0d344b395b54 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -529,7 +529,6 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >  	rcsi2_write(priv, PHTC_REG, 0);
> >  
> >  	/* Configure */
> > -	rcsi2_write(priv, FLD_REG, fld);
> >  	rcsi2_write(priv, VCDT_REG, vcdt);
> >  	if (vcdt2)
> >  		rcsi2_write(priv, VCDT2_REG, vcdt2);
> > @@ -560,6 +559,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >  	rcsi2_write(priv, PHYCNT_REG, phycnt);
> >  	rcsi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
> >  		    LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
> > +	rcsi2_write(priv, FLD_REG, fld);
> >  	rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
> >  	rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ | PHYCNT_RSTZ);
> >  
> 
> The change looks reasonable, so after updating the commit message,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Regards,
Niklas Söderlund
