Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35020 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbcFFN3Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2016 09:29:25 -0400
Date: Mon, 6 Jun 2016 08:29:23 -0500
From: Rob Herring <robh@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] device tree description for AD5820 camera auto-focus coil
Message-ID: <20160606132923.GA18804@rob-hp-laptop>
References: <20160524090433.GA1277@amd>
 <20160524091746.GA14536@amd>
 <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
 <20160527205140.GA26767@amd>
 <20160531212222.GP26360@valkosipuli.retiisi.org.uk>
 <20160531213437.GA28397@amd>
 <20160601152439.GQ26360@valkosipuli.retiisi.org.uk>
 <20160601220840.GA21946@amd>
 <20160602074544.GR26360@valkosipuli.retiisi.org.uk>
 <20160602193027.GB7984@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160602193027.GB7984@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 02, 2016 at 09:30:27PM +0200, Pavel Machek wrote:
> 
> Add documentation for ad5820 device tree binding.
> 
> Signed-off-by: Pavel Machek <pavel@denx.de>
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ad5820.txt b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> new file mode 100644
> index 0000000..fb70ca5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> @@ -0,0 +1,19 @@
> +* Analog Devices AD5820 autofocus coil
> +
> +Required Properties:
> +
> +  - compatible: Must contain "adi,ad5820"
> +
> +  - reg: I2C slave address
> +
> +  - VANA-supply: supply of voltage for VANA pin
> +
> +Example:
> +
> +       ad5820: coil@0c {

Drop the leading 0. With that,

Acked-by: Rob Herring <robh@kernel.org>
