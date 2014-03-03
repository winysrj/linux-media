Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaCCJtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 04:49:25 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/4] [media] DocBook: document DVB DMX_[ADD|REMOVE]_PID
Date: Mon,  3 Mar 2014 06:48:47 -0300
Message-Id: <1393840127-22081-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393840127-22081-1-git-send-email-m.chehab@samsung.com>
References: <1393840127-22081-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those ioctls were added back in 2009, at changeset 1cb662a3144
but were never documented. Fortunately, the original commit is
good enough to serve as the basis for documenting it. Also, the
support for it is done by dmxdev implementation.

So, add a proper documentation for it, based on the description
of the original changeset.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 Documentation/DocBook/media/dvb/demux.xml | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/demux.xml b/Documentation/DocBook/media/dvb/demux.xml
index 86de89cfbd67..c8683d66f059 100644
--- a/Documentation/DocBook/media/dvb/demux.xml
+++ b/Documentation/DocBook/media/dvb/demux.xml
@@ -1042,7 +1042,14 @@ role="subsection"><title>DMX_ADD_PID</title>
 </para>
 <informaltable><tgroup cols="1"><tbody><row><entry
  align="char">
-<para>This ioctl is undocumented. Documentation is welcome.</para>
+<para>This ioctl call allows to add multiple PIDs to a transport stream filter
+previously set up with DMX_SET_PES_FILTER and output equal to DMX_OUT_TSDEMUX_TAP.
+</para></entry></row><row><entry align="char"><para>
+It is used by readers of /dev/dvb/adapterX/demuxY.
+</para></entry></row><row><entry align="char"><para>
+It may be called at any time, i.e. before or after the first filter on the
+shared file descriptor was started. It makes it possible to record multiple
+services without the need to de-multiplex or re-multiplex TS packets.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
 <para>SYNOPSIS
@@ -1075,7 +1082,7 @@ role="subsection"><title>DMX_ADD_PID</title>
 </para>
 </entry><entry
  align="char">
-<para>Undocumented.</para>
+<para>PID number to be filtered.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
@@ -1087,7 +1094,15 @@ role="subsection"><title>DMX_REMOVE_PID</title>
 </para>
 <informaltable><tgroup cols="1"><tbody><row><entry
  align="char">
-<para>This ioctl is undocumented. Documentation is welcome.</para>
+<para>This ioctl call allows to remove a PID when multiple PIDs are set on a
+transport stream filter, e. g. a filter previously set up with output equal to
+DMX_OUT_TSDEMUX_TAP, created via either DMX_SET_PES_FILTER or DMX_ADD_PID.
+</para></entry></row><row><entry align="char"><para>
+It is used by readers of /dev/dvb/adapterX/demuxY.
+</para></entry></row><row><entry align="char"><para>
+It may be called at any time, i.e. before or after the first filter on the
+shared file descriptor was started. It makes it possible to record multiple
+services without the need to de-multiplex or re-multiplex TS packets.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
 <para>SYNOPSIS
@@ -1120,7 +1135,7 @@ role="subsection"><title>DMX_REMOVE_PID</title>
 </para>
 </entry><entry
  align="char">
-<para>Undocumented.</para>
+<para>PID of the PES filter to be removed.</para>
 </entry>
  </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-- 
1.8.5.3

