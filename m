Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42735 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbbLLNlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 08:41:01 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/6] [media] DocBook: MC: add the concept of interfaces
Date: Sat, 12 Dec 2015 11:40:41 -0200
Message-Id: <1208c8c461211bd6888441ed5e85331679bfb2f5.1449927561.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449927561.git.mchehab@osg.samsung.com>
References: <cover.1449927561.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449927561.git.mchehab@osg.samsung.com>
References: <cover.1449927561.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Media Controller next generation patches added a new graph
element type: interfaces. It also allows links between interfaces
and entities. Update the docbook to reflect that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 .../DocBook/media/v4l/media-controller.xml         | 40 ++++++++++++++--------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/media-controller.xml b/Documentation/DocBook/media/v4l/media-controller.xml
index 873ac3a621f0..def4a27aadef 100644
--- a/Documentation/DocBook/media/v4l/media-controller.xml
+++ b/Documentation/DocBook/media/v4l/media-controller.xml
@@ -58,20 +58,32 @@
     <title>Media device model</title>
     <para>Discovering a device internal topology, and configuring it at runtime,
     is one of the goals of the media controller API. To achieve this, hardware
-    devices are modelled as an oriented graph of building blocks called entities
-    connected through pads.</para>
-    <para>An entity is a basic media hardware or software building block. It can
-    correspond to a large variety of logical blocks such as physical hardware
-    devices (CMOS sensor for instance), logical hardware devices (a building
-    block in a System-on-Chip image processing pipeline), DMA channels or
-    physical connectors.</para>
-    <para>A pad is a connection endpoint through which an entity can interact
-    with other entities. Data (not restricted to video) produced by an entity
-    flows from the entity's output to one or more entity inputs. Pads should not
-    be confused with physical pins at chip boundaries.</para>
-    <para>A link is a point-to-point oriented connection between two pads,
-    either on the same entity or on different entities. Data flows from a source
-    pad to a sink pad.</para>
+    devices and Linux Kernel interfaces are modelled as graph objects on
+    an oriented graph. The object types that constitute the graph are:</para>
+    <itemizedlist>
+    <listitem><para>An <emphasis role="bold">entity</emphasis>
+    is a basic media hardware or software building block. It can correspond to
+    a large variety of logical blocks such as physical hardware devices
+    (CMOS sensor for instance), logical hardware devices (a building block in
+    a System-on-Chip image processing pipeline), DMA channels or physical
+    connectors.</para></listitem>
+    <listitem><para>An <emphasis role="bold">interface</emphasis>
+    is a graph representation of a Linux Kernel userspace API interface,
+    like a device node or a sysfs file that controls one or more entities
+    in the graph.</para></listitem>
+    <listitem><para>A <emphasis role="bold">pad</emphasis>
+    is a data connection endpoint through which an entity can interact with
+    other entities. Data (not restricted to video) produced by an entity
+    flows from the entity's output to one or more entity inputs. Pads should
+    not be confused with physical pins at chip boundaries.</para></listitem>
+    <listitem><para>A <emphasis role="bold">data link</emphasis>
+    is a point-to-point oriented connection between two pads, either on the
+    same entity or on different entities. Data flows from a source pad to a
+    sink pad.</para></listitem>
+    <listitem><para>An <emphasis role="bold">interface link</emphasis>
+    is a point-to-point bidirectional control connection between a Linux
+    Kernel interface and an entity.m</para></listitem>
+    </itemizedlist>
   </section>
 </chapter>
 
-- 
2.5.0


