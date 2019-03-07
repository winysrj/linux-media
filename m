Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C424CC4360F
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92C33206DD
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 00:33:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="JOWD57ji"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfCGAd1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 19:33:27 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33501 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfCGAd0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 19:33:26 -0500
Received: by mail-lj1-f193.google.com with SMTP id z7so12624366lji.0
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 16:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=NfZpD1/b6kmkTS17ZhHzCVuo70rU0cPgpAyYDTvG86w=;
        b=JOWD57jiJQ+9FLq9tHgAKGK7mLjrIQKquQY3S1Ou2PYloaok0Wd+xW7j4JxV4lseOG
         I19ka2/R9TB/h3CuiV57vNU+mn/mGUNteAy26mlXN1ueejcLYPELwMQXIIV90dMUlDMB
         Mtxr9SAF00C4a6pCMomoPdEx5z/zS7/EulQBLDppE6yRModr68j/TZB7d6/o4fR6kAw3
         Y89HHQoIW3ZBeufFNnnPUEu2450RUT7/l+IC5nG1BxwDbFBItySv/NBwQ7R9W0cmFXkv
         ubD60cFWMv7hDBuKQE5F/40o5BLGIaLrHpRtKghvLsXAD45YDt7GX3VXjvAFRMQlARMi
         Lfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=NfZpD1/b6kmkTS17ZhHzCVuo70rU0cPgpAyYDTvG86w=;
        b=lMir0FcIHHkR3gURABHH/dzzfZaFpgPCIU7cvLAjWPmGrudKAgjspZ6G4lIwNqOcES
         LY2OMhXeyJnylxbsLr7IhpXZRO7HuuZ6Cu9QoDFOHEulK1bWQFO8KNas+NwWGfAbIpqs
         HGESPsfDG+G2fThoZLwFzJML7e1ZSMtrfZW67LLUClcC2qErXiocc0MYqpzAWfJu58wU
         Ca2LLrarZglkCX2tyIsfPCKLqAPgvGDkgY9wYBzJTRbLbG0Gr3pd55HY7MKE6kgfMQZm
         U/5BWKmmtB6eQhUG/3JxFYHKiuL/94ReM7hl4u66xrwwTbkl/Hf98ECeaIenHEsyG8PI
         p4zw==
X-Gm-Message-State: APjAAAWCXofMRyDD4H1BohpTV5RcSScOTMeZ1aoiHqcvemr0PthPgqpj
        fHNL9WlukmOiU0zw/y0GaUUvoQ==
X-Google-Smtp-Source: APXvYqw8gAwE9miLTOVe6kC4zeszIM8qUYvJNpi4/qHhmAkayKsBpN8hh5g6los7ExgSQ+AyvonvTA==
X-Received: by 2002:a2e:968d:: with SMTP id q13mr4092207lji.189.1551918804507;
        Wed, 06 Mar 2019 16:33:24 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id r5sm524276lfm.68.2019.03.06.16.33.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Mar 2019 16:33:23 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Thu, 7 Mar 2019 01:33:23 +0100
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/3] rcar-csi2: Move setting of Field Detection Control
 Register
Message-ID: <20190307003323.GM9239@bigcity.dyn.berto.se>
References: <20190218100313.14529-1-niklas.soderlund+renesas@ragnatech.se>
 <20190218100313.14529-4-niklas.soderlund+renesas@ragnatech.se>
 <f04a3e2a-e06b-144f-ebc3-f29e89f53801@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f04a3e2a-e06b-144f-ebc3-f29e89f53801@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

Thanks for your feedback.

On 2019-02-18 11:19:50 +0000, Kieran Bingham wrote:
> Hi Niklas,
> 
> On 18/02/2019 10:03, Niklas Söderlund wrote:
> > Latest datasheet (rev 1.50) clarifies that the FLD register should be
> > set after LINKCNT.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > index 50486301c21b4bae..f90b380478775015 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -545,7 +545,6 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> >  	rcsi2_write(priv, PHTC_REG, 0);
> >  
> >  	/* Configure */
> > -	rcsi2_write(priv, FLD_REG, fld);
> >  	rcsi2_write(priv, VCDT_REG, vcdt);
> >  	if (vcdt2)
> >  		rcsi2_write(priv, VCDT2_REG, vcdt2);
> > @@ -576,6 +575,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
> 
> Hrm ... I'm on linux-media/master and I don't see a function named
> rcsi2_start_receiver.
> 
> What base am I missing? I presume there are rework patches here in flight.

Yes it's patches in flight,

    [PATCH] rcar-csi2: Use standby mode instead of resetting

> 
> 
> >  	rcsi2_write(priv, PHYCNT_REG, phycnt);
> >  	rcsi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
> >  		    LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
> > +	rcsi2_write(priv, FLD_REG, fld);
> 
> However, I can see that this matches the flow chart in figures
> 25.{17,18,19,20}
> 
> So
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Thanks!

> 
> 
> >  	rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
> >  	rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ | PHYCNT_RSTZ);
> >  
> > 
> 
> 
> -- 
> Regards
> --
> Kieran

-- 
Regards,
Niklas Söderlund
