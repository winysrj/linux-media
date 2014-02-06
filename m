Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:42953 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbaBFLYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 06:24:14 -0500
Date: Thu, 06 Feb 2014 09:24:05 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Rob Landley <rob@landley.net>,
	Tomasz Figa <tomasz.figa@gmail.com>
Cc: James Hogan <james.hogan@imgtec.com>, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 06/15] dt: binding: add binding for ImgTec IR block
Message-id: <20140206092405.49170eed@samsung.com>
In-reply-to: <1389967140-20704-7-git-send-email-james.hogan@imgtec.com>
References: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
 <1389967140-20704-7-git-send-email-james.hogan@imgtec.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 17 Jan 2014 13:58:51 +0000
James Hogan <james.hogan@imgtec.com> escreveu:

> Add device tree binding for ImgTec Consumer Infrared block, specifically
> major revision 1 of the hardware.

@DT maintainers:

ping.


> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: devicetree@vger.kernel.org
> Cc: Rob Landley <rob@landley.net>
> Cc: linux-doc@vger.kernel.org
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> ---
> v2:
> - Future proof compatible string from "img,ir" to "img,ir1", where the 1
>   corresponds to the major revision number of the hardware (Tomasz
>   Figa).
> - Added clock-names property and three specific clock names described in
>   the manual, only one of which is used by the current driver (Tomasz
>   Figa).
> ---
>  .../devicetree/bindings/media/img-ir1.txt          | 30 ++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/img-ir1.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/img-ir1.txt b/Documentation/devicetree/bindings/media/img-ir1.txt
> new file mode 100644
> index 0000000..ace5fd9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/img-ir1.txt
> @@ -0,0 +1,30 @@
> +* ImgTec Infrared (IR) decoder version 1
> +
> +This binding is for Imagination Technologies' Infrared decoder block,
> +specifically major revision 1.
> +
> +Required properties:
> +- compatible:		Should be "img,ir1"
> +- reg:			Physical base address of the controller and length of
> +			memory mapped region.
> +- interrupts:		The interrupt specifier to the cpu.
> +
> +Optional properties:
> +- clocks:		List of clock specifiers as described in standard
> +			clock bindings.
> +- clock-names:		List of clock names corresponding to the clocks
> +			specified in the clocks property.
> +			Accepted clock names are:
> +			"core":	Core clock (defaults to 32.768KHz if omitted).
> +			"sys":	System side (fast) clock.
> +			"mod":	Power modulation clock.
> +
> +Example:
> +
> +	ir@02006200 {
> +		compatible = "img,ir1";
> +		reg = <0x02006200 0x100>;
> +		interrupts = <29 4>;
> +		clocks = <&clk_32khz>;
> +		clock-names =  "core";
> +	};


-- 

Cheers,
Mauro
