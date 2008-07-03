Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m63Kir4n013076
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 16:44:53 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m63KibCe012826
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 16:44:38 -0400
Message-ID: <486D3BB4.2060603@hhs.nl>
Date: Thu, 03 Jul 2008 22:51:00 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Content-Type: multipart/mixed; boundary="------------040809090500030304030200"
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: PATCH: libv4l-sonix-license-permission.patch
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------040809090500030304030200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

Add license change (GPL -> LGPL) permission notice, and don't claim copyright
over code I didn't write, instead add copyright header of the original author
(oops)

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------040809090500030304030200
Content-Type: text/x-patch;
 name="libv4l-sonix-license-permission.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="libv4l-sonix-license-permission.patch"

Add license change (GPL -> LGPL) permission notice, and don't claim copyright
over code I didn't write, instead add copyright header of the original author
(oops)

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 4a7326174324 v4l2-apps/lib/libv4l/libv4lconvert/sn9c10x.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/sn9c10x.c	Thu Jul 03 21:59:12 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/sn9c10x.c	Thu Jul 03 22:43:34 2008 +0200
@@ -1,5 +1,6 @@
 /*
-#             (C) 2008 Hans de Goede <j.w.r.degoede@hhs.nl>
+# sonix decoder
+#               Bertrik.Sikken. (C) 2005
 
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU Lesser General Public License as published by
@@ -14,12 +15,13 @@
 # You should have received a copy of the GNU Lesser General Public License
 # along with this program; if not, write to the Free Software
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+# Note this code was originally licensed under the GNU GPL instead of the
+# GNU LGPL, its license has been changed with permission, see the permission
+# mail at the end of this file.
 */
 
 #include "libv4lconvert-priv.h"
-
-/* FIXME FIXME FIXME add permission notice from Bertrik Sikken to release
-   this code (which is his) under the LGPL */
 
 #define CLAMP(x)	((x)<0?0:((x)>255)?255:(x))
 
@@ -197,3 +199,89 @@
 		}
 	}
 }
+
+/*
+Return-Path: <bertrik@sikken.nl>
+Received: from koko.hhs.nl ([145.52.2.16] verified)
+  by hhs.nl (CommuniGate Pro SMTP 4.3.6)
+  with ESMTP id 89132066 for j.w.r.degoede@hhs.nl; Thu, 03 Jul 2008 15:19:55 +0200
+Received: from exim (helo=koko)
+	by koko.hhs.nl with local-smtp (Exim 4.62)
+	(envelope-from <bertrik@sikken.nl>)
+	id 1KEOj5-0000nq-KR
+	for j.w.r.degoede@hhs.nl; Thu, 03 Jul 2008 15:19:55 +0200
+Received: from [192.87.102.69] (port=33783 helo=filter1-ams.mf.surf.net)
+	by koko.hhs.nl with esmtp (Exim 4.62)
+	(envelope-from <bertrik@sikken.nl>)
+	id 1KEOj5-0000nj-7r
+	for j.w.r.degoede@hhs.nl; Thu, 03 Jul 2008 15:19:55 +0200
+Received: from cardassian.kabelfoon.nl (cardassian3.kabelfoon.nl [62.45.45.105])
+	by filter1-ams.mf.surf.net (8.13.8/8.13.8/Debian-3) with ESMTP id m63DJsKW032598
+	for <j.w.r.degoede@hhs.nl>; Thu, 3 Jul 2008 15:19:54 +0200
+Received: from [192.168.1.1] (044-013-045-062.dynamic.caiway.nl [62.45.13.44])
+	by cardassian.kabelfoon.nl (Postfix) with ESMTP id 77761341D9A
+	for <j.w.r.degoede@hhs.nl>; Thu,  3 Jul 2008 15:19:54 +0200 (CEST)
+Message-ID: <486CD1F9.8000307@sikken.nl>
+Date: Thu, 03 Jul 2008 15:19:53 +0200
+From: Bertrik Sikken <bertrik@sikken.nl>
+User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
+MIME-Version: 1.0
+To: Hans de Goede <j.w.r.degoede@hhs.nl>
+Subject: Re: pac207 bayer decompression algorithm license question
+References: <48633F02.3040108@hhs.nl> <4863F611.80104@sikken.nl> <486CC6AF.7050509@hhs.nl>
+In-Reply-To: <486CC6AF.7050509@hhs.nl>
+X-Enigmail-Version: 0.95.6
+Content-Type: text/plain; charset=ISO-8859-1; format=flowed
+Content-Transfer-Encoding: 7bit
+X-Canit-CHI2: 0.00
+X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN)
+X-Spam-Score: 0.00 () [Tag at 8.00] 
+X-CanItPRO-Stream: hhs:j.w.r.degoede@hhs.nl (inherits from hhs:default,base:default)
+X-Canit-Stats-ID: 90943081 - 6a9ff19e8165
+X-Scanned-By: CanIt (www . roaringpenguin . com) on 192.87.102.69
+X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 03072008 #811719, status: clean
+
+-----BEGIN PGP SIGNED MESSAGE-----
+Hash: SHA1
+
+Hans de Goede wrote:
+| Bertrik Sikken wrote:
+|> Hallo Hans,
+|>
+|> Hans de Goede wrote:
+|>> I would like to also add support for decompressing the pac207's
+|>> compressed
+|>> bayer to this lib (and remove it from the kernel driver) and I've
+|>> heard from Thomas Kaiser that you are a co-author of the
+|>> decompression code. In order to add support for decompressing pac207
+|>> compressed bayer to libv4l I need
+|>> permission to relicense the decompression code under the LGPL
+|>> (version 2 or later).
+|>>
+|>> Can you give me permission for this?
+|>
+|> Ja, vind ik goed.
+|>
+|
+| Thanks!
+|
+| I'm currently working on adding support for the sn9c10x bayer
+| compression to libv4l too, and I noticed this was written by you too.
+|
+| May I have your permission to relicense the sn9c10x bayer decompression
+| code under the LGPL (version 2 or later)?
+
+I hereby grant you permission to relicense the sn9c10x bayer
+decompression code under the LGPL (version 2 or later).
+
+Kind regards,
+Bertrik
+-----BEGIN PGP SIGNATURE-----
+Version: GnuPG v1.4.7 (MingW32)
+Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
+
+iD8DBQFIbNH5ETD6mlrWxPURAipvAJ9sv1ZpHyb81NMFejr6x0wqHX3i7QCfRDoB
+jZi2e5lUjEh5KvS0dqXbi9I=
+=KQfR
+-----END PGP SIGNATURE-----
+*/

--------------040809090500030304030200
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------040809090500030304030200--
