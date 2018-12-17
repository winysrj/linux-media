Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43889C43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 14:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 115AD2146E
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 14:47:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="ra0yEcGi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733007AbeLQOrS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 09:47:18 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40690 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732120AbeLQOrR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 09:47:17 -0500
Received: by mail-lj1-f196.google.com with SMTP id n18-v6so11193557lji.7
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2018 06:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=2JMGd7RkswsBCgYWPlA713OVU3sv3kmaD3616UYCMec=;
        b=ra0yEcGiTii8wDpAw2fAAP7J3GRLuWImwIReNxt6FoGsqylEFFrYr1wTZnBYLnQGqq
         KEwfMk4/S0F2b0+2Yv3UQMIqA7OwAuF1tGwfnWvh3dOKhIJj7/onMK1bJaxYqDvASt1V
         iptpNvG+afJtbLh6kQrj9pnicjH1fd4i0NR/Vt4A7SjKYrYvNOADjgBG7pawUnPROqhf
         pHTeCQUPpFqUH8ziC6oEsss+Rou8jxIQLBYDjOUs8mqnul437yH+xT5ojX01ix3aKrmF
         NaEJr4wu9Q/2MktOzQxAS43eI3OjJkJJHmYB6UCsGYRvlgFqEEInzu33Y3CZ4jyIl4kK
         MY5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=2JMGd7RkswsBCgYWPlA713OVU3sv3kmaD3616UYCMec=;
        b=CdBaI+P/q3OSLgIu/BPj2pI3LwFEqmKiWv1xfbFWAIkiEixLXylSkKZoeGIvmvFJeH
         kHMs1ueehuvfy+t9EfkMsYCZxrro2jYAx/TLKH7kcZREWuQ8X/QrYZWJvTOYajNC2U4s
         pvlH4gkLHE8vysHELxsx7H+UL8BEnbD43p0zcTd8e/bsS6JLP2yjePF7eQE432QSnhCW
         DZtTevsU/+ruu6s/GhB4ySMJ6+OhlCWUrvc1oYnlls44dMOEbah7TfIDtVXSCgSItXNv
         MWw2xJZvSOk3xfaWRDijOk+G3bt2gCFAFl6MqN3Z0AY/rz4IjuZ5hw76ja/vZRR2Ck+N
         aVMA==
X-Gm-Message-State: AA+aEWav5Z2lRnCLVJEhnzlhd/sghIXIBZ1v7qxMOqu3yED9JmbhZcGX
        kYioZcQ5PNlcoO2xeS/TQgjuOw==
X-Google-Smtp-Source: AFSGD/WdO7A1DCkqSFYOf+/SbgougeoCApCGBwotlBZPfzZxKCGPzvVup5Xf2qwrVby2RZQv1JBRmQ==
X-Received: by 2002:a2e:9356:: with SMTP id m22-v6mr3174371ljh.135.1545058034736;
        Mon, 17 Dec 2018 06:47:14 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id h12-v6sm2585432ljb.80.2018.12.17.06.47.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Dec 2018 06:47:14 -0800 (PST)
Date:   Mon, 17 Dec 2018 15:47:13 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH] media: dt-bindings: rcar-vin: Add R8A774C0 support
Message-ID: <20181217144713.GR17972@bigcity.dyn.berto.se>
References: <1544732519-6956-1-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1544732519-6956-1-git-send-email-fabrizio.castro@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Fabrizio,

Thanks for your patch.

On 2018-12-13 20:21:59 +0000, Fabrizio Castro wrote:
> Add the compatible string for RZ/G2E (a.k.a. R8A774C0) to the list
> of SoCs supported by rcar-vin driver.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 7c878ca..34dcd28 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -7,12 +7,13 @@ family of devices.
>  Each VIN instance has a single parallel input that supports RGB and YUV video,
>  with both external synchronization and BT.656 synchronization for the latter.
>  Depending on the instance the VIN input is connected to external SoC pins, or
> -on Gen3 platforms to a CSI-2 receiver.
> +on Gen3 and RZ/G2 platforms to a CSI-2 receiver.
>  
>   - compatible: Must be one or more of the following
>     - "renesas,vin-r8a7743" for the R8A7743 device
>     - "renesas,vin-r8a7744" for the R8A7744 device
>     - "renesas,vin-r8a7745" for the R8A7745 device
> +   - "renesas,vin-r8a774c0" for the R8A774C0 device
>     - "renesas,vin-r8a7778" for the R8A7778 device
>     - "renesas,vin-r8a7779" for the R8A7779 device
>     - "renesas,vin-r8a7790" for the R8A7790 device
> @@ -60,10 +61,10 @@ The per-board settings Gen2 platforms:
>      - data-enable-active: polarity of CLKENB signal, see [1] for
>        description. Default is active high.
>  
> -The per-board settings Gen3 platforms:
> +The per-board settings Gen3 and RZ/G2 platforms:
>  
> -Gen3 platforms can support both a single connected parallel input source
> -from external SoC pins (port@0) and/or multiple parallel input sources
> +Gen3 and RZ/G2 platforms can support both a single connected parallel input
> +source from external SoC pins (port@0) and/or multiple parallel input sources
>  from local SoC CSI-2 receivers (port@1) depending on SoC.
>  
>  - renesas,id - ID number of the VIN, VINx in the documentation.
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
