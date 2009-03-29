Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:52204 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbZC2MiI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 08:38:08 -0400
Date: Sun, 29 Mar 2009 14:37:47 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1 of 6] v4l: use usb_interface for v4l2_device_register
Message-ID: <20090329123747.GB637@aniel>
References: <patchbomb.1238329154@aniel>
MIME-Version: 1.0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="v4l2_device_usb_interface-1.patch"
In-Reply-To: <patchbomb.1238329154@aniel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1238189646 -3600
# Node ID 602a8fff1ba466ec4fb4816d0fb0725c8650c311
# Parent  b1596c6517c925abd1e683e86592af1aedf9de06
v4l: use usb_interface for v4l2_device_register

From: Janne Grunau <j@jannau.net>

If usb_interface.dev is used as dev parameter for v4l2_device_register
v4l2_dev.name contains the v4l driver/module name and usb device and
interface instead of a simple "usb x-y".
It also matches the recommendation to set the parent devices for usb
drivers.

Priority: normal

Signed-off-by: Janne Grunau <j@jannau.net>

diff -r b1596c6517c9 -r 602a8fff1ba4 linux/Documentation/video4linux/v4l2-framework.txt
--- a/linux/Documentation/video4linux/v4l2-framework.txt	Thu Mar 26 20:47:48 2009 +0000
+++ b/linux/Documentation/video4linux/v4l2-framework.txt	Fri Mar 27 22:34:06 2009 +0100
@@ -90,7 +90,7 @@
 NULL, then you *must* setup v4l2_dev->name before calling v4l2_device_register.
 
 The first 'dev' argument is normally the struct device pointer of a pci_dev,
-usb_device or platform_device. It is rare for dev to be NULL, but it happens
+usb_interface or platform_device. It is rare for dev to be NULL, but it happens
 with ISA devices or when one device creates multiple PCI devices, thus making
 it impossible to associate v4l2_dev with a particular parent.
 
