Return-Path: <SRS0=3Wpa=PB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB423C43387
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 07:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99A7D21773
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 07:49:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=logic.at header.i=@logic.at header.b="rGZX4n/W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbeLXHt6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 24 Dec 2018 02:49:58 -0500
Received: from jake.logic.tuwien.ac.at ([128.130.175.117]:35190 "EHLO
        jake.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbeLXHt6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Dec 2018 02:49:58 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2018 02:49:58 EST
Received: from t450.aithon.duckdns.org (morty.logic.tuwien.ac.at [128.130.175.112])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by jake.logic.tuwien.ac.at (Postfix) with ESMTPSA id 7B124C03FA;
        Mon, 24 Dec 2018 08:44:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=logic.at; s=dkim;
        t=1545637494; bh=l/EG5roMoZ8HGvpwNSUzSjaD968G4gKyYfjU7O2HdL4=;
        h=Date:From:To:Cc:Subject:From;
        b=rGZX4n/WKl3dCCmoYWbo+LdIdBILrgFXFvTvsBc/STf5Dv6z8XpXJFbDffINJVU6r
         6KVx+mjHNR9VFJydHL8+VQM9Pepemc8ohtnjqd9KawQDQWHSXWKdnnptZVVIPSFa6G
         v0gEyU05m/c1TiA0a91LXdvxV9GzVn0QnWPHOS+Q=
Received: from localhost (t450.aithon.duckdns.org [local])
        by t450.aithon.duckdns.org (OpenSMTPD) with ESMTPA id 32eb8152;
        Mon, 24 Dec 2018 08:44:51 +0100 (CET)
Date:   Mon, 24 Dec 2018 08:44:51 +0100
From:   Ingo Feinerer <feinerer@logic.at>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>
Subject: Conditional sys/sysmacros.h inclusion
Message-ID: <20181224074451.GA295@t450.aithon.duckdns.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CLnd/WiHFrKtdXgv"
Content-Disposition: inline
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--CLnd/WiHFrKtdXgv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Commit 380fe7d4548a99bfcfc1594b6f0b3dd2369978f1 broke the functionality on
OpenBSD as it has no sys/sysmacros.h. So replicate commit
08572e7db2120bc45db732d02409dfd3346b8e51 but use explicit OS checks instead of
AC_HEADER_MAJOR.

Signed-off-by: Ingo Feinerer <feinerer@logic.at>

--CLnd/WiHFrKtdXgv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sysmacros.diff"

diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
index 59f28b137b..793e19f299 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -20,7 +20,9 @@
  */
 
 #include <sys/types.h>
+#ifndef __OpenBSD__
 #include <sys/sysmacros.h>
+#endif
 #include <sys/mman.h>
 #include <fcntl.h>
 #include <sys/stat.h>

--CLnd/WiHFrKtdXgv--
