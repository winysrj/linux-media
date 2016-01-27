Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:51118 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932475AbcA0Nb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 08:31:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 2/5] DocBook media: document the new V4L2_CID_DV_RX/TX_IT_CONTENT_TYPE controls
Date: Wed, 27 Jan 2016 14:31:40 +0100
Message-Id: <1453901503-35473-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1453901503-35473-1-git-send-email-hverkuil@xs4all.nl>
References: <1453901503-35473-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document these new controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 50 ++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index f13a429..7a77149 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -5070,6 +5070,46 @@ interface and may change in the future.</para>
 	    </entry>
 	  </row>
 	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_DV_TX_IT_CONTENT_TYPE</constant></entry>
+	    <entry id="v4l2-dv-content-type">enum v4l2_dv_it_content_type</entry>
+	  </row>
+	  <row><entry spanname="descr">Configures the IT Content Type
+	    of the transmitted video. This information is sent over HDMI and DisplayPort connectors
+	    as part of the AVI InfoFrame. The term 'IT Content' is used for content that originates
+	    from a computer as opposed to content from a TV broadcast or an analog source. The
+	    enum&nbsp;v4l2_dv_it_content_type defines the possible content types:</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+	        <row>
+	          <entry><constant>V4L2_DV_IT_CONTENT_TYPE_GRAPHICS</constant>&nbsp;</entry>
+		  <entry>Graphics content. Pixel data should be passed unfiltered and without
+		  analog reconstruction.</entry>
+		</row>
+	        <row>
+	          <entry><constant>V4L2_DV_IT_CONTENT_TYPE_PHOTO</constant>&nbsp;</entry>
+		  <entry>Photo content. The content is derived from digital still pictures.
+		  The content should be passed through with minimal scaling and picture
+		  enhancements.</entry>
+		</row>
+	        <row>
+	          <entry><constant>V4L2_DV_IT_CONTENT_TYPE_CINEMA</constant>&nbsp;</entry>
+		  <entry>Cinema content.</entry>
+		</row>
+	        <row>
+	          <entry><constant>V4L2_DV_IT_CONTENT_TYPE_GAME</constant>&nbsp;</entry>
+		  <entry>Game content. Audio and video latency should be minimized.</entry>
+		</row>
+	        <row>
+	          <entry><constant>V4L2_DV_IT_CONTENT_TYPE_NO_ITC</constant>&nbsp;</entry>
+		  <entry>No IT Content information is available and the ITC bit in the AVI
+		  InfoFrame is set to 0.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_DV_RX_POWER_PRESENT</constant></entry>
 	    <entry>bitmask</entry>
 	  </row>
@@ -5098,6 +5138,16 @@ interface and may change in the future.</para>
 	    This control is applicable to VGA, DVI-A/D, HDMI and DisplayPort connectors.
 	    </entry>
 	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_DV_RX_IT_CONTENT_TYPE</constant></entry>
+	    <entry>enum v4l2_dv_it_content_type</entry>
+	  </row>
+	  <row><entry spanname="descr">Reads the IT Content Type
+	    of the received video. This information is sent over HDMI and DisplayPort connectors
+	    as part of the AVI InfoFrame. The term 'IT Content' is used for content that originates
+	    from a computer as opposed to content from a TV broadcast or an analog source. See
+	    <constant>V4L2_CID_DV_TX_IT_CONTENT_TYPE</constant> for the available content types.</entry>
+	  </row>
 	  <row><entry></entry></row>
 	</tbody>
       </tgroup>
-- 
2.7.0.rc3

