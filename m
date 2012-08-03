Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41272 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2HCK1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 06:27:43 -0400
Received: by wgbdr13 with SMTP id dr13so517484wgb.1
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 03:27:42 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 4/6] libdvbv5: added dmx stop function
Date: Fri,  3 Aug 2012 12:26:57 +0200
Message-Id: <1343989619-12928-4-git-send-email-neolynx@gmail.com>
In-Reply-To: <1343989619-12928-1-git-send-email-neolynx@gmail.com>
References: <1343989619-12928-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/dvb-demux.h  |    1 +
 lib/libdvbv5/dvb-demux.c |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/lib/include/dvb-demux.h b/lib/include/dvb-demux.h
index afd6840..923016e 100644
--- a/lib/include/dvb-demux.h
+++ b/lib/include/dvb-demux.h
@@ -37,6 +37,7 @@ extern "C" {
 
 int dvb_dmx_open(int adapter, int demux);
 void dvb_dmx_close(int dmx_fd);
+void dvb_dmx_stop(int dmx_fd);
 
 int dvb_set_pesfilter(int dmxfd, int pid, dmx_pes_type_t type, dmx_output_t output, int buffersize);
 
diff --git a/lib/libdvbv5/dvb-demux.c b/lib/libdvbv5/dvb-demux.c
index d07e6cf..6ed2dcd 100644
--- a/lib/libdvbv5/dvb-demux.c
+++ b/lib/libdvbv5/dvb-demux.c
@@ -55,6 +55,11 @@ void dvb_dmx_close(int dmx_fd)
   close( dmx_fd);
 }
 
+void dvb_dmx_stop(int dmx_fd)
+{
+  (void) ioctl( dmx_fd, DMX_STOP);
+}
+
 int dvb_set_pesfilter(int dmxfd, int pid, dmx_pes_type_t type, dmx_output_t output, int buffersize)
 {
 	struct dmx_pes_filter_params pesfilter;
-- 
1.7.2.5

