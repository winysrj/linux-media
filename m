Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33754 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbbDCRMc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 13:12:32 -0400
In-Reply-To: <20150403171149.GC13898@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: [PATCH 01/14] clk: update clk API documentation to clarify
 clk_round_rate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Ye58t-0001At-NZ@rmk-PC.arm.linux.org.uk>
Date: Fri, 03 Apr 2015 18:12:27 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The idea is that rate = clk_round_rate(clk, r) is equivalent to:

	clk_set_rate(clk, r);
	rate = clk_get_rate(clk);

except that clk_round_rate() does not change the hardware in any way.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 include/linux/clk.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index 8381bbfbc308..d1ac9f3ab24b 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -288,6 +288,20 @@ void devm_clk_put(struct device *dev, struct clk *clk);
  * @clk: clock source
  * @rate: desired clock rate in Hz
  *
+ * This answers the question "if I were to pass @rate to clk_set_rate(),
+ * what clock rate would I end up with?" without changing the hardware
+ * in any way.  In other words:
+ *
+ *   rate = clk_round_rate(clk, r);
+ *
+ * and:
+ *
+ *   clk_set_rate(clk, r);
+ *   rate = clk_get_rate(clk);
+ *
+ * are equivalent except the former does not modify the clock hardware
+ * in any way.
+ *
  * Returns rounded clock rate in Hz, or negative errno.
  */
 long clk_round_rate(struct clk *clk, unsigned long rate);
-- 
1.8.3.1

