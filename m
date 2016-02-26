Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:51228 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbcBZHol (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 02:44:41 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D79DB180981
	for <linux-media@vger.kernel.org>; Fri, 26 Feb 2016 08:44:35 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media-device.h: fix compiler warning
Message-ID: <56D00263.8040606@xs4all.nl>
Date: Fri, 26 Feb 2016 08:44:35 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix these compiler warnings:

media-git/include/media/media-device.h: In function 'media_device_pci_init':
media-git/include/media/media-device.h:610:9: warning: 'return' with a value, in function returning void
  return NULL;
         ^
media-git/include/media/media-device.h: In function '__media_device_usb_init':
media-git/include/media/media-device.h:618:9: warning: 'return' with a value, in function returning void
  return NULL;
         ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/include/media/media-device.h b/include/media/media-device.h
index 49dda6c..44012fe 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -607,7 +607,6 @@ static inline void media_device_pci_init(struct media_device *mdev,
 					 struct pci_dev *pci_dev,
 					 char *name)
 {
-	return NULL;
 }

 static inline void __media_device_usb_init(struct media_device *mdev,
@@ -615,7 +614,6 @@ static inline void __media_device_usb_init(struct media_device *mdev,
 					   char *board_name,
 					   char *driver_name)
 {
-	return NULL;
 }

 #endif /* CONFIG_MEDIA_CONTROLLER */
