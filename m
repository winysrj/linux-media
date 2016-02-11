Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:35589 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbcBKXlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 18:41:47 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com,
	tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	prabhakar.csengg@gmail.com, sw0312.kim@samsung.com,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com,
	ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com,
	dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk,
	linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com,
	nenggun.kim@samsung.com, j.anaszewski@samsung.com,
	geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 01/22] [media] Docbook: media-types.xml: Add ALSA Media Controller Intf types
Date: Thu, 11 Feb 2016 16:41:17 -0700
Message-Id: <363a459c08a1fcaf04052d7f2af05f1dd43de58e.1455233152.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ALSA Media Controller Intf types

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 Documentation/DocBook/media/v4l/media-types.xml | 40 +++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
index 751c3d0..3730967 100644
--- a/Documentation/DocBook/media/v4l/media-types.xml
+++ b/Documentation/DocBook/media/v4l/media-types.xml
@@ -193,6 +193,46 @@
 	    <entry>Device node interface for Software Defined Radio (V4L)</entry>
 	    <entry>typically, /dev/swradio?</entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_ALSA_PCM_CAPTURE</constant></entry>
+	    <entry>Device node interface for ASLA PCM Capture</entry>
+	    <entry>typically, /dev/snd/pcmC?D?c</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_ALSA_PCM_PLAYBACK</constant></entry>
+	    <entry>Device node interface for ASLA PCM Playback</entry>
+	    <entry>typically, /dev/snd/pcmC?D?p</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_ALSA_CONTROL</constant></entry>
+	    <entry>Device node interface for ASLA Control</entry>
+	    <entry>typically, /dev/snd/controlC?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_ALSA_COMPRESS</constant></entry>
+	    <entry>Device node interface for ASLA Compress</entry>
+	    <entry>typically, /dev/snd/compr?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_ALSA_RAWMIDI</constant></entry>
+	    <entry>Device node interface for ASLA Raw MIDI</entry>
+	    <entry>typically, /dev/snd/midi?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_ALSA_HWDEP</constant></entry>
+	    <entry>Device node interface for ASLA Hardware Dependent</entry>
+	    <entry>typically, /dev/snd/hwC?D?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_ALSA_SEQUENCER</constant></entry>
+	    <entry>Device node interface for ASLA Sequencer</entry>
+	    <entry>typically, /dev/snd/seq</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_ALSA_TIMER</constant></entry>
+	    <entry>Device node interface for ASLA Timer</entry>
+	    <entry>typically, /dev/snd/timer</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
2.5.0

