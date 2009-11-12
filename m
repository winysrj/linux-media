Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:61885 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZKLGwv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 01:52:51 -0500
Received: from [192.168.1.64] (dsl5402C46E.pool.t-online.hu [84.2.196.110])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail02d.mail.t-online.hu (Postfix) with ESMTPSA id 720917590E2
	for <linux-media@vger.kernel.org>; Thu, 12 Nov 2009 07:52:32 +0100 (CET)
Message-ID: <4AFBB0C3.8000509@freemail.hu>
Date: Thu, 12 Nov 2009 07:52:51 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] decode_tm6000: fix include path
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The include path is changed from ../lib to ../lib4vl2util .

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 60f784aa071d v4l2-apps/util/decode_tm6000.c
--- a/v4l2-apps/util/decode_tm6000.c	Wed Nov 11 18:28:53 2009 +0100
+++ b/v4l2-apps/util/decode_tm6000.c	Thu Nov 12 07:49:43 2009 +0100
@@ -16,7 +16,7 @@
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-#include "../lib/v4l2_driver.h"
+#include "../libv4l2util/v4l2_driver.h"
 #include <stdio.h>
 #include <string.h>
 #include <argp.h>
