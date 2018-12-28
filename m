Return-Path: <SRS0=znln=PF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE043C43387
	for <linux-media@archiver.kernel.org>; Fri, 28 Dec 2018 23:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 914122186A
	for <linux-media@archiver.kernel.org>; Fri, 28 Dec 2018 23:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546038639;
	bh=aAt5e2LE6xeiZ4C8iXyR9MDLXYRjH+5CZS57v9s1F28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fTidthILwC4A49pox9MGsUK/qZynqoVDPv+V4lV+N3jqy6mweNXcnoai3KB9k5d5z
	 1+iHQSVuXsJmG3oui+nT4rwXBgy97z/OsxOFuP35p5MYP2fCY/o0OSYw08figdAbcM
	 7nLrU9TP78AsqgEkIaL7XwJ1V/z3ulVRsFqEJ4gQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbeL1XKi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 28 Dec 2018 18:10:38 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:39101 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbeL1XKi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Dec 2018 18:10:38 -0500
Received: by mail-it1-f193.google.com with SMTP id a6so28600418itl.4;
        Fri, 28 Dec 2018 15:10:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Czdni5OnmBsUn/N16pRPhQpvnmhYGnISlLMOOT6H8+g=;
        b=AB72px/sujktAoT2Viy3XeQmpW1KEYp3UyfKxD1wdSbFCYw+AbTk2LZVIk2fJ6FNbV
         s1Iy7NPUtG33PPkNTvAR2mL8ojSVfdGYxrJ7JW8cBFqkfYS6vbty8pScnPw2G1FUbxxT
         eANLiplOw/CuUkKZ9/e0URqNgnl/n156f4KWIATjPsOhwnpKsWHUK/jUPdm6UpXCIjRD
         ueHXp+BKRyi+pjGhJcZaCMzaFin5VdpI6bbPSwhYhQJLvHwZGi8hLcfqFbwsU0dc84iC
         dCKw3sgvO/bJZcssD+UtM/yZw+i53OuipzP3+8tLZ6w4ZVPuJhzoveZ8tYpFKYDKh1qW
         TGnQ==
X-Gm-Message-State: AJcUukdq8y4yWZWlkwZ5BXmJ3K2junb5V3VXs103dc+SHUzEjERXQk5B
        lh3L7aWC/JdLSGY14tIx1Q==
X-Google-Smtp-Source: ALg8bN6isZ24vPDemUaQE6eIuYBoc8NO7PevL94aMVphXsls6W3j3tcpKAdDl5P0g/AAUI30dq5M0g==
X-Received: by 2002:a02:48c6:: with SMTP id p189mr3317910jaa.89.1546038637481;
        Fri, 28 Dec 2018 15:10:37 -0800 (PST)
Received: from localhost ([24.51.61.172])
        by smtp.gmail.com with ESMTPSA id 189sm16302529itw.33.2018.12.28.15.10.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Dec 2018 15:10:36 -0800 (PST)
Date:   Fri, 28 Dec 2018 17:10:35 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de
Subject: Re: [PATCH 1/3] media: dt-bindings: add bindings for Toshiba TC358746
Message-ID: <20181228231035.GA13823@bogus>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-2-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218141240.3056-2-m.felsch@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 18 Dec 2018 15:12:38 +0100, Marco Felsch wrote:
> Add corresponding dt-bindings for the Toshiba tc358746 device.
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  .../bindings/media/i2c/toshiba,tc358746.txt   | 80 +++++++++++++++++++
>  1 file changed, 80 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
