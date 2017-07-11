Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:36554 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755265AbdGKGaw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 02:30:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/11] cec-core.rst: include cec-pin.h and cec-notifier.h
Date: Tue, 11 Jul 2017 08:30:43 +0200
Message-Id: <20170711063044.29849-11-hverkuil@xs4all.nl>
In-Reply-To: <20170711063044.29849-1-hverkuil@xs4all.nl>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Include the CEC pin framework documentation by reading cec-pin.h.
Include the CEC notifier framework documentation by reading cec-notifier.h.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/kapi/cec-core.rst | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index bb066b2b26f8..dc512bdd43c0 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -345,3 +345,34 @@ log_addrs->num_log_addrs set to 0. The block argument is ignored when
 unconfiguring. This function will just return if the physical address is
 invalid. Once the physical address becomes valid, then the framework will
 attempt to claim these logical addresses.
+
+CEC Pin framework
+-----------------
+
+Most CEC hardware operates on full CEC messages where the software provides
+the message and the hardware handles the low-level CEC protocol. But some
+hardware only drives the CEC pin and software has to handle the low-level
+CEC protocol. The CEC pin framework was created to handle such devices.
+
+Note that due to the close-to-realtime requirements it can never be guaranteed
+to work 100%. This framework uses highres timers internally, but if a
+timer goes off too late by more than 300 microseconds wrong results can
+occur. In reality it appears to be fairly reliable.
+
+One advantage of this low-level implementation is that it can be used as
+a cheap CEC analyser, especially if interrupts can be used to detect
+CEC pin transitions from low to high or vice versa.
+
+.. kernel-doc:: include/media/cec-pin.h
+
+CEC Notifier framework
+-----------------
+
+Most drm HDMI implementations have an integrated CEC implementation and no
+notifier support is needed. But some have independent CEC implementations
+that have their own driver. This could be an IP block for an SoC or a
+completely separate chip that deals with the CEC pin. For those cases a
+drm driver can install a notifier and use the notifier to inform the
+CEC driver about changes in the physical address.
+
+.. kernel-doc:: include/media/cec-notifier.h
-- 
2.11.0
