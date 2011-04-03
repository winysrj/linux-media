Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32781 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1DCXjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 19:39:09 -0400
Received: by iyb14 with SMTP id 14so5389729iyb.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 16:39:08 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 2/3] [media] vb2: use unsigned int for the `mapped' bitfield
Date: Sun,  3 Apr 2011 16:38:56 -0700
Message-Id: <1301873937-14146-2-git-send-email-pawel@osciak.com>
In-Reply-To: <1301873937-14146-1-git-send-email-pawel@osciak.com>
References: <1301873937-14146-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Pawel Osciak <pawel@osciak.com>
Reported-by: David Alan Gilbert <linux@treblig.org>
---
 include/media/videobuf2-core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 4c1e91f..f3bdbb2 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -83,7 +83,7 @@ struct vb2_mem_ops {
 
 struct vb2_plane {
 	void		*mem_priv;
-	int		mapped:1;
+	unsigned int	mapped:1;
 };
 
 /**
-- 
1.7.4.2

