Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab1FZNXE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2011 09:23:04 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5QDN4pr018038
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 26 Jun 2011 09:23:04 -0400
Received: from [10.11.8.3] (vpn-8-3.rdu.redhat.com [10.11.8.3])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p5QDN3vJ029492
	for <linux-media@vger.kernel.org>; Sun, 26 Jun 2011 09:23:03 -0400
Message-ID: <4E0732B6.7080406@redhat.com>
Date: Sun, 26 Jun 2011 10:23:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] DocBook/v4l: Remove references to the old V4L1 compat
 layer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The old V4L1 Kernel copatibility layer was removed, but the API
spec still says that it is there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 9f7cd4f..b010ac6 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -10,12 +10,10 @@ driver writers to port or update their code.</para>
     <para>The Video For Linux API was first introduced in Linux 2.1 to
 unify and replace various TV and radio device related interfaces,
 developed independently by driver writers in prior years. Starting
-with Linux 2.5 the much improved V4L2 API replaces the V4L API,
-although existing drivers will continue to support V4L applications in
-the future, either directly or through the V4L2 compatibility layer in
-the <filename>videodev</filename> kernel module translating ioctls on
-the fly. For a transition period not all drivers will support the V4L2
-API.</para>
+with Linux 2.5 the much improved V4L2 API replaces the V4L API.
+The support for the old V4L calls were removed from Kernel, but the
+library <xref linkend="libv4l" /> supports the conversion of a V4L
+API system call into a V4L2 one.</para>
 
     <section>
       <title>Opening and Closing Devices</title>
@@ -84,12 +82,7 @@ not compatible with V4L or V4L2.</para> </footnote>,
 device file. V4L2 drivers <emphasis>may</emphasis> support multiple
 opens, see <xref linkend="open" /> for details and consequences.</para>
 
-      <para>V4L drivers respond to V4L2 ioctls with an &EINVAL;. The
-compatibility layer in the V4L2 <filename>videodev</filename> module
-can translate V4L ioctl requests to their V4L2 counterpart, however a
-V4L2 driver usually needs more preparation to become fully V4L
-compatible. This is covered in more detail in <xref
-	  linkend="driver" />.</para>
+      <para>V4L drivers respond to V4L2 ioctls with an &EINVAL;.</para>
     </section>
 
     <section>
