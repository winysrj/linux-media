Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:38894 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaBFOdT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 09:33:19 -0500
MIME-Version: 1.0
In-Reply-To: <1389967140-20704-7-git-send-email-james.hogan@imgtec.com>
References: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
	<1389967140-20704-7-git-send-email-james.hogan@imgtec.com>
Date: Thu, 6 Feb 2014 08:33:17 -0600
Message-ID: <CAL_Jsq+wk6_9Da5Xj3Ys-MZYPTpu6V3pAEpGFv44148BodmmrQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/15] dt: binding: add binding for ImgTec IR block
From: Rob Herring <robherring2@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Rob Landley <rob@landley.net>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 17, 2014 at 7:58 AM, James Hogan <james.hogan@imgtec.com> wrote:
> Add device tree binding for ImgTec Consumer Infrared block, specifically
> major revision 1 of the hardware.
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
> +- compatible:          Should be "img,ir1"

Kind of short for a name. I don't have anything much better, but how
about img,ir-rev1.

> +- reg:                 Physical base address of the controller and length of
> +                       memory mapped region.
> +- interrupts:          The interrupt specifier to the cpu.
> +
> +Optional properties:
> +- clocks:              List of clock specifiers as described in standard
> +                       clock bindings.
> +- clock-names:         List of clock names corresponding to the clocks
> +                       specified in the clocks property.
> +                       Accepted clock names are:
> +                       "core": Core clock (defaults to 32.768KHz if omitted).
> +                       "sys":  System side (fast) clock.
> +                       "mod":  Power modulation clock.

You need to define the order of clocks including how they are
interpreted with different number of clocks (not relying on the name).
Although, if the h/w block really has different number of clock
inputs, then it is a different h/w block and should have a different
compatible string.

Rob
