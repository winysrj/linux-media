Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52228 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbcFBTab (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2016 15:30:31 -0400
Date: Thu, 2 Jun 2016 21:30:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org
Subject: [PATCH] device tree description for AD5820 camera auto-focus coil
Message-ID: <20160602193027.GB7984@amd>
References: <574049EF.2090208@gmail.com>
 <20160524090433.GA1277@amd>
 <20160524091746.GA14536@amd>
 <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
 <20160527205140.GA26767@amd>
 <20160531212222.GP26360@valkosipuli.retiisi.org.uk>
 <20160531213437.GA28397@amd>
 <20160601152439.GQ26360@valkosipuli.retiisi.org.uk>
 <20160601220840.GA21946@amd>
 <20160602074544.GR26360@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160602074544.GR26360@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Add documentation for ad5820 device tree binding.

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/Documentation/devicetree/bindings/media/i2c/ad5820.txt b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
new file mode 100644
index 0000000..fb70ca5
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
@@ -0,0 +1,19 @@
+* Analog Devices AD5820 autofocus coil
+
+Required Properties:
+
+  - compatible: Must contain "adi,ad5820"
+
+  - reg: I2C slave address
+
+  - VANA-supply: supply of voltage for VANA pin
+
+Example:
+
+       ad5820: coil@0c {
+               compatible = "adi,ad5820";
+               reg = <0x0c>;
+
+               VANA-supply = <&vaux4>;
+       };
+

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
