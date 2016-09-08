Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43974 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965368AbcIHMEV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 20/47] [media] cec-ioc-dqevent.rst: fix some undefined references
Date: Thu,  8 Sep 2016 09:03:42 -0300
Message-Id: <8a5e3afca3cd3d62a04fe1f62315d5b440c60b38.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation/output/cec.h.rst:6: WARNING: c:type reference target not found: cec_event_state_change
Documentation/output/cec.h.rst:6: WARNING: c:type reference target not found: cec_event_state_change
Documentation/output/cec.h.rst:6: WARNING: c:type reference target not found: cec_event_lost_msgs
Documentation/output/cec.h.rst:6: WARNING: c:type reference target not found: cec_event_lost_msgs
Documentation/output/cec.h.rst:6: WARNING: c:type reference target not found: cec_event_state_change
Documentation/output/cec.h.rst:6: WARNING: c:type reference target not found: cec_event_lost_msgs

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 10228eb0fd4a..06b79361254c 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -51,7 +51,7 @@ it is guaranteed that the state did change in between the two events.
 
 .. tabularcolumns:: |p{1.2cm}|p{2.9cm}|p{13.4cm}|
 
-.. _cec-event-state-change_s:
+.. c:type:: cec_event_state_change
 
 .. flat-table:: struct cec_event_state_change
     :header-rows:  0
@@ -78,7 +78,7 @@ it is guaranteed that the state did change in between the two events.
 
 .. tabularcolumns:: |p{1.0cm}|p{2.0cm}|p{14.5cm}|
 
-.. _cec-event-lost-msgs_s:
+.. c:type:: cec_event_lost_msgs
 
 .. flat-table:: struct cec_event_lost_msgs
     :header-rows:  0
-- 
2.7.4


