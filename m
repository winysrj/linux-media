Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52271
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751287AbdICTEA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 15:04:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 4/7] media: vidioc-g-fmt.rst: adjust table format
Date: Sun,  3 Sep 2017 16:03:50 -0300
Message-Id: <6918e2a26c23cd9a2a46ff41136a9cf7abf7f8cd.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While doing a visual inspection with Sphinx 1.5, I noticed that
one of the columns was smaller than the text written there.

As this is the only thing I noticed with Sphinx 1.5, I suspect
that this was also a problem with Sphinx 1.4. Yet, I opted to
touch it in a way that wouldn't cause backward issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index f598ea9166e3..3ead350e099f 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -88,7 +88,7 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
 
 .. c:type:: v4l2_format
 
-.. tabularcolumns::  |p{1.2cm}|p{4.3cm}|p{3.0cm}|p{9.0cm}|
+.. tabularcolumns::  |p{1.2cm}|p{4.6cm}|p{3.0cm}|p{8.6cm}|
 
 .. flat-table:: struct v4l2_format
     :header-rows:  0
-- 
2.13.5
