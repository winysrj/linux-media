Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31080 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaLRMN2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 07:13:28 -0500
Message-id: <5492C4E3.4050401@samsung.com>
Date: Thu, 18 Dec 2014 13:13:23 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	m.chehab@samsung.com, linux-arm-kernel@lists.infradead.org,
	laurent.pinchart@ideasonboard.com, festevam@gmail.com,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 5/5] media: ov2640: dt: add the device tree binding
 document
References: <1418869646-17071-1-git-send-email-josh.wu@atmel.com>
 <1418869646-17071-6-git-send-email-josh.wu@atmel.com>
In-reply-to: <1418869646-17071-6-git-send-email-josh.wu@atmel.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On 18/12/14 03:27, Josh Wu wrote:
> Add the document for ov2640 dt.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Josh Wu <josh.wu@atmel.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

It seems "ovti" is not in the list of vendor prefixes. You may want
to send a patch adding it to Documentation/devicetree/bindings/
vendor-prefixes.txt.

Just few minor comments below..

>  .../devicetree/bindings/media/i2c/ov2640.txt       | 46 ++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2640.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov2640.txt b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
> new file mode 100644
> index 0000000..de11ebb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov2640.txt
> @@ -0,0 +1,46 @@
> +* Omnivision ov2640 CMOS sensor

s/ov2640/OV2640 ?

> +
> +The Omnivision OV2640 sensor support multiple resolutions output, such as
> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
> +output format.
> +
> +Required Properties:
> +- compatible: Must be "ovti,ov2640"

I believe it is preferred to put it as "Should contain", rather than
"Must be".

> +- clocks: reference to the xvclk input clock.
> +- clock-names: Must be "xvclk".

--
Regards,
Sylwester
