Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34805 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756305AbcKWLhX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 06:37:23 -0500
Received: by mail-pg0-f65.google.com with SMTP id e9so950270pgc.1
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2016 03:37:23 -0800 (PST)
Received: from shambles.local (c122-106-153-7.carlnfd1.nsw.optusnet.com.au. [122.106.153.7])
        by smtp.gmail.com with ESMTPSA id b12sm49957640pfb.78.2016.11.23.03.37.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Nov 2016 03:37:21 -0800 (PST)
Date: Wed, 23 Nov 2016 22:37:11 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: [patch] fix 'make install'
Message-ID: <20161123113709.GA14257@shambles.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Recent work on handling the case of no frame_vector.c in the kernel
seems to have ended up breaking the 'make install' target. The patch
below makes it work again for me, on ubuntu 16.04 LTS, amd64,
kernel 4.4.
Without it, I get this behavior:
moake -C /home/me/media_build/v4l install
make[1]: Entering directory '/home/me/media_build/v4l'
make[1]: *** No rule to make target 'mm-install', needed by 'install'.  Stop.
make[1]: Leaving directory '/home/me/media_build/v4l'
Makefile:15: recipe for target 'install' failed
make: *** [install] Error 2


diff --git a/v4l/Makefile b/v4l/Makefile
index 28e8fb7..74a2633 100644
--- a/v4l/Makefile
+++ b/v4l/Makefile
@@ -210,8 +210,14 @@ all:: default
 
 #################################################
 # installation invocation rules
-
-modules_install install:: mm-install media-install firmware_install
+INSTALLDEPS :=
+ifeq ($(makefile-mm),1)
+INSTALLDEPS += mm-install
+endif
+ifeq ($(makefile-media),1)
+INSTALLDEPS += media-install
+endif
+modules_install install:: $(INSTALLDEPS) firmware_install
 
 remove rminstall:: media-rminstall
 
Vince
