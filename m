Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,URIBL_RHS_DOB,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBB6C04EB8
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 21:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B57420879
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 21:47:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B57420879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbeLDVqy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 16:46:54 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:32931 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbeLDVqy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 16:46:54 -0500
Received: by mail-ot1-f67.google.com with SMTP id i20so16697003otl.0;
        Tue, 04 Dec 2018 13:46:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PH4RkXgWZNeYmS4Q4x0zI5FNArpk5RAZvzpViRvmxU0=;
        b=MGr+KjpUfGhgoXU7UouDO7EuQ0m4UK0YzUATZt30K0wFUlr78NKkZX4nAQ9CMKLPwv
         vKLP/CrYtF7ZGdf+fvOlNVdGSlam65duuU6EC5ToDCD/Rl0FGjBtigAdQhozeLi0HFON
         lIRKWcns4aRP24f/1Jr+zJ3yvVKBzsFHUyIB5AumG6LwPXA5MxTH+44VVCS4PaHcs7k9
         edeYTUX342AAFgy3fdpi57CczWHU6O9Bu0avSA/491uD8hk2zoGkTVgDYrM3jCU496ye
         2q8HgMABQaEqwXQOTQCnDWKPO0kvlgsUqqbWjPOJV7RrGiCFbhYzc3DjYz3SY8VMHDNb
         kuLA==
X-Gm-Message-State: AA+aEWZ8vfkY12kebLxosNTY6Flnt5VrdU/AOSVKV3537Zb3qMeBRV5/
        GwJn6Jr4BR5+EqGmOENa8Q==
X-Google-Smtp-Source: AFSGD/U8r9nqGmNPXCxyLbdMTm1TWpWf0xVL0JUdVORxuPT0Qg32FbmHE/RB84KpDnmfhbOXr8/5Bw==
X-Received: by 2002:a9d:7001:: with SMTP id k1mr13005907otj.173.1543960013756;
        Tue, 04 Dec 2018 13:46:53 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id g4sm8662152otp.53.2018.12.04.13.46.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Dec 2018 13:46:52 -0800 (PST)
Date:   Tue, 4 Dec 2018 15:46:51 -0600
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
Subject: Re: [PATCH 05/15] dt-bindings: sram: sunxi: Add bindings for the H5
 with SRAM C1
Message-ID: <20181204214651.GA12991@bogus>
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
 <20181115145013.3378-6-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115145013.3378-6-paul.kocialkowski@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 15 Nov 2018 15:50:03 +0100, Paul Kocialkowski wrote:
> This introduces new bindings for the H5 SoC in the SRAM controller.
> Because the SRAM layout is different from other SoCs, no backward
> compatibility is assumed with any of them.
> 
> However, the C1 SRAM section alone looks similar to previous SoCs,
> so it is compatible with the initial A10 binding.
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  Documentation/devicetree/bindings/sram/sunxi-sram.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
