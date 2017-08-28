Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33746 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdH1XKN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 19:10:13 -0400
To: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 1/2] docs: kernel-doc comments are ASCII
Message-ID: <54c23e8e-89c0-5cea-0dcc-e938952c5642@infradead.org>
Date: Mon, 28 Aug 2017 16:10:09 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

kernel-doc parsing uses as ASCII codec, so let people know that
kernel-doc comments should be in ASCII characters only.

WARNING: kernel-doc '../scripts/kernel-doc -rst -enable-lineno ../drivers/media/dvb-core/demux.h' processing failed with: 'ascii' codec can't decode byte 0xe2 in position 6368: ordinal not in range(128)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/doc-guide/kernel-doc.rst |    3 +++
 1 file changed, 3 insertions(+)

--- lnx-413-rc7.orig/Documentation/doc-guide/kernel-doc.rst
+++ lnx-413-rc7/Documentation/doc-guide/kernel-doc.rst
@@ -108,6 +108,9 @@ The function and type kernel-doc comment
 function or type being described. The overview kernel-doc comments may be freely
 placed at the top indentation level.
 
+.. attention:: kernel-doc comments should be written **only** in ASCII
+	       characters since they are processed as ASCII input.
+
 Example kernel-doc function comment::
 
   /**
