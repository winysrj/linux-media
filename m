Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vps1.tull.net ([66.180.172.116])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <nick-linuxtv@nick-andrew.net>) id 1L8Z7P-00023d-SJ
	for linux-dvb@linuxtv.org; Fri, 05 Dec 2008 12:45:14 +0100
MIME-Version: 1.0
Message-Id: <1a1281c692af423bc751.1228477485@marcab.local.tull.net>
In-Reply-To: <patchbomb.1228477483@marcab.local.tull.net>
Date: Fri, 05 Dec 2008 22:44:45 +1100
From: Nick Andrew <nick-linuxtv@nick-andrew.net>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH 2 of 2] Fix spelling of 'lose'
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

# HG changeset patch
# User Nick Andrew <nick@nick-andrew.net>
# Date 1228476802 -39600
# Node ID 1a1281c692af423bc75106daaba7b890da6728dc
# Parent  6810946716817a6c1172912541b9e348b1a44401
Fix spelling of 'lose'

Change 'loose' to 'lose' where the latter is intended.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>

diff -r 681094671681 -r 1a1281c692af v4l2-apps/lib/libv4l/ChangeLog
--- a/v4l2-apps/lib/libv4l/ChangeLog	Fri Dec 05 22:31:44 2008 +1100
+++ b/v4l2-apps/lib/libv4l/ChangeLog	Fri Dec 05 22:33:22 2008 +1100
@@ -182,7 +182,7 @@
 * Do not get in the way of mmap calls made by V4L2 applications
 * Fix swapping of red and blue in bayer -> bgr24 decode routine
 * Remember the v4l1 palette asked for with SPICT and return that, as
-  otherwise we loose information when going v4l1 -> v4l2 -> v4l1, for example
+  otherwise we lose information when going v4l1 -> v4l2 -> v4l1, for example
   YUV420P becomes YUV420, which are separate in v4l1.
 
 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
