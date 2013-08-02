Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56338 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab3HBBCb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 21:02:31 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v5 2/9] Documentation: media: Clarify the VIDIOC_CREATE_BUFS format requirements
Date: Fri,  2 Aug 2013 03:03:21 +0200
Message-Id: <1375405408-17134-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375405408-17134-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1375405408-17134-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VIDIOC_CREATE_BUFS ioctl takes a format argument that must contain a
valid format supported by the driver. Clarify the documentation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index cd99436..407937a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
@@ -69,10 +69,11 @@ the <structname>v4l2_create_buffers</structname> structure. They set the
 structure, to the respective stream or buffer type.
 <structfield>count</structfield> must be set to the number of required buffers.
 <structfield>memory</structfield> specifies the required I/O method. The
-<structfield>format</structfield> field shall typically be filled in using
-either the <constant>VIDIOC_TRY_FMT</constant> or
-<constant>VIDIOC_G_FMT</constant> ioctl(). Additionally, applications can adjust
-<structfield>sizeimage</structfield> fields to fit their specific needs. The
+<structfield>format</structfield> field must be a valid format supported by the
+driver. Applications shall typically fill it using either the
+<constant>VIDIOC_TRY_FMT</constant> or <constant>VIDIOC_G_FMT</constant>
+ioctl(). Any format that would be modified by the
+<constant>VIDIOC_TRY_FMT</constant> ioctl() will be rejected with an error. The
 <structfield>reserved</structfield> array must be zeroed.</para>
 
     <para>When the ioctl is called with a pointer to this structure the driver
@@ -144,9 +145,9 @@ mapped</link> I/O.</para>
       <varlistentry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
-	  <para>The buffer type (<structfield>type</structfield> field) or the
-requested I/O method (<structfield>memory</structfield>) is not
-supported.</para>
+	  <para>The buffer type (<structfield>type</structfield> field),
+requested I/O method (<structfield>memory</structfield>) or format
+(<structfield>format</structfield> field) is not valid.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
-- 
1.8.1.5

