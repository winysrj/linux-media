Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2330 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2ICNs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 09:48:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/10] DocBook: bus_info can no longer be empty.
Date: Mon,  3 Sep 2012 15:48:39 +0200
Message-Id: <74c956b5efd85c1eee1dde877323a610d750aa7e.1346679785.git.hans.verkuil@cisco.com>
In-Reply-To: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl>
References: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
References: <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

During the 2012 Media Workshop it was decided that bus_info as returned
by VIDIOC_QUERYCAP can no longer be empty. It should be a unique identifier,
and empty strings are obviously not unique.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-querycap.xml |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index f33dd74..e3df17a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -90,11 +90,16 @@ ambiguities.</entry>
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
+"usb-" for USB devices, "I2C:" for i2c devices and "ISA:" for ISA devices.
+For devices without a bus it should start with the driver name, optionally
+followed by "-" and an index if multiple instances of the device as possible.
+Many platform devices can have only one instance, so in that case bus_info
+is identical to the <structfield>driver</structfield> field.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
1.7.10.4

