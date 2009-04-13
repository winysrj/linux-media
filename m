Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:47643 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbZDMUgZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 16:36:25 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa_camera: Documentation of the FSM
References: <1239641940-27918-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0904132208050.1587@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 13 Apr 2009 22:36:12 +0200
In-Reply-To: <Pine.LNX.4.64.0904132208050.1587@axis700.grange> (Guennadi Liakhovetski's message of "Mon\, 13 Apr 2009 22\:16\:46 +0200 \(CEST\)")
Message-ID: <87tz4s9tqb.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>
> Cool, nice:-) One question though: shouldn't the "capture list empty" 
> transition start from "Videobuf released" state?
Absolutely. Nice catch. I just cross-checked my hand-made schema, and you're
right.

> Or maybe you want to reorginise the "Videobuf released" and "Frame completed"
> states a bit to separate cases
> - capture list empty
> - capture list not empty
>   - DMA still running - hot-linking success
>   - DMA stopped - restart
Well, granted that the transition "capture list empty" was badly put, this is
not needed anymore, is it ?

Cheers.

--
Robert

>From 8f33b15891c8fe8ee317a8d0d7293d05fda3c6e6 Mon Sep 17 00:00:00 2001
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 13 Apr 2009 18:52:56 +0200
Subject: [PATCH] pxa_camera: Documentation of the FSM

After DMA redesign, the pxa_camera dynamic behaviour should
be documented so that future contributors understand how it
works, and improve it.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 Documentation/video4linux/pxa_camera.txt |   49 ++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/pxa_camera.txt b/Documentation/video4linux/pxa_camera.txt
index b1137f9..4f6d0ca 100644
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
++-- | QCI: run             |           | QCI: run             | --+           |
+    | DMA: run             |           | DMA: run             |               |
+    +----------------------+           +----------------------+               |
+               ^                      /           |                           |
+               |          no overrun /            | overrun                   |
+               |                    /             v                           |
+    +--------------------+         /   +----------------------+               |
+    |  Frame completed   |        /    |     Frame overran    |               |
+    +--------------------+ <-----+     +----------------------+ restart frame |
+    | QCI: run           |             | QCI: stop            | --------------+
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

