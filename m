Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:55987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab0L0LnP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 06:43:15 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRBhFNd027157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 06:43:15 -0500
Received: from gaivota (vpn-11-156.rdu.redhat.com [10.11.11.156])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRBd1iQ001764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 06:43:14 -0500
Date: Mon, 27 Dec 2010 09:38:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/6] [media] Fix videodev.h references at the V4L DocBook
Message-ID: <20101227093836.20118c91@gaivota>
In-Reply-To: <cover.1293449547.git.mchehab@redhat.com>
References: <cover.1293449547.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/v4l/func-ioctl.xml b/Documentation/DocBook/v4l/func-ioctl.xml
index 00f9690..b60fd37 100644
--- a/Documentation/DocBook/v4l/func-ioctl.xml
+++ b/Documentation/DocBook/v4l/func-ioctl.xml
@@ -34,8 +34,7 @@
       <varlistentry>
 	<term><parameter>request</parameter></term>
 	<listitem>
-	  <para>V4L2 ioctl request code as defined in the <link
-linkend="videodev">videodev.h</link> header file, for example
+	  <para>V4L2 ioctl request code as defined in the <filename>videodev2.h</filename> header file, for example
 VIDIOC_QUERYCAP.</para>
 	</listitem>
       </varlistentry>
@@ -57,7 +56,7 @@ file descriptor. An ioctl <parameter>request</parameter> has encoded
 in it whether the argument is an input, output or read/write
 parameter, and the size of the argument <parameter>argp</parameter> in
 bytes. Macros and defines specifying V4L2 ioctl requests are located
-in the <link linkend="videodev">videodev.h</link> header file.
+in the <filename>videodev2.h</filename> header file.
 Applications should use their own copy, not include the version in the
 kernel sources on the system they compile on. All V4L2 ioctl requests,
 their respective function and parameters are specified in <xref
diff --git a/Documentation/DocBook/v4l/pixfmt.xml b/Documentation/DocBook/v4l/pixfmt.xml
index d7c4671..cfffc88 100644
--- a/Documentation/DocBook/v4l/pixfmt.xml
+++ b/Documentation/DocBook/v4l/pixfmt.xml
@@ -142,8 +142,8 @@ leftmost pixel of the second row from the top, and so on. The last row
 has just as many pad bytes after it as the other rows.</para>
 
     <para>In V4L2 each format has an identifier which looks like
-<constant>PIX_FMT_XXX</constant>, defined in the <link
-linkend="videodev">videodev.h</link> header file. These identifiers
+<constant>PIX_FMT_XXX</constant>, defined in the <filename>videodev2.h</filename>
+header file. These identifiers
 represent <link linkend="v4l2-fourcc">four character codes</link>
 which are also listed below, however they are not the same as those
 used in the Windows world.</para>
-- 
1.7.3.4


