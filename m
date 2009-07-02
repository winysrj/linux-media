Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46453 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZGBRXH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jul 2009 13:23:07 -0400
Date: Thu, 2 Jul 2009 14:23:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Patch: Schedule obsolete v4l1 quickcam_messenger and ov511
 drivers for removal
Message-ID: <20090702142301.718d26e7@pedra.chehab.org>
In-Reply-To: <4A40BEFA.1030404@redhat.com>
References: <4A40BEFA.1030404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Tue, 23 Jun 2009 13:39:38 +0200
Hans de Goede <hdegoede@redhat.com> escreveu:

> Schedule obsolete v4l1 quickcam_messenger and ov511 drivers for removal
> 

It would be better to add the "Files:" field to explicitly indicate what files
will be removed, like the modified version of your patch. Please check if those
are the files you're meaning to remove:

---

From: Hans de Goede <hdegoede@redhat.com>

Schedule obsolete v4l1 quickcam_messenger and ov511 drivers for removal

[mchehab@redhat.com: add the files: tag to indicate what will be removed]

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index f8cd450..8a8c045 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -458,3 +458,19 @@ Why:	Remove the old legacy 32bit machine check code. This has been
 	but the old version has been kept around for easier testing. Note this
 	doesn't impact the old P5 and WinChip machine check handlers.
 Who:	Andi Kleen <andi@firstfloor.org>
+
+----------------------------
+
+What:	usbvideo quickcam_messenger driver
+When:	2.6.32
+Why:	obsolete v4l1 driver replaced by gspca_stv06xx
+Who:	Hans de Goede <hdegoede@redhat.com>
+Files:	drivers/media/video/c-qcam.c drivers/media/video/bw-qcam.c
+
+----------------------------
+
+What:	ov511 v4l1 driver
+When:	2.6.32
+Why:	obsolete v4l1 driver replaced by gspca_ov519
+Who:	Hans de Goede <hdegoede@redhat.com>
+Files:	drivers/media/video/ov511.[ch]




Cheers,
Mauro
