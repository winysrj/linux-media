Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_DKIMWL_WL_HIGH,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01125C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 23:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC1E121104
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 23:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544224095;
	bh=MphtR6+5fYkYfkwl36HkBzj1aWnp6wOqtOR/ZcnLO5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Q1TyjTqId7SC/Hw9cdaxCWZemLXRfBhSioFYLxEQZrx6AAgerB8eTAdylbOe0Fvj4
	 /VkxcuB9ugxVtkhxWAuqNqVeq/oTjH096SmP1JTREI/SWWA6Ij2jlNCBx0TDpQS32l
	 PdtKspsi2j3zQrt57+n/KIC6jll5CDevxXXQPpi0=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC1E121104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbeLGXIO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 18:08:14 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38866 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbeLGXIO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 18:08:14 -0500
Received: by mail-oi1-f195.google.com with SMTP id a77so4712570oii.5;
        Fri, 07 Dec 2018 15:08:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Edu1oagco56qxb2A9ZJf6b1HqdInbELZM/K14uVXrAs=;
        b=tPS1GOW3fXyeprj/U80QvE+5T8H3RxlOr3ZIoy1wNJy1jW6XWUgbDQhC/7P55NMs5E
         vTrEVpc6NnvDTGhjh7B5xh3r1fK1npLCXlWh6v90aIXEOFzwOw6KbcXx2EXuSZNdPDdS
         Hsu1V6Yg1Wr6yw20Ub9Qa0em/oyCCesJPa4tPvkhfno87CgDUEvCQOr1/+Au9zSouFG/
         YH6Uf0wwU+i4hKQLaatFAxe+D8NGd03cwNvZppNQ10rSBDlmnKP19/tesI+Aimqk7yrJ
         eG3fJz6HVHWK0xBwd9GCOFkK+J5YM06R9TkTB/J0nnEP7WgNIpgltQgDSrbo8LqYYwdx
         TtJQ==
X-Gm-Message-State: AA+aEWY0jbRbQiHWS9UhT+VjiXa9spp4sjpUhcUtoaJ36H5UuWMcGfQB
        Byy+EWgVF7acrLGfH98cwH5wMCw=
X-Google-Smtp-Source: AFSGD/W/q55LhlW4fM9F0wzxAWgfqQEQIs4QOEobEGY0jGV77gF2+wWRwToI1pmdgJfjrqnMXeGcmQ==
X-Received: by 2002:aca:4586:: with SMTP id s128mr2523920oia.182.1544224093140;
        Fri, 07 Dec 2018 15:08:13 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id y20sm3247826otk.66.2018.12.07.15.08.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Dec 2018 15:08:12 -0800 (PST)
Date:   Fri, 7 Dec 2018 17:08:11 -0600
From:   Rob Herring <robh@kernel.org>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 1/4] dt-bindings: adv748x: make data-lanes property
 mandatory for CSI-2 endpoints
Message-ID: <20181207230811.GA2563@bogus>
References: <20181129020147.22115-1-niklas.soderlund+renesas@ragnatech.se>
 <20181129020147.22115-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181129020147.22115-2-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 29 Nov 2018 03:01:44 +0100, =?UTF-8?q?Niklas=20S=C3=B6derlund?=          wrote:
> The CSI-2 transmitters can use a different number of lanes to transmit
> data. Make the data-lanes mandatory for the endpoints that describe the
> transmitters as no good default can be set to fallback on.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> ---
> * Changes since v3
> - Add paragraph to describe the accepted values for the source endpoint
>   data-lane property. Thanks Jacopo for pointing this out and sorry for
>   missing this in v2.
> * Changes since v2
> - Update paragraph according to Laurents comments.
> ---
>  .../devicetree/bindings/media/i2c/adv748x.txt         | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
