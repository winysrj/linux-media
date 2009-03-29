Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:33351 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756989AbZC2O6K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 10:58:10 -0400
Date: Sun, 29 Mar 2009 16:57:48 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1 of 8] v4l: use usb_interface for v4l2_device_register
Message-ID: <20090329145748.GB17855@aniel>
References: <patchbomb.1238338474@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="doc_usb_intf_v4l2_dev.diff"
In-Reply-To: <patchbomb.1238338474@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238338428 -7200
# Node ID 36b738f9cb1916e9885084f32bb29373f70f0720
# Parent  df7a51ffa2baddae044a318c928f960488b9ec38
v4l: use usb_interface for v4l2_device_register

If usb_interface.dev is used as dev parameter for v4l2_device_register
v4l2_dev.name contains the v4l driver/module name and usb device and
interface instead of a simple "usb x-y".
It also matches the recommendation to set the parent devices for usb
drivers.

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r df7a51ffa2ba -r 36b738f9cb19 linux/Documentation/video4linux/v4l2-framework.txt
--- a/linux/Documentation/video4linux/v4l2-framework.txt	Sun Mar 29 05:58:58 2009 -0300
+++ b/linux/Documentation/video4linux/v4l2-framework.txt	Sun Mar 29 16:53:48 2009 +0200
@@ -90,7 +90,7 @@
 NULL, then you *must* setup v4l2_dev->name before calling v4l2_device_register.
 
 The first 'dev' argument is normally the struct device pointer of a pci_dev,
-usb_device or platform_device. It is rare for dev to be NULL, but it happens
+usb_interface or platform_device. It is rare for dev to be NULL, but it happens
 with ISA devices or when one device creates multiple PCI devices, thus making
 it impossible to associate v4l2_dev with a particular parent.
 
