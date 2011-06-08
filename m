Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:4542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab1FHBqI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:46:08 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581k8Wx006749
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:08 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jncD007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:07 -0400
Date: Tue, 7 Jun 2011 22:45:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 12/15] [media] DocBook: Finish synchronizing the frontend
 API
Message-ID: <20110607224539.0f6579af@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Remove the remaining:
	Error: no ID for constraint linkend:

With this patch, the dvb frontend API matches the current
dvb core implementation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index f2216b0..eb64087 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -73,7 +73,7 @@ ENUMS = \
 
 STRUCTS = \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/videodev2.h) \
-	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/dvb/frontend.h) \
+	$(shell perl -ne 'print "$$1 " if (!/dtv\_cmds\_h/ && /^struct\s+([^\s]+)\s+/)' $(srctree)/include/linux/dvb/frontend.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-subdev.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h)
@@ -124,10 +124,10 @@ DVB_DOCUMENTED = \
 	-e "s,\(struct\s\+\)\([a-z0-9_]\+\)\(\s\+{\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,\(}\s\+\)\([a-z0-9_]\+_t\+\),\1\<link linkend=\"\2\">\2\<\/link\>,g" \
 	-e "s,\(define\s\+\)\(DTV_[A-Z0-9_]\+\)\(\s\+[0-9]\+\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
+	-e "s,<link linkend=\".*\">\(DTV_IOCTL_MAX_MSGS\|dtv_cmds_h\)<\/link>,\1,g" \
 	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" \
 	-e "s,DTV-ISDBT-LAYER[A-C],DTV-ISDBT-LAYER,g" \
 	-e "s,\(define\s\+\)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
-#	-e "s,\(\s\+\)\(FE_[A-Z0-9_]\+\)\([\s\=\,]*\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 
 #
 # Media targets and dependencies
diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 4c45f3c..64151bb 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -7,6 +7,8 @@ the capability ioctls weren't implemented yet via the new way.</para>
 <para>The typical usage for the <constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant>
 API is to replace the ioctl's were the <link linkend="dvb-frontend-parameters">
 struct <constant>dvb_frontend_parameters</constant></link> were used.</para>
+<section id="dtv-property">
+<title>DTV property type</title>
 <programlisting>
 /* Reserved fields should be set to 0 */
 struct dtv_property {
@@ -25,12 +27,17 @@ struct dtv_property {
 
 /* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
 #define DTV_IOCTL_MAX_MSGS 64
-
+</programlisting>
+</section>
+<section id="dtv-properties">
+<title>DTV properties type</title>
+<programlisting>
 struct dtv_properties {
 	__u32 num;
 	struct dtv_property *props;
 };
 </programlisting>
+</section>
 
 <section id="FE_GET_PROPERTY">
 <title>FE_GET_PROPERTY</title>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 086e62b..1417d50 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -140,7 +140,7 @@ a specific frontend type.</para>
 	};
 </programlisting>
 </section>
-<section role="subsection">
+<section role="subsection" id="dvb-diseqc-slave-reply">
 <title>diseqc slave reply</title>
 
 <para>A reply to the frontend from DiSEqC 2.0 capable equipment.</para>
-- 
1.7.1


