Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:62691 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab0APQCf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 11:02:35 -0500
Message-ID: <4B51E313.4060102@freemail.hu>
Date: Sat, 16 Jan 2010 17:02:27 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, Andy Walls <awalls@radix.net>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] disable building cx23885 before 2.6.33
References: <201001141910.o0EJARf7029441@smtp-vbr14.xs4all.nl> <4B4F7D14.7080806@freemail.hu> <201001150236.25297.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201001150236.25297.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The cx23885 driver does not compile before Linux kernel 2.6.33 because of
incompatible fifo API changes. Disable this driver being built before
2.6.33.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 5bcdcc072b6d v4l/versions.txt
--- a/v4l/versions.txt	Sat Jan 16 07:25:43 2010 +0100
+++ b/v4l/versions.txt	Sat Jan 16 16:56:28 2010 +0100
@@ -1,6 +1,10 @@
 # Use this for stuff for drivers that don't compile
 [2.6.99]

+[2.6.33]
+# Incompatible fifo API changes, see <linux/kfifo.h>
+VIDEO_CX23885
+
 [2.6.32]
 # These rely on arch support that wasn't available until 2.6.32
 VIDEO_SH_MOBILE_CEU

