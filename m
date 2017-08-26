Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53436
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752126AbdHZKHc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 06:07:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 2/6] media: frontend.rst: fix supported delivery systems
Date: Sat, 26 Aug 2017 07:07:10 -0300
Message-Id: <255f26aa7277d1a92a6b904f502d0da7299a8bf6.1503742025.git.mchehab@s-opensource.com>
In-Reply-To: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
References: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
In-Reply-To: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
References: <5874bbbb1ab7e717699fd09be97559776ad19fc5.1503742025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The introduction for the frontend chapter is not quite
correct:
  - it tells that it supports only three types of
    delivery systems, in opposite to three *groups*;
  - It adds ISDB-C to the list of supported systems,
    but, this is not true.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/frontend.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/dvb/frontend.rst b/Documentation/media/uapi/dvb/frontend.rst
index e051a9012540..313f46a4c6a6 100644
--- a/Documentation/media/uapi/dvb/frontend.rst
+++ b/Documentation/media/uapi/dvb/frontend.rst
@@ -5,13 +5,15 @@
 ################
 DVB Frontend API
 ################
-The DVB frontend API was designed to support three types of delivery
-systems:
+
+The DVB frontend API was designed to support three groups of delivery
+systems: Terrestrial, cable and Satellite. Currently, the following
+delivery systems are supported:
 
 -  Terrestrial systems: DVB-T, DVB-T2, ATSC, ATSC M/H, ISDB-T, DVB-H,
    DTMB, CMMB
 
--  Cable systems: DVB-C Annex A/C, ClearQAM (DVB-C Annex B), ISDB-C
+-  Cable systems: DVB-C Annex A/C, ClearQAM (DVB-C Annex B)
 
 -  Satellite systems: DVB-S, DVB-S2, DVB Turbo, ISDB-S, DSS
 
-- 
2.13.3
