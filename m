Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51422 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbbE1Vtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org
Subject: [PATCH 30/35] DocBook: better organize the function descriptions for frontend
Date: Thu, 28 May 2015 18:49:33 -0300
Message-Id: <3462ce7ca1acea2b618187de16cf202e01f557d4.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the function ioctl definitions to the end of the chapter,
at their importance. That makes the document better organized,
as the DVB frontend system call index will look like:

	open()
	close()
	ioctl FE_GET_INFO — Query DVB frontend capabilities and returns information about the front-end. This call only requires read-only access to the device
	ioctl FE_READ_STATUS — Returns status information about the front-end. This call only requires read-only access to the device
	ioctl FE_SET_PROPERTY, FE_GET_PROPERTY — FE_SET_PROPERTY sets one or more frontend properties. FE_GET_PROPERTY returns one or more frontend properties.
	ioctl FE_DISEQC_RESET_OVERLOAD — Restores the power to the antenna subsystem, if it was powered off due to power overload.
	ioctl FE_DISEQC_SEND_MASTER_CMD — Sends a DiSEqC command
	ioctl FE_DISEQC_RECV_SLAVE_REPLY — Receives reply from a DiSEqC 2.0 command
	ioctl FE_DISEQC_SEND_BURST — Sends a 22KHz tone burst for 2x1 mini DiSEqC satellite selection.
	ioctl FE_SET_TONE — Sets/resets the generation of the continuous 22kHz tone.
	ioctl FE_SET_VOLTAGE — Allow setting the DC level sent to the antenna subsystem.
	ioctl FE_ENABLE_HIGH_LNB_VOLTAGE — Select output DC level between normal LNBf voltages or higher LNBf voltages.
	ioctl FE_SET_FRONTEND_TUNE_MODE — Allow setting tuner mode flags to the frontend.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 12a31e628d34..0fa4ccfd406d 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -35,8 +35,6 @@ the capability ioctls weren't implemented yet via the new way.</para>
 API is to replace the ioctl's were the <link linkend="dvb-frontend-parameters">
 struct <constant>dvb_frontend_parameters</constant></link> were used.</para>
 
-&sub-fe-get-property;
-
 <section id="dtv-stats">
 <title>DTV stats type</title>
 <programlisting>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 86bd9ed9d7f8..bcee1d9fc73d 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -37,8 +37,6 @@ specification is available at
 	<link linkend="FE_GET_INFO">FE_GET_INFO</link>.</para>
 </section>
 
-&sub-fe-get-info;
-
 <section id="dvb-fe-read-status">
 <title>Querying frontend status</title>
 
@@ -46,8 +44,6 @@ specification is available at
 	<link linkend="FE_READ_STATUS">FE_READ_STATUS</link>.</para>
 </section>
 
-&sub-fe-read-status;
-
 &sub-dvbproperty;
 
 <section id="fe-spectral-inversion-t">
@@ -333,6 +329,9 @@ typedef enum fe_hierarchy {
  </row></tbody></tgroup></informaltable>
 </section>
 
+&sub-fe-get-info;
+&sub-fe-read-status;
+&sub-fe-get-property;
 &sub-fe-diseqc-reset-overload;
 &sub-fe-diseqc-send-master-cmd;
 &sub-fe-diseqc-recv-slave-reply;
-- 
2.4.1

