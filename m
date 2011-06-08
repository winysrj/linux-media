Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab1FHUZL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:11 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KPBjt012089
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:11 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Ug024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:10 -0400
Date: Wed, 8 Jun 2011 17:23:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/13] [media] DocBook: Document AUDIO_CONTINUE ioctl
Message-ID: <20110608172301.1a7408f4@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Although this ioctl is only used at the av7110 driver, it is not
described at the API docbook. Yet, AUDIO_PAUSE ioctl description
somewhat describes it. Fill the gap by using the information there
and by looking inside av7110 implementation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/audio.xml b/Documentation/DocBook/media/dvb/audio.xml
index b3d3895..c27fe73 100644
--- a/Documentation/DocBook/media/dvb/audio.xml
+++ b/Documentation/DocBook/media/dvb/audio.xml
@@ -524,6 +524,63 @@ role="subsection"><title>AUDIO_PAUSE</title>
 </entry>
  </row></tbody></tgroup></informaltable>
 
+
+</section><section id="AUDIO_CONTINUE"
+role="subsection"><title>AUDIO_CONTINUE</title>
+<para>DESCRIPTION
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>This ioctl restarts the decoding and playing process previously paused
+with AUDIO_PAUSE command.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>It only works if the stream were previously stopped with AUDIO_PAUSE</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>SYNOPSIS
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>int ioctl(int fd, int request = AUDIO_CONTINUE);</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>PARAMETERS
+</para>
+<informaltable><tgroup cols="2"><tbody><row><entry
+ align="char">
+<para>int fd</para>
+</entry><entry
+ align="char">
+<para>File descriptor returned by a previous call to open().</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>int request</para>
+</entry><entry
+ align="char">
+<para>Equals AUDIO_CONTINUE for this command.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>ERRORS
+</para>
+<informaltable><tgroup cols="2"><tbody><row><entry
+ align="char">
+<para>EBADF</para>
+</entry><entry
+ align="char">
+<para>fd is not a valid open file descriptor.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>EINTERNAL</para>
+</entry><entry
+ align="char">
+<para>Internal error.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
 </section><section id="AUDIO_SELECT_SOURCE"
 role="subsection"><title>AUDIO_SELECT_SOURCE</title>
 <para>DESCRIPTION
-- 
1.7.1


