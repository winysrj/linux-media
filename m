Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38737 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab2HCK1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 06:27:42 -0400
Received: by wibhm11 with SMTP id hm11so6042475wib.1
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 03:27:41 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 3/6] libdvbv5: dvb_dmx_open nonblocking
Date: Fri,  3 Aug 2012 12:26:56 +0200
Message-Id: <1343989619-12928-3-git-send-email-neolynx@gmail.com>
In-Reply-To: <1343989619-12928-1-git-send-email-neolynx@gmail.com>
References: <1343989619-12928-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/dvb-demux.h  |    2 +-
 lib/libdvbv5/dvb-demux.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/include/dvb-demux.h b/lib/include/dvb-demux.h
index 25cd56c..afd6840 100644
--- a/lib/include/dvb-demux.h
+++ b/lib/include/dvb-demux.h
@@ -35,7 +35,7 @@
 extern "C" {
 #endif
 
-int dvb_dmx_open(int adapter, int demux, unsigned verbose);
+int dvb_dmx_open(int adapter, int demux);
 void dvb_dmx_close(int dmx_fd);
 
 int dvb_set_pesfilter(int dmxfd, int pid, dmx_pes_type_t type, dmx_output_t output, int buffersize);
diff --git a/lib/libdvbv5/dvb-demux.c b/lib/libdvbv5/dvb-demux.c
index 138b58a..d07e6cf 100644
--- a/lib/libdvbv5/dvb-demux.c
+++ b/lib/libdvbv5/dvb-demux.c
@@ -40,11 +40,11 @@
 
 #include "dvb-demux.h"
 
-int dvb_dmx_open(int adapter, int demux, unsigned verbose)
+int dvb_dmx_open(int adapter, int demux)
 {
   char* demux_name = NULL;
   asprintf(&demux_name, "/dev/dvb/adapter%i/demux%i", adapter, demux );
-  int fd_demux = open( demux_name, O_RDWR );
+  int fd_demux = open( demux_name, O_RDWR | O_NONBLOCK );
   free( demux_name );
   return fd_demux;
 }
-- 
1.7.2.5

