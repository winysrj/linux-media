Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34489 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbbEHOUx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2015 10:20:53 -0400
Received: by pdbqa5 with SMTP id qa5so83112435pdb.1
        for <linux-media@vger.kernel.org>; Fri, 08 May 2015 07:20:53 -0700 (PDT)
Date: Sat, 9 May 2015 00:16:30 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: [patch]: v4l-utils/util/dvb add -C to manpages
Message-ID: <20150508141628.GA93623@shambles.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
I noticed the -C option was in the help from the -? option
but not in the manpages.
Cheers
Vince

diff --git a/utils/dvb/dvbv5-scan.1.in b/utils/dvb/dvbv5-scan.1.in
index 08e3163..8016185 100644
--- a/utils/dvb/dvbv5-scan.1.in
+++ b/utils/dvb/dvbv5-scan.1.in
@@ -35,6 +35,9 @@ Force dvbv5\-scan to use DVBv3 only.
 \fB\-a\fR, \fB\-\-adapter\fR=\fIadapter#\fR
 Use the given adapter. Default value: 0.
 .TP
+\fB\-C\fR, \fB\-\-cc\fR=\fIcountry_code\fR
+Use the default parameters for the given country code.
+.TP
 \fB\-d\fR, \fB\-\-demux\fR=\fIdemux#\fR
 Use the given demux. Default value: 0.
 .TP
diff --git a/utils/dvb/dvbv5-zap.1.in b/utils/dvb/dvbv5-zap.1.in
index adfcaac..2e471e6 100644
--- a/utils/dvb/dvbv5-zap.1.in
+++ b/utils/dvb/dvbv5-zap.1.in
@@ -40,6 +40,9 @@ Use the given adapter. Default value: 0.
 Select a different audio Packet ID (PID).
 The default is to use the first audio PID found at the \fBchannel-name-file\fR.
 .TP
+\fB\-C\fR, \fB\-\-cc\fR=\fIcountry_code\fR
+Use the default parameters for the given country code.
+.TP
 \fB\-d\fR, \fB\-\-demux\fR=\fIdemux#\fR
 Use the given demux. Default value: 0.
 .TP
