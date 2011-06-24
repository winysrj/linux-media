Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab1FXXLy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 19:11:54 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5ONBs1a031149
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 24 Jun 2011 19:11:54 -0400
Received: from [10.36.5.45] (vpn1-5-45.ams2.redhat.com [10.36.5.45])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p5ONBqS6022505
	for <linux-media@vger.kernel.org>; Fri, 24 Jun 2011 19:11:53 -0400
Message-ID: <4E0519B7.3000304@redhat.com>
Date: Fri, 24 Jun 2011 20:11:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't
 exist
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Currently, -EINVAL is used to return either when an IOCTL is not
implemented, or if the ioctl was not implemented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/Makefile           |    1 +
 Documentation/DocBook/media/v4l/func-ioctl.xml |   17 +++++++++--------
 drivers/media/video/v4l2-ioctl.c               |    4 ++--
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 8cb27f3..93722da 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -117,6 +117,7 @@ ERRORS = \
 	EPERM \
 	ERANGE \
 	EPIPE \
+	ENOIOCTLCMD \
 
 ESCAPE = \
 	-e "s/&/\\&amp;/g" \
diff --git a/Documentation/DocBook/media/v4l/func-ioctl.xml b/Documentation/DocBook/media/v4l/func-ioctl.xml
index b60fd37..0c97ba9 100644
--- a/Documentation/DocBook/media/v4l/func-ioctl.xml
+++ b/Documentation/DocBook/media/v4l/func-ioctl.xml
@@ -132,14 +132,15 @@ complete the request.</para>
 &VIDIOC-S-CTRL; ioctl to a value which is out of bounds.</para>
 	</listitem>
       </varlistentry>
+      <varlistentry>
+	<term><errorcode>ENOIOCTLCMD</errorcode></term>
+	<listitem>
+	  <para>The application attempted to use a non-existent ioctl. This is returned by the V4L2 core only.
+		Applications should be able to handle this error code, in order to detect if a new ioctl is
+		not implemented at the current Kernel version. Kernel versions lower than 3.0 returns EINVAL to
+		non-existing ioctl's.</para>
+	</listitem>
+      </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 61ac6bf..a0a2466 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -543,12 +543,12 @@ static long __video_do_ioctl(struct file *file,
 	struct v4l2_fh *vfh = NULL;
 	struct v4l2_format f_copy;
 	int use_fh_prio = 0;
-	long ret = -EINVAL;
+	long ret = -ENOIOCTLCMD;
 
 	if (ops == NULL) {
 		printk(KERN_WARNING "videodev: \"%s\" has no ioctl_ops.\n",
 				vfd->name);
-		return -EINVAL;
+		return ret;
 	}
 
 	if ((vfd->debug & V4L2_DEBUG_IOCTL) &&

