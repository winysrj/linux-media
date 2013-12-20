Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38679 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab3LTFuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 00:50:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v5 12/12] v4l2-framework.txt: add SDR device type
Date: Fri, 20 Dec 2013 07:49:54 +0200
Message-Id: <1387518594-11609-13-git-send-email-crope@iki.fi>
In-Reply-To: <1387518594-11609-1-git-send-email-crope@iki.fi>
References: <1387518594-11609-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add SDR device type to v4l2-framework.txt document.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/video4linux/v4l2-framework.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 6c4866b..ae3a2cc 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -768,6 +768,7 @@ types exist:
 VFL_TYPE_GRABBER: videoX for video input/output devices
 VFL_TYPE_VBI: vbiX for vertical blank data (i.e. closed captions, teletext)
 VFL_TYPE_RADIO: radioX for radio tuners
+VFL_TYPE_SDR: swradioX for Software Defined Radio tuners
 
 The last argument gives you a certain amount of control over the device
 device node number used (i.e. the X in videoX). Normally you will pass -1
-- 
1.8.4.2

