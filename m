Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46855 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab3L2EF2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 23:05:28 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v6 12/12] v4l2-framework.txt: add SDR device type
Date: Sun, 29 Dec 2013 06:04:04 +0200
Message-Id: <1388289844-2766-13-git-send-email-crope@iki.fi>
In-Reply-To: <1388289844-2766-1-git-send-email-crope@iki.fi>
References: <1388289844-2766-1-git-send-email-crope@iki.fi>
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

