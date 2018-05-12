Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36276 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbeELLYi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 07:24:38 -0400
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, mchehab+samsung@kernel.org
Cc: linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] Documentation: ioctl-number: add ddbridge IOCTLs
Date: Sat, 12 May 2018 13:24:30 +0200
Message-Id: <20180512112432.30887-2-d.scheller.oss@gmail.com>
In-Reply-To: <20180512112432.30887-1-d.scheller.oss@gmail.com>
References: <20180512112432.30887-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

drivers/media/pci/ddbridge exposes a few IOCTLs which are used by userspace
utilities to ie. update PCIe card's FPGA firmware.

The IOCTLs chosen are in the range 0xDD/0xE0 up to 0xDD/0xFF, with 0xDD as
sort of gimmick for "Digital Devices". To not conflict with the zfpc driver
the upper range (0xE0-0xFF) is used. It is not clear if and which IOCTL
numbers the zfpc driver really uses, from reading the sources at
drivers/s390/scsi/ I couldn't really determine if IOCTLs are in use at all.
Maybe the S390 maintainers can double-check or comment, thus Cc linux-s390.

The upstream dddvb driver currently exposes 12 IOCTLs from which we're
going to handle two at the moment (DDB_FLASHIO and DDB_ID), which is all
that's required to perform the FPGA update on this hardware. The
"reservation" of 32 IDs may seem way too much in this regard, however,
we'd like to be able to stay compatible with the upstream out-of-tree
driver as much as possible, so should any of the remaining 10 IOCTLs be
required at any time (or even more, should upstream add more in the
future), we can just add them into this range without any hassles or
without creating conflicts anywhere.

Cc: linux-doc@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 Documentation/ioctl/ioctl-number.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 84bb74dcae12..feac1b56900b 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -334,6 +334,7 @@ Code  Seq#(hex)	Include File		Comments
 0xDB	00-0F	drivers/char/mwave/mwavepub.h
 0xDD	00-3F	ZFCP device driver	see drivers/s390/scsi/
 					<mailto:aherrman@de.ibm.com>
+0xDD	E0-FF	linux/ddbridge-ioctl.h
 0xE5	00-3F	linux/fuse.h
 0xEC	00-01	drivers/platform/chrome/cros_ec_dev.h	ChromeOS EC driver
 0xF3	00-3F	drivers/usb/misc/sisusbvga/sisusb.h	sisfb (in development)
-- 
2.16.1
