Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52236 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbcEJCSe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2016 22:18:34 -0400
Date: Tue, 10 May 2016 04:18:27 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	Benoit Cousson <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux PWM List <linux-pwm@vger.kernel.org>,
	linux-omap <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 4/7] [media] ir-rx51: add DT support to driver
Message-ID: <20160510021826.GE1129@earth>
References: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1462634508-24961-5-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160509200657.GA3379@rob-hp-laptop>
 <5730F8BA.5000402@gmail.com>
 <CAL_JsqJPZS1ne_xAuBFtCc5L1HKFJf0LDUJ7CRSFXhc3adkTfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZInfyf7laFu/Kiw7"
Content-Disposition: inline
In-Reply-To: <CAL_JsqJPZS1ne_xAuBFtCc5L1HKFJf0LDUJ7CRSFXhc3adkTfA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ZInfyf7laFu/Kiw7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Mon, May 09, 2016 at 04:07:35PM -0500, Rob Herring wrote:
> There's already a pwm-led binding that can be used. Though there
> may be missing consumer IR to LED subsystem support in the kernel.
> You could list both compatibles, use the rx51 IR driver now, and
> then move to pwm-led driver in the future.

Well from a purely HW point of view it's a PWM connected led. The
usage is completely different though. Usually PWM is used to control
the LED's brightness via the duty cycle (basic concept: enabling led
only 50% of time reduces brightness to 50%).

In the IR led's case the aim is generating a specific serial pattern
instead. For this task it uses a dmtimer in PWM mode and a second
one to reconfigure the pwm timer.

I don't know about a good name, but rx51 should be replaced with
n900 in the compatible string. So maybe "nokia,n900-infrared-diode".

-- Sebastian

--ZInfyf7laFu/Kiw7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXMUTwAAoJENju1/PIO/qa77EQAKot0fwGiJ6h6yBcLzxrGfkB
v7Iscq+mL9pFfOx09N7HouBsT55nSp2rwhn8Zf+pqWU1gCo+G6P/HbPt63az8ec0
lVbW7dHySUGPLN0tsTizHGljyUKtI4x4+R3hfhKe+rUhNjx7fGjNF7OsU2XxmDwl
0keHNIHs0q+KHjrwcUnRsTIGt6AsbwjNfRfmpCVxWPoqT0iwO7NOmUE1P2NSG0dW
dwGhomBvfapfc+YVnivm4W0hKP2OGJfaykExkbfU8NVJXM2rsh50OskIETp4XNqi
+PbCrCGRcC4+FOaY4lZ+THjuT5fdGn5a/6UJhpqpWsFOi9BUG6DiSjQdL/4+IpE7
Zn/PCIe/dJdteudbOBx7Rcru9gWTQSgvK1PytxgtLTYEqcisvhSG3+aJpjsMqDOE
8rZ9sWvZI9zYqtVJeBp1xebqMZ0bRhBjUM+zGT7s7h0DphWANjOrsJoGFktph5UY
QiKIyLXbZ6GoRUMM62TA76r3Kb79S+wJ5g9GMz7uOkKge7DV2VHtaWkLroq6qzNE
/xyFs0ZkC3xuSFaaHeyu6SPQgVi0XUbFBTRI+DweBUPs0ONJj35JuF89rwWW8Uc7
UeYBrlkk9OwbBzeefBKmQlBmp+J5R3c/kIEepDLTLoKV31GFN4PMAFZS0BrXEQcj
v0d7Qc/MIskTuTWJsbFE
=6DvW
-----END PGP SIGNATURE-----

--ZInfyf7laFu/Kiw7--
