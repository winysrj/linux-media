Return-path: <mchehab@localhost>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45435 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab1GJSOl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 14:14:41 -0400
Received: by iwn6 with SMTP id 6so3056403iwn.19
        for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 11:14:41 -0700 (PDT)
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Sun, 10 Jul 2011 18:14:21 +0000
Message-ID: <CAH9NwWc+zLqPyBcC99wbsbNkdjzMFfn2zuGm1VfmZctgpOGMew@mail.gmail.com>
Subject: [PATCH 2/3] Document 8-bit and 16-bit YCrCb media bus pixel codes
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Signed-off-by: Christian Gmeiner
---
diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 49c532e..18e30b0 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -2565,5 +2565,43 @@
        </tgroup>
       </table>
     </section>
+
+    <section>
+      <title>YCrCb Formats</title>
+
+      <para>YCbCr represents colors as a combination of three values:
+      <itemizedlist>
+       <listitem><para>Y - the luminosity (roughly the
brightness)</para></listitem>
+       <listitem><para>Cb - the chrominance of the blue
primary</para></listitem>
+       <listitem><para>Cr - the chrominance of the red
primary</para></listitem>
+      </itemizedlist>
+      </para>
+
+      <para>The following table lists existing YCrCb compressed formats.</para>
+
+      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-ycrcb">
+       <title>YCrCb Formats</title>
+       <tgroup cols="2">
+         <colspec colname="id" align="left" />
+         <colspec colname="code" align="left"/>
+         <thead>
+           <row>
+             <entry>Identifier</entry>
+             <entry>Code</entry>
+           </row>
+         </thead>
+         <tbody valign="top">
+           <row id="V4L2_MBUS_FMT_YCRCB_1X8">
+             <entry>V4L2_MBUS_FMT_YCRCB_1X8</entry>
+             <entry>0x5001</entry>
+           </row>
+           <row id="V4L2_MBUS_FMT_YCRCB_1X16">
+             <entry>V4L2_MBUS_FMT_YCRCB_1X16</entry>
+             <entry>0x5002</entry>
+           </row>
+         </tbody>
+       </tgroup>
+       </table>
+    </section>
   </section>
 </section>
--
1.7.6
