Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:52435 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3LVK47 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Dec 2013 05:56:59 -0500
Date: Sun, 22 Dec 2013 08:56:50 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: James Hogan <james.hogan@imgtec.com>, devicetree@vger.kernel.org
Cc: linux-media@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 01/11] dt: binding: add binding for ImgTec IR block
Message-id: <20131222085650.064e7ecd@samsung.com>
In-reply-to: <1386947579-26703-2-git-send-email-james.hogan@imgtec.com>
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
 <1386947579-26703-2-git-send-email-james.hogan@imgtec.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Dec 2013 15:12:49 +0000
James Hogan <james.hogan@imgtec.com> escreveu:

> Add device tree binding for ImgTec Consumer Infrared block.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: devicetree@vger.kernel.org
> Cc: Rob Landley <rob@landley.net>
> Cc: linux-doc@vger.kernel.org

It looks ok for me, but we should wait for a DT maintainer ack for
this one.

Regards,
Mauro

> ---
>  Documentation/devicetree/bindings/media/img-ir.txt | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/img-ir.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/img-ir.txt b/Documentation/devicetree/bindings/media/img-ir.txt
> new file mode 100644
> index 000000000000..6f623b094ea6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/img-ir.txt
> @@ -0,0 +1,20 @@
> +* ImgTec Infrared (IR) decoder
> +
> +Required properties:
> +- compatible:		Should be "img,ir"
> +- reg:			Physical base address of the controller and length of
> +			memory mapped region.
> +- interrupts:		The interrupt specifier to the cpu.
> +
> +Optional properties:
> +- clocks:		Clock specifier for base clock.
> +			Defaults to 32.768KHz if not specified.
> +
> +Example:
> +
> +	ir@02006200 {
> +		compatible = "img,ir";
> +		reg = <0x02006200 0x100>;
> +		interrupts = <29 4>;
> +		clocks = <&clk_32khz>;
> +	};


-- 

Cheers,
Mauro
