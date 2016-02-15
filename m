Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbcBOVUK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 16:20:10 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 1690FC0C2351
	for <linux-media@vger.kernel.org>; Mon, 15 Feb 2016 21:20:10 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH xawtv3 2/3] mtt: Fix mtt not being able to tune tv channels
Date: Mon, 15 Feb 2016 22:20:01 +0100
Message-Id: <1455571202-5189-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455571202-5189-1-git-send-email-hdegoede@redhat.com>
References: <1455571202-5189-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Teletext should use the tv tuner not the radio tuner...

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 x11/vbi-gui.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x11/vbi-gui.c b/x11/vbi-gui.c
index f4b19da..429c8b2 100644
--- a/x11/vbi-gui.c
+++ b/x11/vbi-gui.c
@@ -917,7 +917,7 @@ static void vbi_station_cb(Widget widget, XtPointer client, XtPointer call)
 	struct v4l2_frequency frequency;
 
 	memset (&frequency, 0, sizeof(frequency));
-	frequency.type = V4L2_TUNER_RADIO;
+	frequency.type = V4L2_TUNER_ANALOG_TV;
 	frequency.frequency = channels[i]->freq;
 	if (-1 == ioctl(vbi->fd, VIDIOC_S_FREQUENCY, &frequency))
 	    perror("ioctl VIDIOCSFREQ");
-- 
2.7.1

