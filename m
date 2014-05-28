Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21924 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaE1KCP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 06:02:15 -0400
Message-id: <5385B41E.5080503@samsung.com>
Date: Wed, 28 May 2014 12:02:06 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 2/2] media: mx2-emmaprp: Add DT bindings documentation
References: <1401176914-7358-1-git-send-email-shc_work@mail.ru>
In-reply-to: <1401176914-7358-1-git-send-email-shc_work@mail.ru>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/05/14 09:48, Alexander Shiyan wrote:
> This patch adds DT binding documentation for the Freescale enhanced
> Multimedia Accelerator (eMMA) video Pre-processor (PrP).
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  .../devicetree/bindings/media/fsl-imx-emmaprp.txt    | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt b/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
> new file mode 100644
> index 0000000..d78b1b6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
> @@ -0,0 +1,20 @@
> +* Freescale enhanced Multimedia Accelerator (eMMA) video Pre-processor (PrP)
> +  for i.MX21 & i.MX27 SoCs.
> +
> +Required properties:
> +- compatible : Shall contain "fsl,imx21-emmaprp" for compatible with
> +               the one integrated on i.MX21 SoC.
> +- reg        : Offset and length of the register set for the device.
> +- interrupts : Should contain eMMA PrP interrupt number.
> +- clocks     : Should contain the ahb and ipg clocks, in the order
> +               determined by the clock-names property.
> +- clock-names: Should be "ahb", "ipg".
> +
> +Example:
> +	emmaprp: emmaprp@10026400 {
> +		compatible = "fsl,imx27-emmaprp", "fsl,imx21-emmaprp";

As we discussed previously, please either remove "fsl,imx27-emmaprp" from
here or document it above.

> +		reg = <0x10026400 0x100>;
> +		interrupts = <51>;
> +		clocks = <&clks 49>, <&clks 68>;
> +		clock-names = "ipg", "ahb";
> +	};

There are also some checkpatch warnings:

WARNING: Use a single space after To:
#35:
To:	linux-media@vger.kernel.org

WARNING: Use a single space after Cc:
#36:
Cc:	devicetree@vger.kernel.org,

ERROR: DOS line endings
#67: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:1:
+* Freescale enhanced Multimedia Accelerator (eMMA) video Pre-processor (PrP)^M$

ERROR: DOS line endings
#68: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:2:
+  for i.MX21 & i.MX27 SoCs.^M$

ERROR: DOS line endings
#69: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:3:
+^M$

ERROR: DOS line endings
#70: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:4:
+Required properties:^M$

ERROR: DOS line endings
#71: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:5:
+- compatible : Shall contain "fsl,imx21-emmaprp" for compatible with^M$

ERROR: DOS line endings
#72: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:6:
+               the one integrated on i.MX21 SoC.^M$

ERROR: DOS line endings
#73: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:7:
+- reg        : Offset and length of the register set for the device.^M$

ERROR: DOS line endings
#74: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:8:
+- interrupts : Should contain eMMA PrP interrupt number.^M$

ERROR: DOS line endings
#75: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:9:
+- clocks     : Should contain the ahb and ipg clocks, in the order^M$

ERROR: DOS line endings
#76: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:10:
+               determined by the clock-names property.^M$

ERROR: DOS line endings
#77: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:11:
+- clock-names: Should be "ahb", "ipg".^M$

ERROR: DOS line endings
#78: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:12:
+^M$

ERROR: DOS line endings
#79: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:13:
+Example:^M$

ERROR: DOS line endings
#80: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:14:
+^Iemmaprp: emmaprp@10026400 {^M$

ERROR: DOS line endings
#81: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:15:
+^I^Icompatible = "fsl,imx27-emmaprp", "fsl,imx21-emmaprp";^M$

ERROR: DOS line endings
#82: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:16:
+^I^Ireg = <0x10026400 0x100>;^M$

ERROR: DOS line endings
#83: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:17:
+^I^Iinterrupts = <51>;^M$

ERROR: DOS line endings
#84: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:18:
+^I^Iclocks = <&clks 49>, <&clks 68>;^M$

ERROR: DOS line endings
#85: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:19:
+^I^Iclock-names = "ipg", "ahb";^M$

ERROR: DOS line endings
#86: FILE: Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt:20:
+^I};^M$

total: 20 errors, 2 warnings, 20 lines checked

[PATCH 2_2] media: mx2-emmaprp: Add DT bindings documentation.eml has style
problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


With that fixed feel free to add:

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Regards,
Sylwester
