Return-Path: <SRS0=Hs4g=PC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E14C43387
	for <linux-media@archiver.kernel.org>; Tue, 25 Dec 2018 06:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46CAC21773
	for <linux-media@archiver.kernel.org>; Tue, 25 Dec 2018 06:32:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="nQJ3hVdJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbeLYGcA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 25 Dec 2018 01:32:00 -0500
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:53618 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbeLYGcA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Dec 2018 01:32:00 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id D8FC3C0A
        for <linux-media@vger.kernel.org>; Tue, 25 Dec 2018 06:31:58 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sBB8LZC96UHL for <linux-media@vger.kernel.org>;
        Tue, 25 Dec 2018 00:31:58 -0600 (CST)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id A08BEC06
        for <linux-media@vger.kernel.org>; Tue, 25 Dec 2018 00:31:58 -0600 (CST)
Received: by mail-io1-f72.google.com with SMTP id b8so143234ion.5
        for <linux-media@vger.kernel.org>; Mon, 24 Dec 2018 22:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=5NdlyG/quWL5jKDkVUkRPd9fpAV7V1KSFy+IkngMBo0=;
        b=nQJ3hVdJWI+0IB0IRo2Whh7IEetpqlDwIRdjpWNYGBBlP/77KW08SASBYYiXRRGFM3
         /qIOEhnihez+jRli5hK9hr/iX749G8BgI5gmX/4DGuCnYh8ntSiJzZzUX9w55K2h2epm
         ROn7Lrx7PHwLA9Nn+1GPivZ7R0JpUiNjST1RmOlFBMQUvWumTzJJCAPZ/oJz5FDsuaVK
         AaVeKhv6C/9cNqt60XVK79AvqxUt04OUfzVqQu1VZ9SO5dvONH7yE0WbjTACKG3bgrRU
         7xf5GV25MWpOQW+YZW05EGqCJQeGkssggHrKVlf9bdl2s7hzTvYoDhpYc3TnSNfVxVpE
         LHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5NdlyG/quWL5jKDkVUkRPd9fpAV7V1KSFy+IkngMBo0=;
        b=ttMOfzOWkN+t4W7oQURsuH9FH09jbmhnQkbkjZe35QwVRl1Ygtvz+pnkRL0RfI+ysr
         jErcbg08E/W9wmH3FPKM1z5NagNaUJ2aBJyrtFhCAtfgHBUxUq7j74uUASriPseCeZ5w
         RW2sC/4x9J71N8e8G+q7qle35cjAGlmowX2en+Mb9G7mHlRRCNbzbT2qO0n9wCkkoCJo
         2oq43q2LtXQ8qxO6SdIf5Mh1gtXQviB3++RReNGCNMjDjS1Zi55eU0/iDEdRqf+WDuXA
         mpilPrGU0i8vouDNIfXDCOz+YV061QWfa1D1I9H7LHt34KJ5jwVsBUgKRzgp98tmuecS
         Qf0A==
X-Gm-Message-State: AJcUukdTDEcqTPFUXuUXD84EMtfockLEP7KdosQMSjIUojrJavwR4ZhQ
        jB5GGXqdc8fLYgKGCAbeVS0fD655/uw6wQC+0IZTKqI5oQTsZon6l1oY/c76yAbMyZSVY/TP98+
        a9PLDkyN6/NDtOZHoMZG9q5a2kPQ=
X-Received: by 2002:a6b:92d6:: with SMTP id u205mr10986731iod.221.1545719518269;
        Mon, 24 Dec 2018 22:31:58 -0800 (PST)
X-Google-Smtp-Source: ALg8bN7L8Sc3LmwnJJ3dJP9LIBKiw+nkDVVZaLpj8cVogB0TPYwCEqjlWtk+F/LFVUG1mt6LrCWuog==
X-Received: by 2002:a6b:92d6:: with SMTP id u205mr10986724iod.221.1545719518044;
        Mon, 24 Dec 2018 22:31:58 -0800 (PST)
Received: from localhost.localdomain (host-173-230-104-22.mnmigsc.mn.minneapolis.us.clients.pavlovmedia.net. [173.230.104.22])
        by smtp.gmail.com with ESMTPSA id m2sm14386575iol.75.2018.12.24.22.31.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Dec 2018 22:31:57 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gspca: add a missed return-value check for do_command
Date:   Tue, 25 Dec 2018 00:31:21 -0600
Message-Id: <20181225063123.67057-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

do_command() may fail. The fix adds the missed return value of
do_command(). If it fails, returns its error code.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/usb/gspca/cpia1.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c
index 2b09af8865f4..23fbda56fc91 100644
--- a/drivers/media/usb/gspca/cpia1.c
+++ b/drivers/media/usb/gspca/cpia1.c
@@ -547,10 +547,14 @@ static int do_command(struct gspca_dev *gspca_dev, u16 command,
 		}
 		if (sd->params.qx3.button) {
 			/* button pressed - unlock the latch */
-			do_command(gspca_dev, CPIA_COMMAND_WriteMCPort,
+			ret = do_command(gspca_dev, CPIA_COMMAND_WriteMCPort,
 				   3, 0xdf, 0xdf, 0);
-			do_command(gspca_dev, CPIA_COMMAND_WriteMCPort,
+			if (ret)
+				return ret;
+			ret = do_command(gspca_dev, CPIA_COMMAND_WriteMCPort,
 				   3, 0xff, 0xff, 0);
+			if (ret)
+				return ret;
 		}
 
 		/* test whether microscope is cradled */
-- 
2.17.2 (Apple Git-113)

