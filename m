Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:56661 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbbBKTcq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 14:32:46 -0500
Received: by mail-vc0-f178.google.com with SMTP id hq11so1958894vcb.9
        for <linux-media@vger.kernel.org>; Wed, 11 Feb 2015 11:32:45 -0800 (PST)
Received: from mail-vc0-f174.google.com (mail-vc0-f174.google.com. [209.85.220.174])
        by mx.google.com with ESMTPSA id ey1sm219885vdb.23.2015.02.11.11.32.45
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Feb 2015 11:32:45 -0800 (PST)
Received: by mail-vc0-f174.google.com with SMTP id id10so1991141vcb.5
        for <linux-media@vger.kernel.org>; Wed, 11 Feb 2015 11:32:44 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Feb 2015 11:32:44 -0800
Message-ID: <CAPUS087-jTACBQbH=Kqby3S52Ff4kKoswRuubUoC6Y=OoNz2yQ@mail.gmail.com>
Subject: [PATCH] media: docs: Correct NV{12,21}/M pixel formats, chroma
 samples used.
From: Miguel Casas-Sanchez <mcasas@chromium.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Docos says for these pixel formats:

start... : Cb00 Cr00 Cb01 Cr01
start... : Cb10 Cr10 Cb11 Cr11

whereas it should read:

start... : Cb00 Cr00 Cb11 Cr11
start... : Cb20 Cr20 Cb21 Cr21

where ... depends on the exact multi/single planar format.

See e.g. http://linuxtv.org/downloads/v4l-dvb-apis/re30.html
and http://linuxtv.org/downloads/v4l-dvb-apis/re31.html


Signed-off-by: Miguel Casas-Sanchez <mcasas@chromium.org>
---
 Documentation/DocBook/media/v4l/pixfmt-nv12.xml  |  8 ++++----
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml | 12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
b/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
index 84dd4fd..4148696 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
@@ -73,15 +73,15 @@ pixel image</title>
                      <entry>start&nbsp;+&nbsp;16:</entry>
                      <entry>Cb<subscript>00</subscript></entry>
                      <entry>Cr<subscript>00</subscript></entry>
-                     <entry>Cb<subscript>01</subscript></entry>
-                     <entry>Cr<subscript>01</subscript></entry>
+                     <entry>Cb<subscript>02</subscript></entry>
+                     <entry>Cr<subscript>02</subscript></entry>
                    </row>
                    <row>
                      <entry>start&nbsp;+&nbsp;20:</entry>
                      <entry>Cb<subscript>10</subscript></entry>
                      <entry>Cr<subscript>10</subscript></entry>
-                     <entry>Cb<subscript>11</subscript></entry>
-                     <entry>Cr<subscript>11</subscript></entry>
+                     <entry>Cb<subscript>22</subscript></entry>
+                     <entry>Cr<subscript>22</subscript></entry>
                    </row>
                  </tbody>
                </tgroup>
diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
index f3a3d45..e0a35ea 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
@@ -83,15 +83,15 @@ CbCr plane has as many pad bytes after its rows.</para>
                      <entry>start1&nbsp;+&nbsp;0:</entry>
                      <entry>Cb<subscript>00</subscript></entry>
                      <entry>Cr<subscript>00</subscript></entry>
-                     <entry>Cb<subscript>01</subscript></entry>
-                     <entry>Cr<subscript>01</subscript></entry>
+                     <entry>Cb<subscript>02</subscript></entry>
+                     <entry>Cr<subscript>02</subscript></entry>
                    </row>
                    <row>
                      <entry>start1&nbsp;+&nbsp;4:</entry>
-                     <entry>Cb<subscript>10</subscript></entry>
-                     <entry>Cr<subscript>10</subscript></entry>
-                     <entry>Cb<subscript>11</subscript></entry>
-                     <entry>Cr<subscript>11</subscript></entry>
+                     <entry>Cb<subscript>20</subscript></entry>
+                     <entry>Cr<subscript>20</subscript></entry>
+                     <entry>Cb<subscript>22</subscript></entry>
+                     <entry>Cr<subscript>22</subscript></entry>
                    </row>
                  </tbody>
                </tgroup>

--
2.2.0.rc0.207.ga3a616c
