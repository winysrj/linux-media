Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51630 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755350AbeCSLnx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 07:43:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] dt-bindings: display: dw_hdmi.txt
Date: Mon, 19 Mar 2018 12:43:43 +0100
Message-Id: <20180319114345.29837-2-hverkuil@xs4all.nl>
In-Reply-To: <20180319114345.29837-1-hverkuil@xs4all.nl>
References: <20180319114345.29837-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some boards have both a DesignWare and their own CEC controller.
The CEC pin is only hooked up to their own CEC controller and not
to the DW controller.

Add the cec-disable property to disable the DW CEC controller.

This particular situation happens on Amlogic boards that have their
own meson CEC controller.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt b/Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt
index 33bf981fbe33..4a13f4858bc0 100644
--- a/Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt
+++ b/Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt
@@ -27,6 +27,9 @@ responsible for defining whether each property is required or optional.
   - "isfr" is the internal register configuration clock (mandatory).
   - "cec" is the HDMI CEC controller main clock (optional).
 
+- cec-disable: Do not use the DWC CEC controller since the CEC line is not
+  hooked up even though the CEC DWC IP is present.
+
 - ports: The connectivity of the DWC HDMI TX with the rest of the system is
   expressed in using ports as specified in the device graph bindings defined
   in Documentation/devicetree/bindings/graph.txt. The numbering of the ports
-- 
2.15.1
