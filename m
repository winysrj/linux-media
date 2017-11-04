Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:44821 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752172AbdKDUU1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Nov 2017 16:20:27 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v6 7/9] i2c: add docs to clarify DMA handling
Date: Sat,  4 Nov 2017 21:20:07 +0100
Message-Id: <20171104202009.3818-8-wsa+renesas@sang-engineering.com>
In-Reply-To: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 Documentation/i2c/DMA-considerations | 67 ++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 Documentation/i2c/DMA-considerations

diff --git a/Documentation/i2c/DMA-considerations b/Documentation/i2c/DMA-considerations
new file mode 100644
index 00000000000000..966610aa4620fa
--- /dev/null
+++ b/Documentation/i2c/DMA-considerations
@@ -0,0 +1,67 @@
+=================
+Linux I2C and DMA
+=================
+
+Given that i2c is a low-speed bus, over which the majority of messages
+transferred are small, it is not considered a prime user of DMA access. At this
+time of writing, only 10% of I2C bus master drivers have DMA support
+implemented. And the vast majority of transactions are so small that setting up
+DMA for it will likely add more overhead than a plain PIO transfer.
+
+Therefore, it is *not* mandatory that the buffer of an I2C message is DMA safe.
+It does not seem reasonable to apply additional burdens when the feature is so
+rarely used. However, it is recommended to use a DMA-safe buffer if your
+message size is likely applicable for DMA. Most drivers have this threshold
+around 8 bytes (as of today, this is mostly an educated guess, however). For
+any message of 16 byte or larger, it is probably a really good idea. Please
+note that other subsystems you use might add requirements. E.g., if your
+I2C bus master driver is using USB as a bridge, then you need to have DMA
+safe buffers always, because USB requires it.
+
+Clients
+-------
+
+For clients, if you use a DMA safe buffer in i2c_msg, set the I2C_M_DMA_SAFE
+flag with it. Then, the I2C core and drivers know they can safely operate DMA
+on it. Note that using this flag is optional. I2C host drivers which are not
+updated to use this flag will work like before. And like before, they risk
+using an unsafe DMA buffer. To improve this situation, using I2C_M_DMA_SAFE in
+more and more clients and host drivers is the planned way forward. Note also
+that setting this flag makes only sense in kernel space. User space data is
+copied into kernel space anyhow. The I2C core makes sure the destination
+buffers in kernel space are always DMA capable. Also, when the core emulates
+SMBus transactions via I2C, the buffers for block transfers are DMA safe. Users
+of i2c_master_send() and i2c_master_recv() functions can now use DMA safe
+variants (i2c_master_send_dmasafe() and i2c_master_recv_dmasafe()) once they
+know their buffers are DMA safe. Users of i2c_transfer() must set the
+I2C_M_DMA_SAFE flag manually.
+
+Masters
+-------
+
+Bus master drivers wishing to implement safe DMA can use helper functions from
+the I2C core. One gives you a DMA-safe buffer for a given i2c_msg as long as a
+certain threshold is met::
+
+	dma_buf = i2c_get_dma_safe_msg_buf(msg, threshold_in_byte);
+
+If a buffer is returned, it is either msg->buf for the I2C_M_DMA_SAFE case or a
+bounce buffer. But you don't need to care about that detail, just use the
+returned buffer. If NULL is returned, the threshold was not met or a bounce
+buffer could not be allocated. Fall back to PIO in that case.
+
+In any case, a buffer obtained from above needs to be released. It ensures data
+is copied back to the message and a potentially used bounce buffer is freed::
+
+	i2c_release_dma_safe_msg_buf(msg, dma_buf);
+
+The bounce buffer handling from the core is generic and simple. It will always
+allocate a new bounce buffer. If you want a more sophisticated handling (e.g.
+reusing pre-allocated buffers), you are free to implement your own.
+
+Please also check the in-kernel documentation for details. The i2c-sh_mobile
+driver can be used as a reference example how to use the above helpers.
+
+Final note: If you plan to use DMA with I2C (or with anything else, actually)
+make sure you have CONFIG_DMA_API_DEBUG enabled during development. It can help
+you find various issues which can be complex to debug otherwise.
-- 
2.11.0
