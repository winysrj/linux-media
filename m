Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:63411 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbaCGPuR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 10:50:17 -0500
Received: by mail-la0-f47.google.com with SMTP id y1so2894616lam.20
        for <linux-media@vger.kernel.org>; Fri, 07 Mar 2014 07:50:16 -0800 (PST)
Message-ID: <5319F8D1.5050608@cogentembedded.com>
Date: Fri, 07 Mar 2014 19:50:25 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>, linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
	linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 2/5] ARM: lager: add vin1 node
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk> <1394197299-17528-3-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1394197299-17528-3-git-send-email-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 03/07/2014 04:01 PM, Ben Dooks wrote:

> Add device-tree for vin1 (composite video in) on the
> lager board.

> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

    This patch should have been preceded by the VIN driver patch and bindings 
description, don't you think?

> diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
> index a087421..7528cfc 100644
> --- a/arch/arm/boot/dts/r8a7790-lager.dts
> +++ b/arch/arm/boot/dts/r8a7790-lager.dts
[...]
> @@ -239,8 +244,41 @@
>   	status = "ok";
>   	pinctrl-0 = <&i2c2_pins>;
>   	pinctrl-names = "default";
> +
> +	adv7180: adv7180@0x20 {

    ePAPR standard [1] tells us that:

"The name of a node should be somewhat generic, reflecting the function of the 
device and not its precise programming model."

    So, I would suggest something like "video-decoder" instead. And remove 
"0x" from the address part of the node name please.

[1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

WBR, Sergei

