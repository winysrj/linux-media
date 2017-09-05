Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57591
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750762AbdIELIL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Sep 2017 07:08:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>,
        Hans Verkuil <hansverk@cisco.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH] media: add qcom_camss.rst to v4l-drivers rst file
Date: Tue,  5 Sep 2017 08:08:04 -0300
Message-Id: <d55c8921ae517cc15f4e5a48e9d40889c98aa341.1504609679.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid this warning:
	/devel/v4l/docs/Documentation/media/v4l-drivers/qcom_camss.rst:: WARNING: document isn't included in any toctree

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 3643e63c4e46..679238e786a7 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -52,6 +52,7 @@ For more details see the file COPYING in the source distribution of Linux.
 	philips
 	pvrusb2
 	pxa_camera
+	qcom_camss
 	radiotrack
 	rcar-fdp1
 	saa7134
-- 
2.13.5
