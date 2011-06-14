Return-path: <mchehab@pedra>
Received: from canardo.mork.no ([148.122.252.1]:42541 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab1FNM7S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 08:59:18 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH] [media] DVB API: Mention the dvbM device
Date: Tue, 14 Jun 2011 14:59:14 +0200
Message-Id: <1308056354-9179-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
Don't know why it was left out, but I found it very confusing when
it is mention further down.

However, this does make the next paragraph wrong, as there is no
"dvr" specific include file.

 Documentation/DocBook/media/dvb/intro.xml |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
index 8223639..c75dc7c 100644
--- a/Documentation/DocBook/media/dvb/intro.xml
+++ b/Documentation/DocBook/media/dvb/intro.xml
@@ -154,6 +154,10 @@ are called:</para>
 </listitem>
  <listitem>
 
+<para><emphasis role="tt">/dev/dvb/adapterN/dvrM</emphasis>,</para>
+</listitem>
+ <listitem>
+
 <para><emphasis role="tt">/dev/dvb/adapterN/caM</emphasis>,</para></listitem></itemizedlist>
 
 <para>where N enumerates the DVB PCI cards in a system starting
-- 
1.7.2.5

