Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57199 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZJXPtU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 11:49:20 -0400
Received: by pwj9 with SMTP id 9so641888pwj.21
        for <linux-media@vger.kernel.org>; Sat, 24 Oct 2009 08:49:24 -0700 (PDT)
Message-ID: <4AE32200.6070107@gmail.com>
Date: Sat, 24 Oct 2009 23:49:20 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: v4l-dvb <linux-media@vger.kernel.org>
Subject: gcc 4.3.3 compilation problem
Content-Type: multipart/mixed;
 boundary="------------030500030901090902090900"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030500030901090902090900
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I encounter a compilation error on gcc 4.3.3 ubuntu 9.04 x86_64.

The compiler complains missing parameter name for first parameter of 
function dib7000p_pid_filter().

attached patch fix the problem.

David

--------------030500030901090902090900
Content-Type: text/x-patch;
 name="gcc4.3.3_compilation_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gcc4.3.3_compilation_fix.patch"

changeset:   13157:df47ca1f4db5
user:        David T.L. Wong <davidtlwong@gmail.com>
date:        Sat Oct 24 23:16:11 2009 +0800
summary:     fix gcc-4.3.3 compilation error

diff --git a/linux/drivers/media/dvb/frontends/dib7000p.h b/linux/drivers/media/dvb/frontends/dib7000p.h
--- a/linux/drivers/media/dvb/frontends/dib7000p.h
+++ b/linux/drivers/media/dvb/frontends/dib7000p.h
@@ -97,7 +97,7 @@
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return -ENODEV;
 }
-static inline int dib7000p_pid_filter(struct dvb_frontend *, u8 id, u16 pid, u8 onoff)
+static inline int dib7000p_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 {
     printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
     return -ENODEV;


--------------030500030901090902090900--
