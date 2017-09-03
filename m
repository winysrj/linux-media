Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52298
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751569AbdICTEB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 15:04:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Vincent ABRIOU <vincent.abriou@st.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/7] media: vivid.rst: add a blank line to correct ReST format
Date: Sun,  3 Sep 2017 16:03:49 -0300
Message-Id: <44a0c3b15358a1b50568dad4fd404c39646e1c3a.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On all vivid parameters, there's an space after the parameter,
except for "DV Timings Signal Mode". That makes this single one
to be written in bold, and, at PDF output, at the same line as
its description.

Use the same convention as the other parameters, in order to
adjust its output.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/vivid.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/media/v4l-drivers/vivid.rst b/Documentation/media/v4l-drivers/vivid.rst
index 3e44b2217f2d..089595ce11c5 100644
--- a/Documentation/media/v4l-drivers/vivid.rst
+++ b/Documentation/media/v4l-drivers/vivid.rst
@@ -829,6 +829,7 @@ The following two controls are only valid for video and vbi capture.
 The following two controls are only valid for video capture.
 
 - DV Timings Signal Mode:
+
 	selects the behavior of VIDIOC_QUERY_DV_TIMINGS: what
 	should it return?
 
-- 
2.13.5
