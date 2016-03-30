Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46409 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbcC3Tew (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2016 15:34:52 -0400
From: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl,
	sakari.ailus@linux.intel.com, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com, s.nawrocki@samsung.com
Cc: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
Subject: [PATCH v4 2/2] [media] DocBook: update error code in videoc-streamon
Date: Wed, 30 Mar 2016 16:34:30 -0300
Message-Id: <f6cf5a615e0bf471489b44a851b4bdf53cc854f1.1459365719.git.helen.koike@collabora.co.uk>
In-Reply-To: <cover.1459365719.git.helen.koike@collabora.co.uk>
References: <cover.1459365719.git.helen.koike@collabora.co.uk>
In-Reply-To: <cover.1459365719.git.helen.koike@collabora.co.uk>
References: <cover.1459365719.git.helen.koike@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add description of ENOLINK error

Signed-off-by: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---

Changes since v3:
	* ..."pipeline configuration"... to ..."pipeline link configuration"...
	* Added Acked-by

The patch is based on 'media/master' branch and available at
        https://github.com/helen-fornazier/opw-staging media/devel

 Documentation/DocBook/media/v4l/vidioc-streamon.xml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-streamon.xml b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
index df2c63d..89fd7ce 100644
--- a/Documentation/DocBook/media/v4l/vidioc-streamon.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
@@ -123,6 +123,14 @@ synchronize with other events.</para>
 	  </para>
 	</listitem>
       </varlistentry>
+      <varlistentry>
+	<term><errorcode>ENOLINK</errorcode></term>
+	<listitem>
+	  <para>The driver implements Media Controller interface and
+	  the pipeline link configuration is invalid.
+	  </para>
+	</listitem>
+      </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-- 
1.9.1

