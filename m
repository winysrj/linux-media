Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:49709 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760389AbbKTQe2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 11:34:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv10 02/15] solo6x10: use v4l2_get_timestamp to fill in buffer timestamp
Date: Fri, 20 Nov 2015 17:34:05 +0100
Message-Id: <1448037258-36305-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The timestamp of a v4l2_buffer was advertised as being CLOCK_MONOTONIC,
but instead a timestamp from a header field was used. This is inconsistent
and not what applications expect. Use v4l2_get_timestamp to properly
set the timestamp.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 1f81f8d..5b7853b 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -531,8 +531,7 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 
 	if (!ret) {
 		vbuf->sequence = solo_enc->sequence++;
-		vbuf->timestamp.tv_sec = vop_sec(vh);
-		vbuf->timestamp.tv_usec = vop_usec(vh);
+		v4l2_get_timestamp(&vbuf->timestamp);
 
 		/* Check for motion flags */
 		if (solo_is_motion_on(solo_enc) && enc_buf->motion) {
-- 
2.6.2

