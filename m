Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41510 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707AbcAVPNa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2016 10:13:30 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: "Ove Brynestad (ovebryne)" <ovebryne@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: fix broken Bayer text rendering
Message-ID: <56A24715.1040601@xs4all.nl>
Date: Fri, 22 Jan 2016 16:13:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes when a Bayer pixelformat is selected the rendering of the OSD text
by vivid was all wrong: every other line of the text was shifted by half the width
or more.

It turned out that to render Bayer formats the interleaved boolean is set to true
in the tpg. This mode indicates a semi-biplanar mode where two interleaved planes
are used to render the frame. From outside the tpg it looks like a single plane,
but internally it is two planes.

However, in the tpg_s_bytesperline() function the interleaved bool wasn't checked
and only the bytesperline value for plane 0 was updated. But for the interleaved
mode the same value has to be copied to bytesperline[1] as well.

The effect was that whatever old value was left in bytesperline[1] was used, which
caused all sorts of weird and seemingly unpredictable shifts.

Apologies to Ove for not believing him initially...

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Ove Brynestad <ovebryne@cisco.com>
---
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index 9baed6a..93fbaee 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -418,6 +418,8 @@ static inline void tpg_s_bytesperline(struct tpg_data *tpg, unsigned plane, unsi

 		tpg->bytesperline[p] = plane_w / tpg->hdownsampling[p];
 	}
+	if (tpg_g_interleaved(tpg))
+		tpg->bytesperline[1] = tpg->bytesperline[0];
 }


