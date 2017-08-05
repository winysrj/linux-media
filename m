Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:45986 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751250AbdHEK2w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 Aug 2017 06:28:52 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-ioc-g-mode.rst: improve description of message,
 processing
Message-ID: <2c0ca411-5d77-ad52-fd8c-e5567864210f@xs4all.nl>
Date: Sat, 5 Aug 2017 12:28:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The description of how messages are processed by the core was not
always very clear. Reword it to improve this.

In particular for the USER_CONTROL_* messages a critical bit was
missing in that the core also checks for the CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU
flag. This was confusing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst | 61 +++++++++++++++----------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index 3e907c74338f..494154e9d449 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -206,55 +206,68 @@ Core message processing details:
     * .. _`CEC-MSG-GET-CEC-VERSION`:

       - ``CEC_MSG_GET_CEC_VERSION``
-      - When in passthrough mode this message has to be handled by
-	userspace, otherwise the core will return the CEC version that was
-	set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.
+      - The core will return the CEC version that was set with
+	:ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`,
+	except when in passthrough mode. In passthrough mode the core
+	does nothing and this message has to be handled by a follower
+	instead.
     * .. _`CEC-MSG-GIVE-DEVICE-VENDOR-ID`:

       - ``CEC_MSG_GIVE_DEVICE_VENDOR_ID``
-      - When in passthrough mode this message has to be handled by
-	userspace, otherwise the core will return the vendor ID that was
-	set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.
+      - The core will return the vendor ID that was set with
+	:ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`,
+	except when in passthrough mode. In passthrough mode the core
+	does nothing and this message has to be handled by a follower
+	instead.
     * .. _`CEC-MSG-ABORT`:

       - ``CEC_MSG_ABORT``
-      - When in passthrough mode this message has to be handled by
-	userspace, otherwise the core will return a feature refused
-	message as per the specification.
+      - The core will return a Feature Abort message with reason
+        'Feature Refused' as per the specification, except when in
+	passthrough mode. In passthrough mode the core does nothing
+	and this message has to be handled by a follower instead.
     * .. _`CEC-MSG-GIVE-PHYSICAL-ADDR`:

       - ``CEC_MSG_GIVE_PHYSICAL_ADDR``
-      - When in passthrough mode this message has to be handled by
-	userspace, otherwise the core will report the current physical
-	address.
+      - The core will report the current physical address, except when
+        in passthrough mode. In passthrough mode the core does nothing
+	and this message has to be handled by a follower instead.
     * .. _`CEC-MSG-GIVE-OSD-NAME`:

       - ``CEC_MSG_GIVE_OSD_NAME``
-      - When in passthrough mode this message has to be handled by
-	userspace, otherwise the core will report the current OSD name as
-	was set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.
+      - The core will report the current OSD name that was set with
+	:ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`,
+	except when in passthrough mode. In passthrough mode the core
+	does nothing and this message has to be handled by a follower
+	instead.
     * .. _`CEC-MSG-GIVE-FEATURES`:

       - ``CEC_MSG_GIVE_FEATURES``
-      - When in passthrough mode this message has to be handled by
-	userspace, otherwise the core will report the current features as
-	was set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
-	or the message is ignored if the CEC version was older than 2.0.
+      - The core will do nothing if the CEC version is older than 2.0,
+        otherwise it will report the current features that were set with
+	:ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`,
+	except when in passthrough mode. In passthrough mode the core
+	does nothing (for any CEC version) and this message has to be handled
+	by a follower instead.
     * .. _`CEC-MSG-USER-CONTROL-PRESSED`:

       - ``CEC_MSG_USER_CONTROL_PRESSED``
-      - If :ref:`CEC_CAP_RC <CEC-CAP-RC>` is set, then generate a remote control key
-	press. This message is always passed on to userspace.
+      - If :ref:`CEC_CAP_RC <CEC-CAP-RC>` is set and if
+        :ref:`CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU <CEC-LOG-ADDRS-FL-ALLOW-RC-PASSTHRU>`
+	is set, then generate a remote control key
+	press. This message is always passed on to the follower(s).
     * .. _`CEC-MSG-USER-CONTROL-RELEASED`:

       - ``CEC_MSG_USER_CONTROL_RELEASED``
-      - If :ref:`CEC_CAP_RC <CEC-CAP-RC>` is set, then generate a remote control key
-	release. This message is always passed on to userspace.
+      - If :ref:`CEC_CAP_RC <CEC-CAP-RC>` is set and if
+        :ref:`CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU <CEC-LOG-ADDRS-FL-ALLOW-RC-PASSTHRU>`
+        is set, then generate a remote control key
+	release. This message is always passed on to the follower(s).
     * .. _`CEC-MSG-REPORT-PHYSICAL-ADDR`:

       - ``CEC_MSG_REPORT_PHYSICAL_ADDR``
       - The CEC framework will make note of the reported physical address
-	and then just pass the message on to userspace.
+	and then just pass the message on to the follower(s).



-- 
2.13.2
