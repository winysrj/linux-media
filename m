Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46360 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbcC3THA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2016 15:07:00 -0400
From: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl,
	sakari.ailus@linux.intel.com, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com, s.nawrocki@samsung.com
Cc: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
Subject: [PATCH v3 2/2] [media] DocBook: update error code in videoc-streamon
Date: Wed, 30 Mar 2016 16:06:42 -0300
Message-Id: <77998a67791470bc947beb421bec9a5c28fb5fd5.1459363790.git.helen.koike@collabora.co.uk>
In-Reply-To: <cover.1459363790.git.helen.koike@collabora.co.uk>
References: <cover.1459363790.git.helen.koike@collabora.co.uk>
In-Reply-To: <cover.1459363790.git.helen.koike@collabora.co.uk>
References: <cover.1459363790.git.helen.koike@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add description of ENOLINK error

Signed-off-by: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
---

The patch set is based on 'media/master' branch and available at
        https://github.com/helen-fornazier/opw-staging media/devel

Changes since v2:
	* this is a new commit in the set

 Documentation/DocBook/media/v4l/vidioc-streamon.xml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-streamon.xml b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
index df2c63d..c4b88b0 100644
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
+	  the pipeline configuration is invalid.
+	  </para>
+	</listitem>
+      </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-- 
1.9.1

