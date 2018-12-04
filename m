Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,URIBL_RHS_DOB,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67267C04EB8
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 21:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AFC42087F
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 21:47:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AFC42087F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbeLDVrP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 16:47:15 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35366 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbeLDVrO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 16:47:14 -0500
Received: by mail-ot1-f65.google.com with SMTP id 81so16714697otj.2;
        Tue, 04 Dec 2018 13:47:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yVUJodPAOpNCa1SKM6GXt/gdr2CgnzPhl3+TDP57p44=;
        b=RNQowSFN19pNlaRfeqmyrVA6/G00h7fshWnnf9KsUitqP3QCAhLmnNw/UwDV6yb5IT
         RpeXg6JLSR/y+dZXM2quNzhOZGLy4gaKjCRYFFO5/unHenp68WY+scKtFpZGrmiJi9FV
         LxOHFwDad/Y0zd6ZF3vl8ga/jHwz0T+VbAURBGz7TnGdtMWzCdfkkM7VQdVEUW9CTUAq
         9aiNF+awjVefLD/03giccB2wpkOQZQh89HElveCrQ3D4RYzdCTxBLvto2sAL0llbGJlm
         2ZDR4kT/wNmqb/wydLx9YRZKRgZfFcgCzdgfvYdo5hySXUD+0++xSgZQCzl2rvpJn3fB
         uPlw==
X-Gm-Message-State: AA+aEWZIpu16Fcrj+iah7w+SulPGe8n9HTrEsN4UaC3zuNnbUayzTlUn
        kky7R0fcm4QmOmzPstjR/dWyXPQ=
X-Google-Smtp-Source: AFSGD/UuAGIWngwkzkYmLayZEs56iX8DKwGYfgU2uqoR2asba1dwu+m+nb+ngnEniBQgSaLfaca/NQ==
X-Received: by 2002:a9d:6d81:: with SMTP id x1mr12765534otp.17.1543960033884;
        Tue, 04 Dec 2018 13:47:13 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id x92sm10213690ota.55.2018.12.04.13.47.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Dec 2018 13:47:13 -0800 (PST)
Date:   Tue, 4 Dec 2018 15:47:12 -0600
From:   Rob Herring <robh@kernel.org>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH 09/15] dt-bindings: sram: sunxi: Add compatible for the
 A64 SRAM C1
Message-ID: <20181204214712.GA13571@bogus>
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
 <20181115145013.3378-10-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115145013.3378-10-paul.kocialkowski@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 15 Nov 2018 15:50:07 +0100, Paul Kocialkowski wrote:
> This introduces a new compatible for the A64 SRAM C1 section, that is
> compatible with the SRAM C1 section as found on the A10.
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  Documentation/devicetree/bindings/sram/sunxi-sram.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
