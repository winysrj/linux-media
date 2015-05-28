Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbbE1Vtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Masanari Iida <standby24x7@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 02/35] DocBook: add a note about the ALSA API
Date: Thu, 28 May 2015 18:49:05 -0300
Message-Id: <d36805dafed09c888475beb0964ba4e08044063a.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Docbook mistakenly makes to believe that all needed APIs for
media devices are there. Add a note there pointing that some
sub-devices are actually be controlled via ALSA API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 60d0c877ea16..c71ebe3277b1 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -72,6 +72,9 @@
 		<xref linkend="fe-delivery-system-t" />.</para>
 	<para>The third part covers the Remote Controller API.</para>
 	<para>The fourth part covers the Media Controller API.</para>
+	<para>It should also be noticed that a media device may also have audio
+	      components, like mixers, PCM capture, PCM playback, etc, with
+	      are controlled via ALSA API.</para>
 	<para>For additional information and for the latest development code,
 		see: <ulink url="http://linuxtv.org">http://linuxtv.org</ulink>.</para>
 	<para>For discussing improvements, reporting troubles, sending new drivers, etc, please mail to: <ulink url="http://vger.kernel.org/vger-lists.html#linux-media">Linux Media Mailing List (LMML).</ulink>.</para>
-- 
2.4.1

