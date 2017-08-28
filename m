Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58239
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751270AbdH1MyI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 08:54:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v5 4/7] media: open.rst: document devnode-centric and mc-centric types
Date: Mon, 28 Aug 2017 09:53:58 -0300
Message-Id: <828e47356d5c133a0a052f34e97be24ea3037df2.1503924361.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503924361.git.mchehab@s-opensource.com>
References: <cover.1503924361.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1503924361.git.mchehab@s-opensource.com>
References: <cover.1503924361.git.mchehab@s-opensource.com>
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
index 96ac972c1fa2..21b8f7c5ca55 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -7,6 +7,46 @@ Opening and Closing Devices
 ***************************
 
 
+.. _v4l2_hardware_control:
+
+
+Types of V4L2 hardware peripheral control
+=========================================
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
+peripheral control: via the **V4L2 device nodes**. We refer to this kind
+of control as **V4L2 device node centric** (or, simply, "**vdev-centric**").
+
+Later (kernel 2.6.39), a new type of periferal control was
+added in order to support complex peripherals that are common for embedded
+systems. This type of periferal is controlled mainly via the media
+controller and V4L2 sub-devices. So, it is called
+**Media controller centric** (or, simply, "**MC-centric**") control.
+
+For **vdev-centric** hardware peripheral control, the peripheral is
+controlled via the **V4L2 device nodes**. They may optionally support the
+:ref:`media controller API <media_controller>` as well,
+in order to inform the application which device nodes are available
+(see :ref:`related`).
+
+For **MC-centric** hardware peripheral control it is required to configure
+the pipelines via the :ref:`media controller API <media_controller>` before
+the periferal can be used. For such devices, the sub-devices' configuration
+can be controlled via the :ref:`sub-device API <subdev>`, which creates one
+device node per sub-device.
+
 .. _v4l2_device_naming:
 
 V4L2 Device Node Naming
-- 
2.13.5
