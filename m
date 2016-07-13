Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbcGMNwu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 09:52:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-doc@vger.kernel.org
Subject: [PATCH 1/2] [media] doc-rst: fix an undefined reference
Date: Wed, 13 Jul 2016 10:52:23 -0300
Message-Id: <47e23fda1c738e648d2a5470e1dacdc62ce788a5.1468417933.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	Documentation/media/uapi/cec/cec-ioc-dqevent.rst:43: WARNING: undefined label: cec_event_state_change (if the link has no caption the label must precede a section header)

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 0fdd4afa8d82..2785a4cb9f08 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -45,9 +45,9 @@ there is no more room in a queue then the last event is overwritten with
 the new one. This means that intermediate results can be thrown away but
 that the latest event is always available. This also means that is it
 possible to read two successive events that have the same value (e.g.
-two :ref:`CEC_EVENT_STATE_CHANGE <CEC_EVENT_STATE_CHANGE>` events with the same state). In that case
-the intermediate state changes were lost but it is guaranteed that the
-state did change in between the two events.
+two :ref:`CEC_EVENT_STATE_CHANGE <CEC-EVENT-STATE-CHANGE>` events with
+the same state). In that case the intermediate state changes were lost but
+it is guaranteed that the state did change in between the two events.
 
 
 .. _cec-event-state-change_s:
-- 
2.7.4

