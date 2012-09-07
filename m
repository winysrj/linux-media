Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2604 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab2IGN3g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 05/28] DocBook: bus_info can no longer be empty.
Date: Fri,  7 Sep 2012 15:29:05 +0200
Message-Id: <7d0e5a9425253ece02bb57adc9413a5558200f2d.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

During the 2012 Media Workshop it was decided that bus_info as returned
by VIDIOC_QUERYCAP can no longer be empty. It should be a unique identifier,
and empty strings are obviously not unique.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-querycap.xml |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index f33dd74..d5b1248 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -90,11 +90,17 @@ ambiguities.</entry>
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
+simply count the devices controlled by the driver ("vivi-000"). The bus_info
+must start with "PCI:" for PCI boards, "PCIe:" for PCI Express boards,
+"usb-" for USB devices, "I2C:" for i2c devices, "ISA:" for ISA devices and
+"parport" for parallel port devices.
+For devices without a bus it should start with the driver name, optionally
+followed by "-" and an index if multiple instances of the device as possible.
+Many platform devices can have only one instance, so in that case bus_info
+is identical to the <structfield>driver</structfield> field.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
1.7.10.4

