Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:54215 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753038AbdFMNrL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 09:47:11 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] ARM: dts: exynos: add needs-hpd to &hdmicec for Odroid-U3
Message-ID: <a357d30b-9f83-ec65-c8a1-a9e81236f9ee@xs4all.nl>
Date: Tue, 13 Jun 2017 15:47:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Odroid-U3 board has an IP4791CZ12 level shifter that is
disabled if the HPD is low, which means that the CEC pin is
disabled as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes since v1: moved &hdmicec to after &buck to keep it somewhat
alphabetical.
---
 arch/arm/boot/dts/exynos4412-odroidu3.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
index 7504a5aa538e..44a4de08466b 100644
--- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
@@ -78,6 +78,10 @@
 	regulator-max-microvolt = <3300000>;
 };

+&hdmicec {
+	needs-hpd;
+};
+
 /* VDDQ for MSHC (eMMC card) */
 &ldo22_reg {
 	regulator-name = "LDO22_VDDQ_MMC4_2.8V";
-- 
2.11.0
