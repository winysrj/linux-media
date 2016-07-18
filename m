Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45897 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbcGRB4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 24/36] [media] doc-rst: add pxa_camera documentation
Date: Sun, 17 Jul 2016 22:56:07 -0300
Message-Id: <f0bb8dd9ba59493fde3fa28b831ad3afd7f33c17.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert pxa_camera to ReST format and add it to the
media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst      |   1 +
 Documentation/media/v4l-drivers/pxa_camera.rst | 212 ++++++++++++++-----------
 2 files changed, 116 insertions(+), 97 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index e88ce12074ae..eb0ed669545e 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -31,4 +31,5 @@ License".
 	omap3isp
 	omap4_camera
 	pvrusb2
+	pxa_camera
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/pxa_camera.rst b/Documentation/media/v4l-drivers/pxa_camera.rst
index 51ed1578b0e8..554f91b04e70 100644
--- a/Documentation/media/v4l-drivers/pxa_camera.rst
+++ b/Documentation/media/v4l-drivers/pxa_camera.rst
@@ -1,84 +1,91 @@
-                              PXA-Camera Host Driver
-                              ======================
+PXA-Camera Host Driver
+======================
+
+Author: Robert Jarzmik <robert.jarzmik@free.fr>
 
 Constraints
 -----------
-  a) Image size for YUV422P format
-     All YUV422P images are enforced to have width x height % 16 = 0.
-     This is due to DMA constraints, which transfers only planes of 8 byte
-     multiples.
+
+a) Image size for YUV422P format
+   All YUV422P images are enforced to have width x height % 16 = 0.
+   This is due to DMA constraints, which transfers only planes of 8 byte
+   multiples.
 
 
 Global video workflow
 ---------------------
-  a) QCI stopped
-     Initialy, the QCI interface is stopped.
-     When a buffer is queued (pxa_videobuf_ops->buf_queue), the QCI starts.
 
-  b) QCI started
-     More buffers can be queued while the QCI is started without halting the
-     capture.  The new buffers are "appended" at the tail of the DMA chain, and
-     smoothly captured one frame after the other.
+a) QCI stopped
+   Initialy, the QCI interface is stopped.
+   When a buffer is queued (pxa_videobuf_ops->buf_queue), the QCI starts.
 
-     Once a buffer is filled in the QCI interface, it is marked as "DONE" and
-     removed from the active buffers list. It can be then requeud or dequeued by
-     userland application.
+b) QCI started
+   More buffers can be queued while the QCI is started without halting the
+   capture.  The new buffers are "appended" at the tail of the DMA chain, and
+   smoothly captured one frame after the other.
 
-     Once the last buffer is filled in, the QCI interface stops.
+   Once a buffer is filled in the QCI interface, it is marked as "DONE" and
+   removed from the active buffers list. It can be then requeud or dequeued by
+   userland application.
 
-  c) Capture global finite state machine schema
+   Once the last buffer is filled in, the QCI interface stops.
 
-      +----+                             +---+  +----+
-      | DQ |                             | Q |  | DQ |
-      |    v                             |   v  |    v
-    +-----------+                     +------------------------+
-    |   STOP    |                     | Wait for capture start |
-    +-----------+         Q           +------------------------+
-+-> | QCI: stop | ------------------> | QCI: run               | <------------+
-|   | DMA: stop |                     | DMA: stop              |              |
-|   +-----------+             +-----> +------------------------+              |
-|                            /                            |                   |
-|                           /             +---+  +----+   |                   |
-|capture list empty        /              | Q |  | DQ |   | QCI Irq EOF       |
-|                         /               |   v  |    v   v                   |
-|   +--------------------+             +----------------------+               |
-|   | DMA hotlink missed |             |    Capture running   |               |
-|   +--------------------+             +----------------------+               |
-|   | QCI: run           |     +-----> | QCI: run             | <-+           |
-|   | DMA: stop          |    /        | DMA: run             |   |           |
-|   +--------------------+   /         +----------------------+   | Other     |
-|     ^                     /DMA still            |               | channels  |
-|     | capture list       /  running             | DMA Irq End   | not       |
-|     | not empty         /                       |               | finished  |
-|     |                  /                        v               | yet       |
-|   +----------------------+           +----------------------+   |           |
-|   |  Videobuf released   |           |  Channel completed   |   |           |
-|   +----------------------+           +----------------------+   |           |
-+-- | QCI: run             |           | QCI: run             | --+           |
-    | DMA: run             |           | DMA: run             |               |
-    +----------------------+           +----------------------+               |
-               ^                      /           |                           |
-               |          no overrun /            | overrun                   |
-               |                    /             v                           |
-    +--------------------+         /   +----------------------+               |
-    |  Frame completed   |        /    |     Frame overran    |               |
-    +--------------------+ <-----+     +----------------------+ restart frame |
-    | QCI: run           |             | QCI: stop            | --------------+
-    | DMA: run           |             | DMA: stop            |
-    +--------------------+             +----------------------+
+c) Capture global finite state machine schema
 
-    Legend: - each box is a FSM state
-            - each arrow is the condition to transition to another state
-            - an arrow with a comment is a mandatory transition (no condition)
-            - arrow "Q" means : a buffer was enqueued
-            - arrow "DQ" means : a buffer was dequeued
-            - "QCI: stop" means the QCI interface is not enabled
-            - "DMA: stop" means all 3 DMA channels are stopped
-            - "DMA: run" means at least 1 DMA channel is still running
+.. code-block:: none
+
+	+----+                             +---+  +----+
+	| DQ |                             | Q |  | DQ |
+	|    v                             |   v  |    v
+	+-----------+                     +------------------------+
+	|   STOP    |                     | Wait for capture start |
+	+-----------+         Q           +------------------------+
+	+-> | QCI: stop | ------------------> | QCI: run               | <------------+
+	|   | DMA: stop |                     | DMA: stop              |              |
+	|   +-----------+             +-----> +------------------------+              |
+	|                            /                            |                   |
+	|                           /             +---+  +----+   |                   |
+	|capture list empty        /              | Q |  | DQ |   | QCI Irq EOF       |
+	|                         /               |   v  |    v   v                   |
+	|   +--------------------+             +----------------------+               |
+	|   | DMA hotlink missed |             |    Capture running   |               |
+	|   +--------------------+             +----------------------+               |
+	|   | QCI: run           |     +-----> | QCI: run             | <-+           |
+	|   | DMA: stop          |    /        | DMA: run             |   |           |
+	|   +--------------------+   /         +----------------------+   | Other     |
+	|     ^                     /DMA still            |               | channels  |
+	|     | capture list       /  running             | DMA Irq End   | not       |
+	|     | not empty         /                       |               | finished  |
+	|     |                  /                        v               | yet       |
+	|   +----------------------+           +----------------------+   |           |
+	|   |  Videobuf released   |           |  Channel completed   |   |           |
+	|   +----------------------+           +----------------------+   |           |
+	+-- | QCI: run             |           | QCI: run             | --+           |
+	| DMA: run             |           | DMA: run             |               |
+	+----------------------+           +----------------------+               |
+		^                      /           |                           |
+		|          no overrun /            | overrun                   |
+		|                    /             v                           |
+	+--------------------+         /   +----------------------+               |
+	|  Frame completed   |        /    |     Frame overran    |               |
+	+--------------------+ <-----+     +----------------------+ restart frame |
+	| QCI: run           |             | QCI: stop            | --------------+
+	| DMA: run           |             | DMA: stop            |
+	+--------------------+             +----------------------+
+
+	Legend: - each box is a FSM state
+		- each arrow is the condition to transition to another state
+		- an arrow with a comment is a mandatory transition (no condition)
+		- arrow "Q" means : a buffer was enqueued
+		- arrow "DQ" means : a buffer was dequeued
+		- "QCI: stop" means the QCI interface is not enabled
+		- "DMA: stop" means all 3 DMA channels are stopped
+		- "DMA: run" means at least 1 DMA channel is still running
 
 DMA usage
 ---------
-  a) DMA flow
+
+a) DMA flow
      - first buffer queued for capture
        Once a first buffer is queued for capture, the QCI is started, but data
        transfer is not started. On "End Of Frame" interrupt, the irq handler
@@ -93,22 +100,27 @@ DMA usage
      - finishing the last videobuffer
        On the DMA irq of the last videobuffer, the QCI is stopped.
 
-  b) DMA prepared buffer will have this structure
+b) DMA prepared buffer will have this structure
+
+.. code-block:: none
 
      +------------+-----+---------------+-----------------+
      | desc-sg[0] | ... | desc-sg[last] | finisher/linker |
      +------------+-----+---------------+-----------------+
 
-     This structure is pointed by dma->sg_cpu.
-     The descriptors are used as follows :
-      - desc-sg[i]: i-th descriptor, transferring the i-th sg
-        element to the video buffer scatter gather
-      - finisher: has ddadr=DADDR_STOP, dcmd=ENDIRQEN
-      - linker: has ddadr= desc-sg[0] of next video buffer, dcmd=0
+This structure is pointed by dma->sg_cpu.
+The descriptors are used as follows:
 
-     For the next schema, let's assume d0=desc-sg[0] .. dN=desc-sg[N],
-     "f" stands for finisher and "l" for linker.
-     A typical running chain is :
+- desc-sg[i]: i-th descriptor, transferring the i-th sg
+  element to the video buffer scatter gather
+- finisher: has ddadr=DADDR_STOP, dcmd=ENDIRQEN
+- linker: has ddadr= desc-sg[0] of next video buffer, dcmd=0
+
+For the next schema, let's assume d0=desc-sg[0] .. dN=desc-sg[N],
+"f" stands for finisher and "l" for linker.
+A typical running chain is :
+
+.. code-block:: none
 
          Videobuffer 1         Videobuffer 2
      +---------+----+---+  +----+----+----+---+
@@ -117,7 +129,9 @@ DMA usage
                       |    |
                       +----+
 
-     After the chaining is finished, the chain looks like :
+After the chaining is finished, the chain looks like :
+
+.. code-block:: none
 
          Videobuffer 1         Videobuffer 2         Videobuffer 3
      +---------+----+---+  +----+----+----+---+  +----+----+----+---+
@@ -127,15 +141,18 @@ DMA usage
                       +----+                +----+
                                            new_link
 
-  c) DMA hot chaining timeslice issue
+c) DMA hot chaining timeslice issue
 
-     As DMA chaining is done while DMA _is_ running, the linking may be done
-     while the DMA jumps from one Videobuffer to another. On the schema, that
-     would be a problem if the following sequence is encountered :
+As DMA chaining is done while DMA _is_ running, the linking may be done
+while the DMA jumps from one Videobuffer to another. On the schema, that
+would be a problem if the following sequence is encountered :
+
+- DMA chain is Videobuffer1 + Videobuffer2
+- pxa_videobuf_queue() is called to queue Videobuffer3
+- DMA controller finishes Videobuffer2, and DMA stops
+
+.. code-block:: none
 
-      - DMA chain is Videobuffer1 + Videobuffer2
-      - pxa_videobuf_queue() is called to queue Videobuffer3
-      - DMA controller finishes Videobuffer2, and DMA stops
       =>
          Videobuffer 1         Videobuffer 2
      +---------+----+---+  +----+----+----+---+
@@ -144,11 +161,13 @@ DMA usage
                       |    |                |
                       +----+                +-- DMA DDADR loads DDADR_STOP
 
-      - pxa_dma_add_tail_buf() is called, the Videobuffer2 "finisher" is
-        replaced by a "linker" to Videobuffer3 (creation of new_link)
-      - pxa_videobuf_queue() finishes
-      - the DMA irq handler is called, which terminates Videobuffer2
-      - Videobuffer3 capture is not scheduled on DMA chain (as it stopped !!!)
+- pxa_dma_add_tail_buf() is called, the Videobuffer2 "finisher" is
+  replaced by a "linker" to Videobuffer3 (creation of new_link)
+- pxa_videobuf_queue() finishes
+- the DMA irq handler is called, which terminates Videobuffer2
+- Videobuffer3 capture is not scheduled on DMA chain (as it stopped !!!)
+
+.. code-block:: none
 
          Videobuffer 1         Videobuffer 2         Videobuffer 3
      +---------+----+---+  +----+----+----+---+  +----+----+----+---+
@@ -159,16 +178,15 @@ DMA usage
                                            new_link
                                           DMA DDADR still is DDADR_STOP
 
-      - pxa_camera_check_link_miss() is called
-        This checks if the DMA is finished and a buffer is still on the
-        pcdev->capture list. If that's the case, the capture will be restarted,
-        and Videobuffer3 is scheduled on DMA chain.
-      - the DMA irq handler finishes
+- pxa_camera_check_link_miss() is called
+  This checks if the DMA is finished and a buffer is still on the
+  pcdev->capture list. If that's the case, the capture will be restarted,
+  and Videobuffer3 is scheduled on DMA chain.
+- the DMA irq handler finishes
 
-     Note: if DMA stops just after pxa_camera_check_link_miss() reads DDADR()
+.. note::
+
+     If DMA stops just after pxa_camera_check_link_miss() reads DDADR()
      value, we have the guarantee that the DMA irq handler will be called back
      when the DMA will finish the buffer, and pxa_camera_check_link_miss() will
      be called again, to reschedule Videobuffer3.
-
---
-Author: Robert Jarzmik <robert.jarzmik@free.fr>
-- 
2.7.4

