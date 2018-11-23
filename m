Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55649 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387885AbeKWWhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 17:37:48 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils] keytable: do not install bpf protocols decoders with execute permission
Date: Fri, 23 Nov 2018 11:53:51 +0000
Message-Id: <20181123115351.13856-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rpm packaging system will try to extract debug information, which
fails since there is no build id. This can be avoided by removing
the execute permission.

BPF relocatable files are executable anyway so this is the right
thing to do.

See:
	https://github.com/rpm-software-management/rpm/pull/604

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/bpf_protocols/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/keytable/bpf_protocols/Makefile.am b/utils/keytable/bpf_protocols/Makefile.am
index 1b90411b..d1f04cb4 100644
--- a/utils/keytable/bpf_protocols/Makefile.am
+++ b/utils/keytable/bpf_protocols/Makefile.am
@@ -21,4 +21,4 @@ EXTRA_DIST = $(PROTOCOLS:%.o=%.c) bpf_helpers.h
 install-data-local:
 	$(install_sh) -d "$(DESTDIR)$(keytableuserdir)/protocols"
 	$(install_sh) -d "$(DESTDIR)$(keytablesystemdir)/protocols"
-	$(install_sh) $(PROTOCOLS) "$(DESTDIR)$(keytablesystemdir)/protocols"
+	$(install_sh) -m 0644 $(PROTOCOLS) "$(DESTDIR)$(keytablesystemdir)/protocols"
-- 
2.19.1
