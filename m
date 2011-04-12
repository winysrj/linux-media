Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305Ab1DLSsr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 14:48:47 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Dan Carpenter <error27@gmail.com>,
	Dmitri Belimov <d.belimov@gmail.com>,
	devel@driverdev.osuosl.org
Subject: [PATCH v2] tm6000: fix vbuf may be used uninitialized
Date: Tue, 12 Apr 2011 14:48:23 -0400
Message-Id: <1302634103-9328-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1300997220-4354-1-git-send-email-jarod@redhat.com>
References: <1300997220-4354-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In commit 8aff8ba95155df, most of the manipulations to vbuf inside
copy_streams were gated on if !dev->radio, but one place that touches
vbuf lays outside those gates -- a memcpy of vbuf isn't NULL. If we
initialize vbuf to NULL, that memcpy will never happen in the case where
we do have dev->radio, and otherwise, in the !dev->radio case, the code
behaves exactly like it did prior to 8aff8ba95155df.

While we're at it, also fix an incorrectly indented closing brace for
one of the sections touching vbuf that is conditional on !dev->radio.

v2: add a detailed commit log and fix that brace

CC: Dan Carpenter <error27@gmail.com>
CC: Dmitri Belimov <d.belimov@gmail.com>
CC: devel@driverdev.osuosl.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/staging/tm6000/tm6000-video.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index c80a316..8b971a0 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -228,7 +228,7 @@ static int copy_streams(u8 *data, unsigned long len,
 	unsigned long header = 0;
 	int rc = 0;
 	unsigned int cmd, cpysize, pktsize, size, field, block, line, pos = 0;
-	struct tm6000_buffer *vbuf;
+	struct tm6000_buffer *vbuf = NULL;
 	char *voutp = NULL;
 	unsigned int linewidth;
 
@@ -318,7 +318,7 @@ static int copy_streams(u8 *data, unsigned long len,
 					if (pos + size > vbuf->vb.size)
 						cmd = TM6000_URB_MSG_ERR;
 					dev->isoc_ctl.vfield = field;
-			}
+				}
 				break;
 			case TM6000_URB_MSG_VBI:
 				break;
-- 
1.7.1

