Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B96EC43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AC1020661
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:18:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JuQ/xYgS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfCFVSG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:18:06 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38003 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfCFVSG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:18:06 -0500
Received: by mail-wr1-f67.google.com with SMTP id g12so15045978wrm.5
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4g1J+UKxUiGZS2eq+l2j4sB8EZ28KfhN+TrdzntsQAs=;
        b=JuQ/xYgSLRE4LC2Eq/F/TlsN525dpIuvU8JD3ebobwVTxnSPKEq2XlcMZw267UfBU+
         fdcpPnRGmTFEgjR8vtBbCEFc+3OVEEymeDFUGnlNnTppxHa4kdHMAsCLfEYNVKnHImqk
         xCOijyM0PF535NH/woObDHFEvVJNbX8cwqDDlALZ/8huBDWpCkxXgobJsNpvue6sHeYF
         ZWJ9cpuChipofnWnorDKduwjvMgYsE5iP0cxrt75Mxwm1ITrOo/ib0SLOEWkjyBkql5L
         hoA/4bEQKHVBktBSdoAnwL1SO8y2di1nCaX+yRKLId3Gkylf7bD6GvRO+INNlJoFsE82
         VzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4g1J+UKxUiGZS2eq+l2j4sB8EZ28KfhN+TrdzntsQAs=;
        b=V1N7oIkLgI/47LI3x5mX7xNfb7EINg2fEpPK+uRXZCb5sXVRVwMZaSlbO5E4jLkOXV
         i93GXwSu/Y2dF18f/SDfQzuyQV4msdivApj5Se7/eqOZe0kH22aQGoi6/cXkf8GLZOpe
         dQAxd9sPuOZoDH/S2cLH46Vnf/x8XA7ndLeLm/jUAvGTp+bYsUkEQSB+MzesjOeH5cFE
         rKhUZZGCci1a0wKlH6fYEWKnzlpaczC1bleHLTCHuANA3SWiYxqlpWCg4aUxn01Sa/xZ
         9uV562vdfGzKev7BMdeF5C5adebR2oSIXTFtxykt+D475sdx6iSaS2Bnrn/HOqMhn8Vg
         mVVQ==
X-Gm-Message-State: APjAAAWiwVE2AIV8MZQeL4VAYHBE04DrBwVczImOyFrPKU/X83kmhtjI
        0YWNbxtqYb4HQA3V+ZdUeEclTWmYr/I=
X-Google-Smtp-Source: APXvYqzNgRwSmlNmlhhq6felQa57mDvz0nMJrrrr8jA4S37TME3Tz+5MgQneOK+gHCFEB6/gTN58BA==
X-Received: by 2002:adf:fecd:: with SMTP id q13mr4377305wrs.3.1551907083757;
        Wed, 06 Mar 2019 13:18:03 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id c2sm5252495wrt.93.2019.03.06.13.18.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:18:03 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v5 3/6] v4l2-ctl: set the in/out fmt variables in streaming_set_m2m
Date:   Wed,  6 Mar 2019 13:17:49 -0800
Message-Id: <20190306211752.15531-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211752.15531-1-dafna3@gmail.com>
References: <20190306211752.15531-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

set the in/out fmt variables in streaming_set_m2m
This is needed later to check for stateless
fwht pixel format.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 465ba50c..9bb58a0b 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -1949,7 +1949,8 @@ static int capture_setup(cv4l_fd &fd, cv4l_queue &in, cv4l_fd *exp_fd)
 }
 
 static void stateful_m2m(cv4l_fd &fd, cv4l_queue &in, cv4l_queue &out,
-			 FILE *fin, FILE *fout, cv4l_fd *exp_fd_p)
+			 FILE *fin, FILE *fout, cv4l_fmt &fmt_in,
+			 cv4l_fmt &fmt_out, cv4l_fd *exp_fd_p)
 {
 	int fd_flags = fcntl(fd.g_fd(), F_GETFL);
 	fps_timestamps fps_ts[2];
@@ -1959,10 +1960,6 @@ static void stateful_m2m(cv4l_fd &fd, cv4l_queue &in, cv4l_queue &out,
 	fd_set *ex_fds = &fds[1]; /* for capture */
 	fd_set *wr_fds = &fds[2]; /* for output */
 	bool cap_streaming = false;
-	cv4l_fmt fmt[2];
-
-	fd.g_fmt(fmt[OUT], out.g_type());
-	fd.g_fmt(fmt[CAP], in.g_type());
 
 	struct v4l2_event_subscription sub;
 
@@ -2040,7 +2037,7 @@ static void stateful_m2m(cv4l_fd &fd, cv4l_queue &in, cv4l_queue &out,
 
 		if (rd_fds && FD_ISSET(fd.g_fd(), rd_fds)) {
 			r = do_handle_cap(fd, in, fin, NULL,
-					  count[CAP], fps_ts[CAP], fmt[CAP]);
+					  count[CAP], fps_ts[CAP], fmt_in);
 			if (r < 0) {
 				rd_fds = NULL;
 				if (!have_eos) {
@@ -2052,7 +2049,7 @@ static void stateful_m2m(cv4l_fd &fd, cv4l_queue &in, cv4l_queue &out,
 
 		if (wr_fds && FD_ISSET(fd.g_fd(), wr_fds)) {
 			r = do_handle_out(fd, out, fout, NULL,
-					  count[OUT], fps_ts[OUT], fmt[OUT]);
+					  count[OUT], fps_ts[OUT], fmt_out);
 			if (r < 0)  {
 				wr_fds = NULL;
 
@@ -2103,8 +2100,8 @@ static void stateful_m2m(cv4l_fd &fd, cv4l_queue &in, cv4l_queue &out,
 				last_buffer = false;
 				if (capture_setup(fd, in, exp_fd_p))
 					return;
-				fd.g_fmt(fmt[OUT], out.g_type());
-				fd.g_fmt(fmt[CAP], in.g_type());
+				fd.g_fmt(fmt_out, out.g_type());
+				fd.g_fmt(fmt_in, in.g_type());
 				cap_streaming = true;
 			} else {
 				break;
@@ -2129,6 +2126,10 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 	cv4l_queue exp_q(exp_fd.g_type(), V4L2_MEMORY_MMAP);
 	cv4l_fd *exp_fd_p = NULL;
 	FILE *file[2] = {NULL, NULL};
+	cv4l_fmt fmt[2];
+
+	fd.g_fmt(fmt[OUT], out.g_type());
+	fd.g_fmt(fmt[CAP], in.g_type());
 
 	if (!fd.has_vid_m2m()) {
 		fprintf(stderr, "unsupported m2m stream type\n");
-- 
2.17.1

