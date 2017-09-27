Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33669
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752214AbdI0WX5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 18:23:57 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v7 4/7] media: open.rst: document devnode-centric and mc-centric types
Date: Wed, 27 Sep 2017 19:23:46 -0300
Message-Id: <f3435f2eb6417a4b16e036a492fc5044915892d1.1506550930.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506550930.git.mchehab@s-opensource.com>
References: <cover.1506550930.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1506550930.git.mchehab@s-opensource.com>
References: <cover.1506550930.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When we added support for omap3, back in 2010, we added a new
type of V4L2 devices that aren't fully controlled via the V4L2
device node.

Yet, we have never clearly documented in the V4L2 specification
the differences between the two types.

Let's document them based on the the current implementation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/open.rst | 40 +++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index 18030131ef77..f603bc9b49a0 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -7,6 +7,46 @@ Opening and Closing Devices
 ***************************
 
 
+.. _v4l2_hardware_control:
+
+
+Types of V4L2 media hardware control
+====================================
+
+V4L2 hardware periferal is usually complex: support for it is
+implemented via a V4L2 main driver and often by several additional drivers.
+The main driver always exposes one or more **V4L2 device nodes**
+(see :ref:`v4l2_device_naming`) with are responsible for implementing
+data streaming, if applicable.
+
+The other drivers are called **V4L2 sub-devices** and provide control to
+other hardware components usually connected via a serial bus (like
+I²C, SMBus or SPI). Depending on the main driver, they can be implicitly
+controlled directly by the main driver or explicitly via
+the **V4L2 sub-device API** (see :ref:`subdev`).
+
+When V4L2 was originally designed, there was only one type of
+media hardware control: via the **V4L2 device nodes**. We refer to this kind
+of control as **V4L2 device node centric** (or, simply, "**vdevnode-centric**").
+
+Later (kernel 2.6.39), a new type of periferal control was
+added in order to support complex media hardware that are common for embedded
+systems. This type of periferal is controlled mainly via the media
+controller and V4L2 sub-devices. So, it is called
+**Media controller centric** (or, simply, "**MC-centric**") control.
+
+For **vdevnode-centric** media hardware control, the media hardware is
+controlled via the **V4L2 device nodes**. They may optionally support the
+:ref:`media controller API <media_controller>` as well,
+in order to inform the application which device nodes are available
+(see :ref:`related`).
+
+For **MC-centric** media hardware control it is required to configure
+the pipelines via the :ref:`media controller API <media_controller>` before
+the periferal can be used. For such devices, the sub-devices' configuration
+can be controlled via the :ref:`sub-device API <subdev>`, which creates one
+device node per sub-device.
+
 .. _v4l2_device_naming:
 
 V4L2 Device Node Naming
-- 
2.13.5
