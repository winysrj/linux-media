Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50943
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752816AbdICCfL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 22:35:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 07/12] media: mc uapi: adjust some table sizes for PDF output
Date: Sat,  2 Sep 2017 23:34:59 -0300
Message-Id: <973096618ff149b1d6ae8840fcc0d86870eebede.1504405125.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some cells are too small to fit the text written to it.

Increase it. No text changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst | 2 +-
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst    | 2 +-
 Documentation/media/uapi/mediactl/media-types.rst             | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index 0fd329279bef..b59ce149efb5 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -51,7 +51,7 @@ id's until they get an error.
 
 .. c:type:: media_entity_desc
 
-.. tabularcolumns:: |p{1.5cm}|p{1.5cm}|p{1.5cm}|p{1.5cm}|p{11.5cm}|
+.. tabularcolumns:: |p{1.5cm}|p{1.7cm}|p{1.6cm}|p{1.5cm}|p{11.2cm}|
 
 .. flat-table:: struct media_entity_desc
     :header-rows:  0
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index add8281494f8..997e6b17440d 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -46,7 +46,7 @@ other values untouched.
 If the ``topology_version`` remains the same, the ioctl should fill the
 desired arrays with the media graph elements.
 
-.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
+.. tabularcolumns:: |p{1.6cm}|p{3.4cm}|p{12.5cm}|
 
 .. c:type:: media_v2_topology
 
diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 71078565d644..8d64b0c06ebc 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -5,7 +5,7 @@
 Types and flags used to represent the media graph elements
 ==========================================================
 
-..  tabularcolumns:: |p{8.0cm}|p{10.5cm}|
+..  tabularcolumns:: |p{8.2cm}|p{10.3cm}|
 
 .. _media-entity-type:
 
-- 
2.13.5
