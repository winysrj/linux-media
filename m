Return-path: <linux-media-owner@vger.kernel.org>
Received: from jake.logic.tuwien.ac.at ([128.130.175.117]:59310 "EHLO
        jake.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbdCMMEM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 08:04:12 -0400
Received: from t450.itgeo.fhwn.ac.at (morty.logic.tuwien.ac.at [128.130.175.112])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by jake.logic.tuwien.ac.at (Postfix) with ESMTPSA id AF8E5C04DC
        for <linux-media@vger.kernel.org>; Mon, 13 Mar 2017 12:58:40 +0100 (CET)
Received: from localhost (t450.itgeo.fhwn.ac.at [local])
        by t450.itgeo.fhwn.ac.at (OpenSMTPD) with ESMTPA id a497cea4
        for <linux-media@vger.kernel.org>;
        Mon, 13 Mar 2017 12:58:38 +0100 (CET)
Date: Mon, 13 Mar 2017 12:58:38 +0100
From: Ingo Feinerer <feinerer@logic.at>
To: linux-media@vger.kernel.org
Subject: Conditional sys/sysmacros.h inclusion
Message-ID: <20170313115838.GA28761@t450.itgeo.fhwn.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

please find attached a diff that makes the inclusion of the sys/sysmacros.h
header file conditional. I noticed it on OpenBSD which has no sys/sysmacros.h,
so compilation fails there.

Best regards,
Ingo

diff --git a/configure.ac b/configure.ac
index f3269728a..ae58da377 100644
--- a/configure.ac
+++ b/configure.ac
@@ -146,6 +146,7 @@ if test "x$gl_cv_func_ioctl_posix_signature" = xyes; then
 fi
 
 AC_CHECK_FUNCS([__secure_getenv secure_getenv])
+AC_HEADER_MAJOR
 
 # Check host os
 case "$host_os" in
diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
index 59f28b137..1e784eda8 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -20,7 +20,9 @@
  */
 
 #include <sys/types.h>
+#if defined(MAJOR_IN_SYSMACROS)
 #include <sys/sysmacros.h>
+#endif
 #include <sys/mman.h>
 #include <fcntl.h>
 #include <sys/stat.h>
