Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:50989 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbaDIW1W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 18:27:22 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so2419270eek.9
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 15:27:21 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/7] libdvbv5: fix asprintf compile warning in dvbv5-scan
Date: Thu, 10 Apr 2014 00:26:55 +0200
Message-Id: <1397082420-31198-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
References: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 utils/dvb/dvbv5-scan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 501b332..7eb3bf5 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -407,6 +407,7 @@ int main(int argc, char **argv)
 {
 	struct arguments args;
 	int err, lnb = -1,idx = -1;
+	int r;
 	const struct argp argp = {
 		.options = options,
 		.parser = parse_opt,
@@ -459,8 +460,12 @@ int main(int argc, char **argv)
 		return -1;
 	}
 
-	asprintf(&args.demux_dev,
+	r = asprintf(&args.demux_dev,
 		 "/dev/dvb/adapter%i/demux%i", args.adapter_dmx, args.demux);
+	if (r < 0) {
+		fprintf(stderr, "asprintf error\n" );
+		return -1;
+	}
 
 	if (verbose)
 		fprintf(stderr, "using demux '%s'\n", args.demux_dev);
-- 
1.7.10.4

