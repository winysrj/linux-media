Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab1IFPaS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 11:30:18 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 06/10] Backport UVC fix from Fedora
Date: Tue,  6 Sep 2011 12:29:52 -0300
Message-Id: <1315322996-10576-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1315322996-10576-5-git-send-email-mchehab@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
 <1315322996-10576-2-git-send-email-mchehab@redhat.com>
 <1315322996-10576-3-git-send-email-mchehab@redhat.com>
 <1315322996-10576-4-git-send-email-mchehab@redhat.com>
 <1315322996-10576-5-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From Fedora logs:
	fix #655038 - tvtime does not work with UVC webcams

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 src/videoinput.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/src/videoinput.c b/src/videoinput.c
index 2102b04..a8fd829 100644
--- a/src/videoinput.c
+++ b/src/videoinput.c
@@ -294,6 +294,7 @@ uint8_t *videoinput_next_frame( videoinput_t *vidin, int *frameid )
     wait_for_frame_v4l2( vidin );
  
     cur_buf.type = vidin->capbuffers[ 0 ].vidbuf.type;
+    cur_buf.memory = vidin->capbuffers[ 0 ].vidbuf.memory;
     if( ioctl( vidin->grab_fd, VIDIOC_DQBUF, &cur_buf ) < 0 ) {
 	/* some drivers return EIO when there is no signal */
 	if( errno != EIO ) {
-- 
1.7.6.1

