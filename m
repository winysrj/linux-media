Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48636 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752601AbdLUQSY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 11:18:24 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 10/11] fs: compat_ioctl: add new DVB demux ioctls
Date: Thu, 21 Dec 2017 14:18:09 -0200
Message-Id: <977657752136167fb55acc81d772527d81e2b61f.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use trivial handling for the new DVB demux ioctls, as none
of them passes a pointer inside their structures.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 fs/compat_ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index bd5d91e119ca..cc71c3676ce2 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1333,6 +1333,11 @@ COMPATIBLE_IOCTL(DMX_SET_PES_FILTER)
 COMPATIBLE_IOCTL(DMX_SET_BUFFER_SIZE)
 COMPATIBLE_IOCTL(DMX_GET_PES_PIDS)
 COMPATIBLE_IOCTL(DMX_GET_STC)
+COMPATIBLE_IOCTL(DMX_REQBUFS)
+COMPATIBLE_IOCTL(DMX_QUERYBUF)
+COMPATIBLE_IOCTL(DMX_EXPBUF)
+COMPATIBLE_IOCTL(DMX_QBUF)
+COMPATIBLE_IOCTL(DMX_DQBUF)
 COMPATIBLE_IOCTL(FE_GET_INFO)
 COMPATIBLE_IOCTL(FE_DISEQC_RESET_OVERLOAD)
 COMPATIBLE_IOCTL(FE_DISEQC_SEND_MASTER_CMD)
-- 
2.14.3
