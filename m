Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8F0C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 16:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E716218A6
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 16:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545151355;
	bh=xH5PaGnE3VrnQPYwT4SNCK0yoPosoAaYwmM8wHs5AY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=O0lUrSugo8TrQs7nu9avXm8VJ1avMB45QCldp/zR8MT25e5DG5wCTfsfElGJf2ajo
	 zPg98gNRRIs3guSkStyosCwHdjPobUR7E5BonJE6c7/SCgeKpTK5hOvyjVLUGmLs7F
	 JozWxKeUzRjeI4c4DhQf5bN0MvJTwX4QCHl36oW4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbeLRQme (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 11:42:34 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41229 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbeLRQmd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 11:42:33 -0500
Received: by mail-ot1-f67.google.com with SMTP id u16so16241671otk.8;
        Tue, 18 Dec 2018 08:42:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VUF4PlEmBbMEtBTtqcJgKcprroSkRgjWHK7YjN7U+xc=;
        b=j3CT5RNGt0QgPLpo8BsHOHIZgqpJ2LB96shn/cBLJ6qEMUmUPzydrRpNrgIkwE68D4
         eXTzLfSyMlQ8lK0Y64tNd3iC8eN38KiM6wINcOYWJIMlGeuKyHM/ByFMUJHrY7tb5RpX
         VmrUXbP0PyHz/fhiYZE32r92/a2fqqd75lCm6IO9y9EwmfE81F88TXESfZ56lO200lzO
         5ZcMh0RC39JDoptLwssh9vBkLFhpkHQ8BFTr4gHY49Qj/I1HQ2W06203u7uIJSRo8lH0
         JgealedjaXqSogY+nAFE5ybRBqXRk94l7VQsTn9IaMgEJKwboMTLLgBwT1niJzmnJ/N/
         ja7A==
X-Gm-Message-State: AA+aEWbXZqV51z/QaNZzxvISFrlMRaRCaNizWO6USfX9u/1RpajXiDDW
        MMmsl9XrSQJPe5k3TxAYeQ==
X-Google-Smtp-Source: AFSGD/XPAyNm/2a9kISIX4xmQpaIgAf3wD4asTbiZuHIKEdWQ9x6TtQOYuQGg4kWtRggaWRcd1s8eQ==
X-Received: by 2002:a9d:490:: with SMTP id 16mr907984otm.306.1545151351891;
        Tue, 18 Dec 2018 08:42:31 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id w108sm8647658otb.6.2018.12.18.08.42.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Dec 2018 08:42:31 -0800 (PST)
Date:   Tue, 18 Dec 2018 10:42:30 -0600
From:   Rob Herring <robh@kernel.org>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dt-bindings: media: tegra-cec: Document Tegra186
 and Tegra194
Message-ID: <20181218164230.GA18480@bogus>
References: <20181211094841.16027-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211094841.16027-1-thierry.reding@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Dec 11, 2018 at 10:48:39AM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The Tegra186 and Tegra194 contain a CEC controller that is identical to
> that found in earlier generations. Document the compatible strings for
> these newer chips.

If identical, why don't you have a fallback compatible?

> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v2:
> - new patch adding missing compatible strings
> 
>  Documentation/devicetree/bindings/media/tegra-cec.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/tegra-cec.txt b/Documentation/devicetree/bindings/media/tegra-cec.txt
> index c503f06f3b84..da3590f0b7a1 100644
> --- a/Documentation/devicetree/bindings/media/tegra-cec.txt
> +++ b/Documentation/devicetree/bindings/media/tegra-cec.txt
> @@ -8,6 +8,8 @@ Required properties:
>  	"nvidia,tegra114-cec"
>  	"nvidia,tegra124-cec"
>  	"nvidia,tegra210-cec"
> +	"nvidia,tegra186-cec"
> +	"nvidia,tegra194-cec"
>    - reg : Physical base address of the IP registers and length of memory
>  	  mapped region.
>    - interrupts : HDMI CEC interrupt number to the CPU.
> -- 
> 2.19.1
> 
