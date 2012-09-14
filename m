Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:52458 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab2INK54 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:57:56 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBa013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:54 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 05/31] DocBook: bus_info can no longer be empty.
Date: Fri, 14 Sep 2012 12:57:20 +0200
Message-Id: <0b476660ae29f3e7b53f69c0c8f755bd916cd7ec.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the 2012 Media Workshop it was decided that bus_info as returned
by VIDIOC_QUERYCAP can no longer be empty. It should be a unique identifier,
and empty strings are obviously not unique.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/DocBook/media/v4l/vidioc-querycap.xml |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index f33dd74..4c70215 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -90,11 +90,13 @@ ambiguities.</entry>
 	    <entry>__u8</entry>
 	    <entry><structfield>bus_info</structfield>[32]</entry>
 	    <entry>Location of the device in the system, a
-NUL-terminated ASCII string. For example: "PCI Slot 4". This
+NUL-terminated ASCII string. For example: "PCI:0000:05:06.0". This
 information is intended for users, to distinguish multiple
-identical devices. If no such information is available the field may
-simply count the devices controlled by the driver, or contain the
-empty string (<structfield>bus_info</structfield>[0] = 0).<!-- XXX pci_dev->slot_name example --></entry>
+identical devices. If no such information is available the field must
+simply count the devices controlled by the driver ("platform:vivi-000").
+The bus_info must start with "PCI:" for PCI boards, "PCIe:" for PCI Express boards,
+"usb-" for USB devices, "I2C:" for i2c devices, "ISA:" for ISA devices,
+"parport" for parallel port devices and "platform:" for platform devices.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
1.7.10.4

