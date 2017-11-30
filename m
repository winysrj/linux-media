Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46114 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750964AbdK3NnD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 08:43:03 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH] kernel-doc: parse DECLARE_KFIFO_PTR()
Date: Thu, 30 Nov 2017 08:42:57 -0500
Message-Id: <a0a0392564bd4405b919241de9fb0fc7ec9be8cd.1512049320.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On media, we now have an struct declared with:

struct lirc_fh {
        struct list_head list;
        struct rc_dev *rc;
        int                             carrier_low;
        bool                            send_timeout_reports;
        DECLARE_KFIFO_PTR(rawir, unsigned int);
        DECLARE_KFIFO_PTR(scancodes, struct lirc_scancode);
        wait_queue_head_t               wait_poll;
        u8                              send_mode;
        u8                              rec_mode;
};

Currently, it produces the following error:

	./include/media/rc-core.h:96: warning: No description found for parameter 'int'
	./include/media/rc-core.h:96: warning: No description found for parameter 'lirc_scancode'
	./include/media/rc-core.h:96: warning: Excess struct member 'rawir' description in 'lirc_fh'
	./include/media/rc-core.h:96: warning: Excess struct member 'scancodes' description in 'lirc_fh'

So, teach kernel-doc how to parse a DECLARE_KFIFO_PTR();

While here, relax at the past DECLARE_foo() macros,
accepting a random number of spaces after comma.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index bd29a92b4b48..5c12208f8c89 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2208,10 +2208,11 @@ sub dump_struct($$) {
 	$members =~ s/__aligned\s*\([^;]*\)//gos;
 	$members =~ s/\s*CRYPTO_MINALIGN_ATTR//gos;
 	# replace DECLARE_BITMAP
-	$members =~ s/DECLARE_BITMAP\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[BITS_TO_LONGS($2)\]/gos;
+	$members =~ s/DECLARE_BITMAP\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long $1\[BITS_TO_LONGS($2)\]/gos;
 	# replace DECLARE_HASHTABLE
-	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+), ([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
-
+	$members =~ s/DECLARE_HASHTABLE\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long $1\[1 << (($2) - 1)\]/gos;
+	# replace DECLARE_KFIFO_PTR(fifo, type)
+	$members =~ s/DECLARE_KFIFO_PTR\s*\(([^,)]+),\s*([^,)]+)\)/$2 \*$1/gos;
 	create_parameterlist($members, ';', $file);
 	check_sections($file, $declaration_name, $decl_type, $sectcheck, $struct_actual, $nested);
 
-- 
2.14.3
