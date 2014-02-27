Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:41766 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaB0WwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 17:52:22 -0500
Received: by mail-wg0-f51.google.com with SMTP id a1so3432093wgh.34
        for <linux-media@vger.kernel.org>; Thu, 27 Feb 2014 14:52:20 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Rob Herring <robh+dt@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
	Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH v3 06/15] dt: binding: add binding for ImgTec IR block
Date: Thu, 27 Feb 2014 22:52:10 +0000
Message-ID: <2514111.qYAaEZbJqk@radagast>
In-Reply-To: <1391788155-29191-1-git-send-email-james.hogan@imgtec.com>
References: <CAL_JsqLL6MbwajCUAm+NJk=ofL5OHq8b0zwO3LFb-TKY6UtVMQ@mail.gmail.com> <1391788155-29191-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3032664.G9CoYg8UyZ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart3032664.G9CoYg8UyZ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Rob, Mark + DT maintainers,

On Friday 07 February 2014 15:49:15 James Hogan wrote:
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
> v3:
> - Rename compatible string to "img,ir-rev1" (Rob Herring).
> - Specify ordering of clocks explicitly (Rob Herring).

I'd appreciate if somebody could give this another glance after the two 
changes listed above and Ack it (I'll probably be posting a v4 patchset 
tomorrow).

Thanks
James

> 
> v2:
> - Future proof compatible string from "img,ir" to "img,ir1", where the 1
>   corresponds to the major revision number of the hardware (Tomasz
>   Figa).
> - Added clock-names property and three specific clock names described in
>   the manual, only one of which is used by the current driver (Tomasz
>   Figa).
> ---
>  .../devicetree/bindings/media/img-ir-rev1.txt      | 34
> ++++++++++++++++++++++ 1 file changed, 34 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/img-ir-rev1.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/img-ir-rev1.txt
> b/Documentation/devicetree/bindings/media/img-ir-rev1.txt new file mode
> 100644
> index 000000000000..5434ce61b925
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/img-ir-rev1.txt
> @@ -0,0 +1,34 @@
> +* ImgTec Infrared (IR) decoder version 1
> +
> +This binding is for Imagination Technologies' Infrared decoder block,
> +specifically major revision 1.
> +
> +Required properties:
> +- compatible:		Should be "img,ir-rev1"
> +- reg:			Physical base address of the controller and length of
> +			memory mapped region.
> +- interrupts:		The interrupt specifier to the cpu.
> +
> +Optional properties:
> +- clocks:		List of clock specifiers as described in standard
> +			clock bindings.
> +			Up to 3 clocks may be specified in the following order:
> +			1st:	Core clock (defaults to 32.768KHz if omitted).
> +			2nd:	System side (fast) clock.
> +			3rd:	Power modulation clock.
> +- clock-names:		List of clock names corresponding to the clocks
> +			specified in the clocks property.
> +			Accepted clock names are:
> +			"core":	Core clock.
> +			"sys":	System clock.
> +			"mod":	Power modulation clock.
> +
> +Example:
> +
> +	ir@02006200 {
> +		compatible = "img,ir-rev1";
> +		reg = <0x02006200 0x100>;
> +		interrupts = <29 4>;
> +		clocks = <&clk_32khz>;
> +		clock-names =  "core";
> +	};

--nextPart3032664.G9CoYg8UyZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTD8GhAAoJEKHZs+irPybfoIgQAKicjFw7u+gGXjf4BLwamfvk
0igzIf+/nPxYBmt/21UXkrhoEnk1pV8ECdwtnfqeUBUL7lOB7kLBh44X7Yf5Ynvw
GHXV/SeFYfoT81RSg/VXA0bNDuStuAi8YqhM4jDjfTxBd5vP1jIJBkdxbsAHrA3Z
voDoKeOwaJ4tVQ/JrADyj9YmoNwo7y7lma0hzKPg6sY9xMh2tcmta8aakX2g5lEW
Xy+k4OuAlN0STB6hEiauJ2hLSKe7BRKF+6+DdL4Pu3v5hevwukQiv4jj/u4I9mNi
AbtnisoI08BJ/3/GpVHhc5svU6TRKMZVvNXBQANEiAb2g9b1lav+xe7+Qc/P1vZN
ItDm/IcOeQc7Sxq2CNLGnOaVuYgGHlewj3Rym3nZech5HAT5zped0LEWwwwUlKRt
ixO7CAZGvd3ifFnW2XyG8f5G0JhCRJ8VuPV0m/Vpp3S+KNQAkfCmzz9Dba066fBD
FCIsJvg2xKjFHuEs5D2BP9PhY1/mUM38XVyLWt3XEmV0xBHUtgBNqWpIFb1zxQ7E
onFmycxLgiyHtt07jXpT6dKuC1ROhms5peZwT9xZN8fyff0/VaaLKC5jLsPeaWRF
dDt5t8yRbuypMQ11V7yfAHGkVs1OrZaADWUay68zPpacz/dGmfq3K/hvlaEkKPBD
E2zneM28RB6ZOcfthT06
=c/1a
-----END PGP SIGNATURE-----

--nextPart3032664.G9CoYg8UyZ--

