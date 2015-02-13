Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbbBMW6X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Antti Palosaari <crope@iki.fi>, linux-doc@vger.kernel.org
Subject: [PATCHv4 07/25] [media] DocBook: Add tuner subdev at documentation
Date: Fri, 13 Feb 2015 20:57:50 -0200
Message-Id: <6320905a19054bd9f598358160cb31377c79ec8c.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we've added MEDIA_ENT_T_V4L2_SUBDEV_TUNER at the API,
document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 6f1b1cf172b7..cbf307f21a63 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -226,6 +226,10 @@
 	    it in some digital video standard, with appropriate embedded timing
 	    signals.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_TUNER</constant></entry>
+	    <entry>TV and/or radio tuner</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 408e1068ffe6..e98caa1c39bd 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -157,6 +157,7 @@ applications. -->
 	<date>2015-02-13</date>
 	<authorinitials>mcc</authorinitials>
 	<revremark>Fix documentation for media controller device nodes and add support for DVB device nodes.
+Add support for Tuner sub-device.
 	</revremark>
       </revision>
       <revision>
-- 
2.1.0

