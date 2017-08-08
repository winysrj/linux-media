Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40282 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752435AbdHHNbC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 09:31:02 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 21/21] doc: media/v4l-drivers: Qualcomm Camera Subsystem - Media graph
Date: Tue,  8 Aug 2017 16:30:18 +0300
Message-Id: <1502199018-28250-22-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the Qualcomm Camera Subsystem driver document with a media
controller pipeline graph diagram.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 Documentation/media/v4l-drivers/qcom_camss.rst     | 27 ++++++--------
 .../media/v4l-drivers/qcom_camss_graph.dot         | 41 ++++++++++++++++++++++
 2 files changed, 51 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/media/v4l-drivers/qcom_camss_graph.dot

diff --git a/Documentation/media/v4l-drivers/qcom_camss.rst b/Documentation/media/v4l-drivers/qcom_camss.rst
index e6e948f..7ef632a 100644
--- a/Documentation/media/v4l-drivers/qcom_camss.rst
+++ b/Documentation/media/v4l-drivers/qcom_camss.rst
@@ -114,23 +114,16 @@ The considerations to split the driver in this particular way are as follows:
 
 Each VFE sub-device is linked to a separate video device node.
 
-The complete list of the media entities (V4L2 sub-devices and video device
-nodes) is as follows:
-
-- msm_csiphy0
-- msm_csiphy1
-- msm_csid0
-- msm_csid1
-- msm_ispif0
-- msm_ispif1
-- msm_vfe0_rdi0
-- msm_vfe0_video0
-- msm_vfe0_rdi1
-- msm_vfe0_video1
-- msm_vfe0_rdi2
-- msm_vfe0_video2
-- msm_vfe0_pix
-- msm_vfe0_video3
+The media controller pipeline graph is as follows (with connected two OV5645
+camera sensors):
+
+.. _qcom_camss_graph:
+
+.. kernel-figure:: qcom_camss_graph.dot
+    :alt:   qcom_camss_graph.dot
+    :align: center
+
+    Media pipeline graph
 
 
 Implementation
diff --git a/Documentation/media/v4l-drivers/qcom_camss_graph.dot b/Documentation/media/v4l-drivers/qcom_camss_graph.dot
new file mode 100644
index 0000000..827fc71
--- /dev/null
+++ b/Documentation/media/v4l-drivers/qcom_camss_graph.dot
@@ -0,0 +1,41 @@
+digraph board {
+	rankdir=TB
+	n00000001 [label="{{<port0> 0} | msm_csiphy0\n/dev/v4l-subdev0 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000001:port1 -> n00000007:port0 [style=dashed]
+	n00000001:port1 -> n0000000a:port0 [style=dashed]
+	n00000004 [label="{{<port0> 0} | msm_csiphy1\n/dev/v4l-subdev1 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000004:port1 -> n00000007:port0 [style=dashed]
+	n00000004:port1 -> n0000000a:port0 [style=dashed]
+	n00000007 [label="{{<port0> 0} | msm_csid0\n/dev/v4l-subdev2 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000007:port1 -> n0000000d:port0 [style=dashed]
+	n00000007:port1 -> n00000010:port0 [style=dashed]
+	n0000000a [label="{{<port0> 0} | msm_csid1\n/dev/v4l-subdev3 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n0000000a:port1 -> n0000000d:port0 [style=dashed]
+	n0000000a:port1 -> n00000010:port0 [style=dashed]
+	n0000000d [label="{{<port0> 0} | msm_ispif0\n/dev/v4l-subdev4 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n0000000d:port1 -> n00000013:port0 [style=dashed]
+	n0000000d:port1 -> n0000001c:port0 [style=dashed]
+	n0000000d:port1 -> n00000025:port0 [style=dashed]
+	n0000000d:port1 -> n0000002e:port0 [style=dashed]
+	n00000010 [label="{{<port0> 0} | msm_ispif1\n/dev/v4l-subdev5 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000010:port1 -> n00000013:port0 [style=dashed]
+	n00000010:port1 -> n0000001c:port0 [style=dashed]
+	n00000010:port1 -> n00000025:port0 [style=dashed]
+	n00000010:port1 -> n0000002e:port0 [style=dashed]
+	n00000013 [label="{{<port0> 0} | msm_vfe0_rdi0\n/dev/v4l-subdev6 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000013:port1 -> n00000016 [style=bold]
+	n00000016 [label="msm_vfe0_video0\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
+	n0000001c [label="{{<port0> 0} | msm_vfe0_rdi1\n/dev/v4l-subdev7 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n0000001c:port1 -> n0000001f [style=bold]
+	n0000001f [label="msm_vfe0_video1\n/dev/video1", shape=box, style=filled, fillcolor=yellow]
+	n00000025 [label="{{<port0> 0} | msm_vfe0_rdi2\n/dev/v4l-subdev8 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000025:port1 -> n00000028 [style=bold]
+	n00000028 [label="msm_vfe0_video2\n/dev/video2", shape=box, style=filled, fillcolor=yellow]
+	n0000002e [label="{{<port0> 0} | msm_vfe0_pix\n/dev/v4l-subdev9 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
+	n0000002e:port1 -> n00000031 [style=bold]
+	n00000031 [label="msm_vfe0_video3\n/dev/video3", shape=box, style=filled, fillcolor=yellow]
+	n00000057 [label="{{} | ov5645 1-0076\n/dev/v4l-subdev10 | {<port0> 0}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000057:port0 -> n00000001:port0 [style=bold]
+	n00000059 [label="{{} | ov5645 1-0074\n/dev/v4l-subdev11 | {<port0> 0}}", shape=Mrecord, style=filled, fillcolor=green]
+	n00000059:port0 -> n00000004:port0 [style=bold]
+}
-- 
2.7.4
