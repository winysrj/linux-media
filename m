Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395C4C43387
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 21:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02C8621479
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 21:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546549964;
	bh=zpSSXEU4N+UuuiSmtXsJT2XmAOUax1VL3DoDfYp7Gy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Urvhu2q8ODUm+5sAY0VnQOLJV2scP9Ya8u20A99sZQhMnyHvGapBeJckNKwx59qAv
	 UL9A/DrTPqDu5NGGZ6XGj41kJzpRBsAtFjOMGwIlNrjEvWcIeiAa2i+NlB+ZzIypNK
	 1HWVh7hHBHRQKC0+L5ZfDdZ2ZHPwdt+rjdjjBURM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfACVMn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 16:12:43 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:50962 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbfACVMm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2019 16:12:42 -0500
Received: by mail-it1-f194.google.com with SMTP id z7so47215655iti.0;
        Thu, 03 Jan 2019 13:12:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FlYOtSdRWsjwZ0TfHyYrYekOBNcruTlpGQY3K9bVPdo=;
        b=blYGJacXqpppWl7Pfcs+31NbFiKW6WspwBGLBoyQT2iwACZOc19yKxhYSbO890zdPC
         VE++Rg6iWlvlyNP5VIXb44j+8EVFmKOYTHXxLWs0K1GN6ZxW7JARnhVz0KGxv6/tkJdv
         +Yx+9yZWDIgSU8LWc8ZSMPyI7T+8OuktEWsfSWLoVgDhfbD2jaTCXHaAqQfGzwUEkGB4
         Z7ozn5XZyYKpkWpwUfx+c6F7CeorLuq64+fMoCwpGbNgcnYaXErVeo28CBzYWKBciIgi
         1ahHdm5BpbiOFPixU7mkoWD9jaJrNR7XwweUv8Pn220ogIWeqyq4gKCOSez7zQt6wT5m
         SYHw==
X-Gm-Message-State: AJcUukcIk4daiRe1ZaAsQqYy/WJue1CyyHAIB9zb+UiOAPLtdFZu03si
        lMVuIjzNz+ypbM/+IAovrA==
X-Google-Smtp-Source: AFSGD/Vivky3VkQDkxvESvR08rVzaJCzNnSW5kSsAANLLMbjNWXkxwKcpbR6eNtZ460fu6nrOxQAJQ==
X-Received: by 2002:a24:3752:: with SMTP id r79mr26563165itr.121.1546549961895;
        Thu, 03 Jan 2019 13:12:41 -0800 (PST)
Received: from localhost ([24.51.61.172])
        by smtp.gmail.com with ESMTPSA id q76sm27016689iod.35.2019.01.03.13.12.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Jan 2019 13:12:41 -0800 (PST)
Date:   Thu, 3 Jan 2019 15:12:40 -0600
From:   Rob Herring <robh@kernel.org>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 02/12] media: i2c: mt9m001: dt: add binding for mt9m001
Message-ID: <20190103211240.GA31467@bogus>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545498774-11754-3-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sun, Dec 23, 2018 at 02:12:44AM +0900, Akinobu Mita wrote:
> Add device tree binding documentation for the MT9M001 CMOS image sensor.
> 
> Cc: Rob Herring <robh@kernel.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  .../devicetree/bindings/media/i2c/mt9m001.txt      | 37 ++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m001.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m001.txt b/Documentation/devicetree/bindings/media/i2c/mt9m001.txt
> new file mode 100644
> index 0000000..794b787
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9m001.txt
> @@ -0,0 +1,37 @@
> +MT9M001: 1/2-Inch Megapixel Digital Image Sensor
> +
> +The MT9M001 is an SXGA-format with a 1/2-inch CMOS active-pixel digital
> +image sensor. It is programmable through a simple two-wire serial
> +interface.

I2C?

> +
> +Required Properties:
> +
> +- compatible: shall be "onnn,mt9m001".
> +- clocks: reference to the master clock into sensor
> +
> +Optional Properties:
> +
> +- reset-gpios: GPIO handle which is connected to the reset pin of the chip.
> +  Active low.
> +- standby-gpios: GPIO handle which is connected to the standby pin of the chip.
> +  Active high.
> +
> +For further reading on port node refer to
> +Documentation/devicetree/bindings/media/video-interfaces.txt.

You still need to state how many ports/endpoints and what they are.

> +
> +Example:
> +
> +	&i2c1 {
> +		mt9m001@5d {

camera-sensor@5d

> +			compatible = "onnn,mt9m001";
> +			reg = <0x5d>;
> +			reset-gpios = <&gpio0 0 GPIO_ACTIVE_LOW>;
> +			standby-gpios = <&gpio0 1 GPIO_ACTIVE_HIGH>;
> +			clocks = <&camera_clk>;
> +			port {
> +				mt9m001_out: endpoint {
> +					remote-endpoint = <&vcap_in>;
> +				};
> +			};
> +		};
> +	};
> -- 
> 2.7.4
> 
