Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.wut.de ([194.77.229.25]:54427 "EHLO mail.wut.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965348Ab1JGOuW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Oct 2011 10:50:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.wut.de (Postfix) with ESMTP id DEC88C44B6
	for <linux-media@vger.kernel.org>; Fri,  7 Oct 2011 16:34:05 +0200 (CEST)
Received: from [10.40.33.3] (WSKK3.wtintern.de [10.40.33.3])
	by mail.wut.de (Postfix) with ESMTPA id 27918C43C5
	for <linux-media@vger.kernel.org>; Fri,  7 Oct 2011 16:33:57 +0200 (CEST)
Message-ID: <4E8F0DD9.9070402@wut.de>
Date: Fri, 07 Oct 2011 16:34:01 +0200
From: =?ISO-8859-15?Q?Markus_K=F6nigshaus?= <m.koenigshaus@wut.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Bug in xawtv with libjpeg v8
Content-Type: multipart/mixed;
 boundary="------------010001070406060405020804"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010001070406060405020804
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Using streamer from xawtv-3.102 segfaults with jpeg-output and libjpeg 
v8. Attached patch will resolve the problem.

Regards, Markus

-- Unsere Aussagen koennen Irrtuemer und Missverstaendnisse enthalten.
Bitte pruefen Sie die Aussagen fuer Ihren Fall, bevor Sie Entscheidungen 
auf Grundlage dieser Aussagen treffen.
Wiesemann & Theis GmbH, Porschestr. 12, D-42279 Wuppertal
Geschaeftsfuehrer: Dipl.-Ing. Ruediger Theis
Registergericht: Amtsgericht Wuppertal, HRB 6377 
Tel. +49-202/2680-0, Fax +49-202/2680-265, http://www.wut.de
--------------010001070406060405020804
Content-Type: text/x-patch;
 name="xawtv-3.102-conv-mjpeg_c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xawtv-3.102-conv-mjpeg_c.patch"

from https://bugs.gentoo.org/show_bug.cgi?id=294488
[...]
explicitly set do_fancy_downsampling to FALSE 

Apparently, when settings dinfo.raw_data_in,
previous version jpeg automatically set dinfo.do_fancy_downsampling to
FALSE. Newer versions (since 7) of media-libs/jpeg do not do that anymore and
the program must do it explicitly (although I have not found any documentation
to that effect). 

Compile tested only, but a similar fix in mjpegtools (but output rather than
input) works.
--- xawtv-3.102.org/libng/plugins/conv-mjpeg.c	2011-09-05 19:26:02.000000000 +0200
+++ xawtv-3.102/libng/plugins/conv-mjpeg.c	2011-10-07 15:57:52.413003003 +0200
@@ -229,6 +229,7 @@
     jpeg_set_quality(&h->mjpg_cinfo, ng_jpeg_quality, TRUE);
 
     h->mjpg_cinfo.raw_data_in = TRUE;
+    h->mjpg_cinfo.do_fancy_downsampling = FALSE;  // fix segfaulst with libjpeg v7++
     jpeg_set_colorspace(&h->mjpg_cinfo,JCS_YCbCr);
 
     h->mjpg_ptrs[0] = malloc(h->fmt.height*sizeof(char*));

--------------010001070406060405020804--
