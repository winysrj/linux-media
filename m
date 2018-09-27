Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:16209 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727307AbeI0VFC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 17:05:02 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
CC: <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH 2/4] media: v4l2-core: add pixel clock max frequency parallel port property
Date: Thu, 27 Sep 2018 16:46:05 +0200
Message-ID: <1538059567-8381-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1538059567-8381-1-git-send-email-hugues.fruchet@st.com>
References: <1538059567-8381-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add pclk-max-frequency property in parallel port endpoint in order
to inform sensor of the maximum pixel clock frequency admissible
by camera interface that is connected on.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 3 +++
 include/media/v4l2-fwnode.h           | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 169bdbb..505338e 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -158,6 +158,9 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 		flags |= v ? V4L2_MBUS_DATA_ENABLE_HIGH :
 			V4L2_MBUS_DATA_ENABLE_LOW;
 
+	if (!fwnode_property_read_u32(fwnode, "pclk-max-frequency", &v))
+		bus->pclk_max_frequency = v;
+
 	bus->flags = flags;
 
 }
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 9cccab6..946b48d 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -52,11 +52,13 @@ struct v4l2_fwnode_bus_mipi_csi2 {
  * @flags: media bus (V4L2_MBUS_*) flags
  * @bus_width: bus width in bits
  * @data_shift: data shift in bits
+ * @max_pclk_frequency: maximum pixel clock in hertz
  */
 struct v4l2_fwnode_bus_parallel {
 	unsigned int flags;
 	unsigned char bus_width;
 	unsigned char data_shift;
+	unsigned int pclk_max_frequency;
 };
 
 /**
-- 
2.7.4
