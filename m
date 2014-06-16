Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:45908 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaFPM3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 08:29:14 -0400
Received: by mail-la0-f50.google.com with SMTP id pv20so1554468lab.23
        for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 05:29:13 -0700 (PDT)
Message-ID: <539EE315.8040903@cogentembedded.com>
Date: Mon, 16 Jun 2014 16:29:09 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org
CC: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	magnus.damm@opensource.se, horms@verge.net.au,
	ian.molton@codethink.co.uk, william.towle@codethink.co.uk
Subject: Re: [PATCH 1/9] ARM: lager: enable i2c devices
References: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk> <1402862194-17743-2-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1402862194-17743-2-git-send-email-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 06/15/2014 11:56 PM, Ben Dooks wrote:

> Add i2c0, i2c1, i2c2 and i2c3 nodes to the Lager reference device tree as
> these busses all have devices on them that can be probed even if they
> are no drivers yet.

> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>   arch/arm/boot/dts/r8a7790-lager.dts | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)

> diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
> index dd2fe46..8617755 100644
> --- a/arch/arm/boot/dts/r8a7790-lager.dts
> +++ b/arch/arm/boot/dts/r8a7790-lager.dts
> @@ -317,3 +317,19 @@
>   	cd-gpios = <&gpio3 22 GPIO_ACTIVE_LOW>;
>   	status = "okay";
>   };
> +
> +&i2c0	{
> +	status = "ok";
> +};
> +
> +&i2c1	{
> +	status = "ok";
> +};
> +
> +&i2c2	{
> +	status = "ok";
> +};
> +
> +&i2c3	{
> +	status = "ok";
> +};

    Against which tree is this patch? It has been merged to Simon's 'devel' 
branch on my request already.

WBR, Sergei

