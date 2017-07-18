Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:36517 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751371AbdGRKYS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 06:24:18 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH v3 2/4] i2c: add docs to clarify DMA handling
Date: Tue, 18 Jul 2017 12:23:37 +0200
Message-Id: <20170718102339.28726-3-wsa+renesas@sang-engineering.com>
In-Reply-To: <20170718102339.28726-1-wsa+renesas@sang-engineering.com>
References: <20170718102339.28726-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
Changes since v2:

* documentation updates. Hopefully better wording now

 Documentation/i2c/DMA-considerations | 38 ++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/i2c/DMA-considerations

diff --git a/Documentation/i2c/DMA-considerations b/Documentation/i2c/DMA-considerations
new file mode 100644
index 00000000000000..e46c24d65c8556
--- /dev/null
+++ b/Documentation/i2c/DMA-considerations
@@ -0,0 +1,38 @@
+Linux I2C and DMA
+-----------------
+
+Given that I2C is a low-speed bus where largely small messages are transferred,
+it is not considered a prime user of DMA access. At this time of writing, only
+10% of I2C bus master drivers have DMA support implemented. And the vast
+majority of transactions are so small that setting up DMA for it will likely
+add more overhead than a plain PIO transfer.
+
+Therefore, it is *not* mandatory that the buffer of an I2C message is DMA safe.
+It does not seem reasonable to apply additional burdens when the feature is so
+rarely used. However, it is recommended to use a DMA-safe buffer if your
+message size is likely applicable for DMA. Most drivers have this threshold
+around 8 bytes. As of today, this is mostly an educated guess, however.
+
+To support this scenario, drivers wishing to implement DMA can use helper
+functions from the I2C core. One checks if a message is DMA capable in terms of
+size and memory type. It can optionally also create a bounce buffer:
+
+	i2c_check_msg_for_dma(msg, threshold, &bounce_buf);
+
+The bounce buffer handling from the core is generic and simple. It will always
+allocate a new bounce buffer. If you want a more sophisticated handling (e.g.
+reusing pre-allocated buffers), you can leave the pointer to the bounce buffer
+empty and implement your own handling based on the return value of the above
+function.
+
+The other helper function releases the bounce buffer. It ensures data is copied
+back to the message:
+
+	i2c_release_dma_bounce_buf(msg, bounce_buf);
+
+Please check the in-kernel documentation for details. The i2c-sh_mobile driver
+can be used as a reference example.
+
+If you plan to use DMA with I2C (or with any other bus, actually) make sure you
+have CONFIG_DMA_API_DEBUG enabled during development. It can help you find
+various issues which can be complex to debug otherwise.
-- 
2.11.0
