Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:54370 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728341AbeJEUgh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 16:36:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/6] cec-core.rst: improve cec_transmit_done documentation
Date: Fri,  5 Oct 2018 15:37:40 +0200
Message-Id: <20181005133745.8593-2-hverkuil@xs4all.nl>
In-Reply-To: <20181005133745.8593-1-hverkuil@xs4all.nl>
References: <20181005133745.8593-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Clarify that calling cec_transmit_done can start a new transmit and
that you should put the hardware in a state that allows for a new
transmit before calling this function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/kapi/cec-core.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index 1d989c544370..bca1d9d1d223 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -268,6 +268,10 @@ to 1, if the hardware does support retry then either set these counters to
 0 if the hardware provides no feedback of which errors occurred and how many
 times, or fill in the correct values as reported by the hardware.
 
+Be aware that calling these functions can immediately start a new transmit
+if there is one pending in the queue. So make sure that the hardware is in
+a state where new transmits can be started *before* calling these functions.
+
 The cec_transmit_attempt_done() function is a helper for cases where the
 hardware never retries, so the transmit is always for just a single
 attempt. It will call cec_transmit_done() in turn, filling in 1 for the
-- 
2.18.0
