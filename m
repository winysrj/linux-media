Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A683FC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 15:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C218218FF
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 15:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550159066;
	bh=j0BBQFh8PsRbcnfmUNCZouKJF2VaagXrgdMC2tU9wBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=G6t9I8nWDs0ThKRaaePUlRTgC9zncRDchWY40yJsGFMMbIoZoEJqeKo8lwdJ35RdE
	 UCPG/tQqCmKTrbIn/uLAcFplvdRw6EwpxDVKgYwefmCL2dKzRaL1zO1uyyBnzJMpu8
	 qSJzihwjmrKVakBK98x2EltRa0UJIwc6Qy10aRyU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439181AbfBNPoZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 10:44:25 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36994 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387758AbfBNPoY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 10:44:24 -0500
Received: by mail-ot1-f65.google.com with SMTP id b3so11210900otp.4;
        Thu, 14 Feb 2019 07:44:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hHm600lKUGJ6q3Hj7gROm6nbiIQqf5d7bl54AyOhBUI=;
        b=I3dS5jBsAY1X9UqVGr155fkmaOEbid8M+A7prhEBW5byUqCCaU3mygrlJTEaH+ix7D
         D8UbqJJie+DeFW2gd0PprFRK5+AWaDUufsKgWJs2ktr5NzB8eYEXjVxvxp64kJsO+x3z
         i6FTdujwRuCKVnNM+qhxGE5575/w7lLnLcGeM9thlYMyTzDfRAg0nteYXxR16u9lcv3C
         Kuz8dwzvCeZYLfOJKYI6XHhK9PUW5itwYxtHm+9u07fyxvLIjBiLWBTdVnMMeZI5PZHh
         IfYE5ZqhCoDLdfSpeExlcoKJINjmLFShvI/CSojWSinBlwmiMEIJA2zOYKhsBlDOSm0f
         hkHw==
X-Gm-Message-State: AHQUAubV6QrUMTfwp4v61m9DXFKKK8AD7hrvI7nKvXA02BJk73L40o7L
        hCbLC830oTV2dxjq1gCxo3OXWDM=
X-Google-Smtp-Source: AHgI3IYaN1s3j0lbT+jsiW0C0BCNo7dTehHxA/sEGbQWhDyDkIlayZ3Hu72urhQ/4i53Oo8DL0VIiQ==
X-Received: by 2002:aca:fc09:: with SMTP id a9mr2615352oii.106.1550159063762;
        Thu, 14 Feb 2019 07:44:23 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id d18sm1076883oth.9.2019.02.14.07.44.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Feb 2019 07:44:23 -0800 (PST)
Date:   Thu, 14 Feb 2019 09:44:22 -0600
From:   Rob Herring <robh@kernel.org>
To:     Ken Sloat <KSloat@aampglobal.com>
Cc:     "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] media: atmel-isc: Update device tree binding
 documentation
Message-ID: <20190214154422.GA18167@bogus>
References: <20190204141756.234563-1-ksloat@aampglobal.com>
 <20190204141756.234563-2-ksloat@aampglobal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204141756.234563-2-ksloat@aampglobal.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Feb 04, 2019 at 02:18:14PM +0000, Ken Sloat wrote:
> From: Ken Sloat <ksloat@aampglobal.com>

Needs a better subject, not one that applies to any change. Update with 
what?

> Update device tree binding documentation specifying how to
> enable BT656 with CRC decoding and specify properties for
> default parallel bus type.
> 
> Signed-off-by: Ken Sloat <ksloat@aampglobal.com>
> ---
>  Changes in v2:
>  -Use correct media "bus-type" dt property.
> 
>  Changes in v3:
>  -Specify default bus type.
>  -Document optional parallel bus flags.
> 
>  .../devicetree/bindings/media/atmel-isc.txt       | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/atmel-isc.txt b/Documentation/devicetree/bindings/media/atmel-isc.txt
> index bbe0e87c6188..db3749a3964f 100644
> --- a/Documentation/devicetree/bindings/media/atmel-isc.txt
> +++ b/Documentation/devicetree/bindings/media/atmel-isc.txt
> @@ -21,6 +21,21 @@ Required properties for ISC:
>  - pinctrl-names, pinctrl-0
>  	Please refer to pinctrl-bindings.txt.
>  
> +Optional properties for ISC:
> +- bus-type
> +	When set to 6, Bt.656 decoding (embedded sync) with CRC decoding
> +	is enabled. If omitted, then the default bus-type is parallel and
> +	the additional properties to follow can be specified:
> +- hsync-active
> +	Active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
> +	If unspecified, this signal is set as active HIGH.
> +- vsync-active
> +	Active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
> +	If unspecified, this signal is set as active HIGH.
> +- pclk-sample
> +	Sample data on rising (1) or falling (0) edge of the pixel clock
> +	signal. If unspecified, data is sampled on the rising edge.

These are all common properties, right? No need to redefine them. Just 
reference the common doc. Maybe the default needs to be stated here if 
different or not defined.

> +
>  ISC supports a single port node with parallel bus. It should contain one
>  'port' child node with child 'endpoint' node. Please refer to the bindings
>  defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
> -- 
> 2.17.1
> 
