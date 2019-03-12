Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309F2C10F00
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 19:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD4382147C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 19:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552419032;
	bh=uLdV61BoSexkd+tMFnMtfJg1umQVZdDeZg691ofTirY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=diUjVsukGUHALbNmnApOdcZOalDj11B2C386xB009XvSKHuKcbEePsrOKhdRGShwf
	 /AMsjZdwcnHSNgWYioX4tJ9L8O7u6SgJecGjdbmZtyNp70StNqeZwwqgtEwevTR8vX
	 okTebPvmIo8Vp0MSwiMhJvt3jNoR0a9TfGgAeBnA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfCLTab (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 15:30:31 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34311 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfCLTa3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 15:30:29 -0400
Received: by mail-ot1-f68.google.com with SMTP id r19so3617776otn.1;
        Tue, 12 Mar 2019 12:30:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=g7fBk2E0w6F0Sq10FcEpejKscfp3hSpPjkPjrM5/j7Y=;
        b=LdCm/sCSTVkvUnb/LxfW5Axy/GxFNC8Gd3R14DMholE8lC0y89B5oGsapnpI7/e1er
         Vu0RvBpLtf0XhdpoQtErDf+HoBxpoRUvRMmxcuozWkH9L4fgUkY9uCaMJXmmEBpucsUA
         MRc05A2CrNhXHP5U/+iE9OIVNHTCXct5GJokxRRUZSmIPpQGrR7ym7HgFRswGUvQMDFc
         fRp+7yGnkgI0j5lzOQDGsOjmUHvuQzAh9kPyoGpAJytV0eHnTCpT8wWzh7B1XLbPF+r3
         gqCkEBH8OIELhKhV8P4qesjhltjnpMVFBzZNCJDJC+yjvCybI8SgcySASZ23cOabMArn
         R9uQ==
X-Gm-Message-State: APjAAAX0AV9KamRZiPm77WqqeB9r9K0FAiBYzH+yFt8z8BCi1mV2xLTV
        0qL/ihQWkLR4J/NHFHjOt1I/WXY/zg==
X-Google-Smtp-Source: APXvYqyeBglc2D6gbG5NUs/J+YX0yWU4mMrBtRfG3Ce3zrLe8xieY2ZEaXNlQElEqF8XjNCoUNhfJw==
X-Received: by 2002:a9d:6f10:: with SMTP id n16mr24766009otq.105.1552419028508;
        Tue, 12 Mar 2019 12:30:28 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id w125sm3722039oiw.10.2019.03.12.12.30.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 12:30:27 -0700 (PDT)
Date:   Tue, 12 Mar 2019 14:30:27 -0500
From:   Rob Herring <robh@kernel.org>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: rcar-csi2: List resets as a
 mandatory property
Message-ID: <20190312193027.GA26420@bogus>
References: <20190308234722.25775-1-niklas.soderlund+renesas@ragnatech.se>
 <20190308234722.25775-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190308234722.25775-2-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat,  9 Mar 2019 00:47:21 +0100, =?UTF-8?q?Niklas=20S=C3=B6derlund?= wrote:
> The resets property will become mandatory to operate the device, list it
> as such. All device tree source files have always included the reset
> property so making it mandatory will not introduce any regressions.
> 
> While at it improve the description for the clocks property.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
