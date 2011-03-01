Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab1CANUT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 08:20:19 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p21DKINI026050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Mar 2011 08:20:19 -0500
Received: from pedra (vpn-225-140.phx2.redhat.com [10.3.225.140])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p21DIEb8025546
	for <linux-media@vger.kernel.org>; Tue, 1 Mar 2011 08:20:18 -0500
Date: Tue, 1 Mar 2011 10:17:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] [media] DocBook: Document the removal of the old
 VIDIOC_*_OLD ioctls
Message-ID: <20110301101759.31f56a58@pedra>
In-Reply-To: <cover.1298985234.git.mchehab@redhat.com>
References: <cover.1298985234.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Those ioctls passed away. Properly documented it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/v4l/compat.xml b/Documentation/DocBook/v4l/compat.xml
index 223c24c..4d74bf2 100644
--- a/Documentation/DocBook/v4l/compat.xml
+++ b/Documentation/DocBook/v4l/compat.xml
@@ -1711,8 +1711,8 @@ ioctl would enumerate the available audio inputs. An ioctl to
 determine the current audio input, if more than one combines with the
 current video input, did not exist. So
 <constant>VIDIOC_G_AUDIO</constant> was renamed to
-<constant>VIDIOC_G_AUDIO_OLD</constant>, this ioctl will be removed in
-the future. The &VIDIOC-ENUMAUDIO; ioctl was added to enumerate
+<constant>VIDIOC_G_AUDIO_OLD</constant>, this ioctl was removed on
+Kernel 2.6.39. The &VIDIOC-ENUMAUDIO; ioctl was added to enumerate
 audio inputs, while &VIDIOC-G-AUDIO; now reports the current audio
 input.</para>
 	  <para>The same changes were made to &VIDIOC-G-AUDOUT; and
@@ -1726,7 +1726,7 @@ must be updated to successfully compile again.</para>
 	  <para>The &VIDIOC-OVERLAY; ioctl was incorrectly defined with
 write-read parameter. It was changed to write-only, while the write-read
 version was renamed to <constant>VIDIOC_OVERLAY_OLD</constant>. The old
-ioctl will be removed in the future. Until further the "videodev"
+ioctl was removed on Kernel 2.6.39. Until further the "videodev"
 kernel module will automatically translate to the new version, so drivers
 must be recompiled, but not applications.</para>
 	</listitem>
@@ -1744,7 +1744,7 @@ surface can be seen.</para>
 defined with write-only parameter, inconsistent with other ioctls
 modifying their argument. They were changed to write-read, while a
 <constant>_OLD</constant> suffix was added to the write-only versions.
-The old ioctls will be removed in the future. Drivers and
+The old ioctls were removed on Kernel 2.6.39. Drivers and
 applications assuming a constant parameter need an update.</para>
 	</listitem>
       </orderedlist>
@@ -1815,8 +1815,8 @@ yet to be addressed, for details see <xref
 	  <para>The &VIDIOC-CROPCAP; ioctl was incorrectly defined
 with read-only parameter. It is now defined as write-read ioctl, while
 the read-only version was renamed to
-<constant>VIDIOC_CROPCAP_OLD</constant>. The old ioctl will be removed
-in the future.</para>
+<constant>VIDIOC_CROPCAP_OLD</constant>. The old ioctl was removed
+on Kernel 2.6.39.</para>
 	</listitem>
       </orderedlist>
     </section>
@@ -2364,6 +2364,14 @@ that used it. It was originally scheduled for removal in 2.6.35.
         </listitem>
       </orderedlist>
     </section>
+    <section>
+      <title>V4L2 in Linux 2.6.39</title>
+      <orderedlist>
+        <listitem>
+          <para>The old VIDIOC_*_OLD symbols and V4L1 support were removed.</para>
+        </listitem>
+      </orderedlist>
+    </section>
 
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
-- 
1.7.1

