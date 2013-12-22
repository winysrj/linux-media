Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:41290 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3LVMsr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Dec 2013 07:48:47 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	devicetree@vger.kernel.org, Rob Landley <rob@landley.net>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 01/11] dt: binding: add binding for ImgTec IR block
Date: Sun, 22 Dec 2013 13:48:43 +0100
Message-ID: <3633330.ixgGf52iFP@flatron>
In-Reply-To: <1386947579-26703-2-git-send-email-james.hogan@imgtec.com>
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com> <1386947579-26703-2-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On Friday 13 of December 2013 15:12:49 James Hogan wrote:
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

This compatible string isn't really very specific. Is there some IP
revision string that could be added, to account for possible design
changes that may require binding change?

> +- reg:			Physical base address of the controller and length of
> +			memory mapped region.
> +- interrupts:		The interrupt specifier to the cpu.
> +
> +Optional properties:
> +- clocks:		Clock specifier for base clock.
> +			Defaults to 32.768KHz if not specified.

To make the binding less fragile and allow interoperability with non-DT
platforms it may be better to provide also clock-names property (so you
can use clk_get(); that's a Linux implementation detail, though, but to
make our lives easier IMHO they should be sometimes considered too).

Best regards,
Tomasz

