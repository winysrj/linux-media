Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54440 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab2IXOas (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 10:30:48 -0400
Received: by bkcjk13 with SMTP id jk13so952104bkc.19
        for <linux-media@vger.kernel.org>; Mon, 24 Sep 2012 07:30:47 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com,
	hans.verkuil@cisco.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: add module_pci_driver to compat.h
Date: Mon, 24 Sep 2012 16:30:35 +0200
Message-Id: <1348497035-28470-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch corrects this warnings on a Ubuntu 10.04 system with kernel 2.6.32-43:

bt87x.c:972: warning: data definition has no type or storage class
bt87x.c:972: warning: type defaults to 'int' in declaration of 'module_pci_driver'
bt87x.c:972: warning: parameter names (without types) in function declaration
bt87x.c:965: warning: 'bt87x_driver' defined but not used
core.c:321: warning: data definition has no type or storage class
core.c:321: warning: type defaults to 'int' in declaration of 'module_pci_driver'
core.c:321: warning: parameter names (without types) in function declaration
core.c:314: warning: 'solo_pci_driver' defined but not used

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 v4l/compat.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/v4l/compat.h b/v4l/compat.h
index fdc6d4a..8d5c13a 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -1064,4 +1064,10 @@ static inline int usb_endpoint_maxp(const struct usb_endpoint_descriptor *epd)
 #define printk_ratelimited printk
 #endif
 
+#ifndef module_pci_driver
+#define module_pci_driver(__pci_driver) \
+       module_driver(__pci_driver, pci_register_driver, \
+                       pci_unregister_driver)
+#endif
+
 #endif /*  _COMPAT_H */
-- 
1.7.0.4

