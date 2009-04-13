Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:36315 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZDMQ7L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 12:59:11 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH] pxa_camera: Documentation of the FSM
Date: Mon, 13 Apr 2009 18:59:00 +0200
Message-Id: <1239641940-27918-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After DMA redesign, the pxa_camera dynamic behaviour should
be documented so that future contributors understand how it
works, and improve it.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 Documentation/video4linux/pxa_camera.txt |   49 ++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/pxa_camera.txt b/Documentation/video4linux/pxa_camera.txt
index b1137f9..b595e94 100644
--- a/Documentation/video4linux/pxa_camera.txt
+++ b/Documentation/video4linux/pxa_camera.txt
@@ -26,6 +26,55 @@ Global video workflow
 
      Once the last buffer is filled in, the QCI interface stops.
 
+  c) Capture global finite state machine schema
+
+      +----+                             +---+  +----+
+      | DQ |                             | Q |  | DQ |
+      |    v                             |   v  |    v
+    +-----------+                     +------------------------+
+    |   STOP    |                     | Wait for capture start |
+    +-----------+         Q           +------------------------+
++-> | QCI: stop | ------------------> | QCI: run               | <------------+
+|   | DMA: stop |                     | DMA: stop              |              |
+|   +-----------+             +-----> +------------------------+              |
+|                            /                            |                   |
+|                           /             +---+  +----+   |                   |
+|capture list empty        /              | Q |  | DQ |   | QCI Irq EOF       |
+|                         /               |   v  |    v   v                   |
+|   +--------------------+             +----------------------+               |
+|   | DMA hotlink missed |             |    Capture running   |               |
+|   +--------------------+             +----------------------+               |
+|   | QCI: run           |     +-----> | QCI: run             | <-+           |
+|   | DMA: stop          |    /        | DMA: run             |   |           |
+|   +--------------------+   /         +----------------------+   | Other     |
+|     ^                     /DMA still            |               | channels  |
+|     | capture list       /  running             | DMA Irq End   | not       |
+|     | not empty         /                       |               | finished  |
+|     |                  /                        v               | yet       |
+|   +----------------------+           +----------------------+   |           |
+|   |  Videobuf released   |           |  Channel completed   |   |           |
+|   +----------------------+           +----------------------+   |           |
+|   | QCI: run             |           | QCI: run             | --+           |
+|   | DMA: run             |           | DMA: run             |               |
+|   +----------------------+           +----------------------+               |
+|              ^                      /           |                           |
+|              |          no overrun /            | overrun                   |
+|              |                    /             v                           |
+|   +--------------------+         /   +----------------------+               |
+|   |  Frame completed   |        /    |     Frame overran    |               |
+|   +--------------------+ <-----+     +----------------------+ restart frame |
++-- | QCI: run           |             | QCI: stop            | --------------+
+    | DMA: run           |             | DMA: stop            |
+    +--------------------+             +----------------------+
+
+    Legend: - each box is a FSM state
+            - each arrow is the condition to transition to another state
+            - an arrow with a comment is a mandatory transition (no condition)
+            - arrow "Q" means : a buffer was enqueued
+            - arrow "DQ" means : a buffer was dequeued
+            - "QCI: stop" means the QCI interface is not enabled
+            - "DMA: stop" means all 3 DMA channels are stopped
+            - "DMA: run" means at least 1 DMA channel is still running
 
 DMA usage
 ---------
-- 
1.6.2.1

