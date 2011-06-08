Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:38669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab1FHUZV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:21 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KPLPi016676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:21 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Um024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:20 -0400
Date: Wed, 8 Jun 2011 17:23:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/13] [media] DocBook/net.xml: Synchronize Network data
 structure
Message-ID: <20110608172307.37796373@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There's no documentation at all for the DVB net API. Still, better to
remove a few warnings about the missing symbols. So, add the net data
structure inside the net.xml. Now, only the ioctl documentation is missed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 0b055ad..ab31254 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -148,11 +148,12 @@ DVB_DOCUMENTED = \
 	-e "s,\(struct\s\+\)\([a-z0-9_]\+\)\(\s\+{\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,\(}\s\+\)\([a-z0-9_]\+_t\+\),\1\<link linkend=\"\2\">\2\<\/link\>,g" \
 	-e "s,\(define\s\+\)\(DTV_[A-Z0-9_]\+\)\(\s\+[0-9]\+\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
-	-e "s,<link linkend=\".*\">\(DTV_IOCTL_MAX_MSGS\|dtv_cmds_h\)<\/link>,\1,g" \
+	-e "s,<link\s\+linkend=\".*\">\(DTV_IOCTL_MAX_MSGS\|dtv_cmds_h\|__.*_old\)<\/link>,\1,g" \
 	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" \
 	-e "s,\(audio-mixer\|audio-karaoke\|audio-status\|ca-slot-info\|ca-descr-info\|ca-caps\|ca-msg\|ca-descr\|ca-pid\|dmx-filter\|dmx-caps\)-t,\1,g" \
 	-e "s,DTV-ISDBT-LAYER[A-C],DTV-ISDBT-LAYER,g" \
 	-e "s,\(define\s\+\)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
+	-e "s,<link\s\+linkend=\".*\">\(__.*_OLD\)<\/link>,\1,g" \
 
 #
 # Media targets and dependencies
diff --git a/Documentation/DocBook/media/dvb/net.xml b/Documentation/DocBook/media/dvb/net.xml
index 94e388d..67d37e5 100644
--- a/Documentation/DocBook/media/dvb/net.xml
+++ b/Documentation/DocBook/media/dvb/net.xml
@@ -7,6 +7,23 @@ application.
 </para>
 <section id="dvb_net_types">
 <title>DVB Net Data Types</title>
+
+<section id="dvb-net-if">
+<title>struct dvb_net_if</title>
+<programlisting>
+struct dvb_net_if {
+	__u16 pid;
+	__u16 if_num;
+	__u8  feedtype;
+#define DVB_NET_FEEDTYPE_MPE 0	/&#x22C6; multi protocol encapsulation &#x22C6;/
+#define DVB_NET_FEEDTYPE_ULE 1	/&#x22C6; ultra lightweight encapsulation &#x22C6;/
+};
+</programlisting>
+</section>
+
+</section>
+<section id="net_fcalls">
+<title>DVB net Function Calls</title>
 <para>To be written&#x2026;
 </para>
 </section>
-- 
1.7.1


