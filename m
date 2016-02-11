Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:36171 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbcBKXm1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 18:42:27 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com,
	tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	prabhakar.csengg@gmail.com, sw0312.kim@samsung.com,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com,
	ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com,
	dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk,
	linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com,
	nenggun.kim@samsung.com, j.anaszewski@samsung.com,
	geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 17/22] media: au0828 disable tuner to demod link
Date: Thu, 11 Feb 2016 16:41:33 -0700
Message-Id: <3a84b88cf0e17586f41d69d3341f5db0d4ef916f.1455233155.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change au0828_create_media_graph() to find and disable
tuner and demod link. This helps avoid an additional
disable step when tuner is requested by video or audio.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 66b44c9..92d22ed 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -255,7 +255,7 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity *entity;
-	struct media_entity *tuner = NULL, *decoder = NULL;
+	struct media_entity *tuner = NULL, *decoder = NULL, *demod = NULL;
 	int i, ret;
 
 	if (!mdev)
@@ -269,6 +269,9 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		case MEDIA_ENT_F_ATV_DECODER:
 			decoder = entity;
 			break;
+		case MEDIA_ENT_F_DTV_DEMOD:
+			demod = entity;
+			break;
 		}
 	}
 
@@ -325,6 +328,21 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 			break;
 		}
 	}
+
+	/*
+	 * Disable tuner to demod link to avoid disable step
+	 * when tuner is requested by video or audio
+	*/
+	if (tuner && demod) {
+		struct media_link *link;
+
+		list_for_each_entry(link, &demod->links, list) {
+			if (link->sink->entity == demod &&
+			    link->source->entity == tuner) {
+				media_entity_setup_link(link, 0);
+			}
+		}
+	}
 #endif
 	return 0;
 }
-- 
2.5.0

