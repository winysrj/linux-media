Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:45256 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751440AbdB0OYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 09:24:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/9] cec: document the special unconfigured case
Date: Mon, 27 Feb 2017 15:20:39 +0100
Message-Id: <20170227142042.37085-7-hverkuil@xs4all.nl>
In-Reply-To: <20170227142042.37085-1-hverkuil@xs4all.nl>
References: <20170227142042.37085-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Even when the CEC device is unconfigured due to an invalid physical
address it is still allowed to send a message from 0xf (Unregistered)
to 0 (TV). This is a corner case explicitly allowed by the CEC specification.

Document this corner case.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/cec/cec-ioc-receive.rst | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 3ce7307f55fa..267044f7ac30 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -69,6 +69,18 @@ The ``sequence`` field is filled in for every transmit and this can be
 checked against the received messages to find the corresponding transmit
 result.
 
+Normally calling :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` when the physical
+address is invalid (due to e.g. a disconnect) will return ``ENONET``.
+
+However, the CEC specification allows sending messages from 'Unregistered' to
+'TV' when the physical address is invalid since some TVs pull the hotplug detect
+pin of the HDMI connector low when they go into standby, or when switching to
+another input.
+
+When the hotplug detect pin goes low the EDID disappears, and thus the
+physical address, but the cable is still connected and CEC still works.
+In order to detect/wake up the device it is allowed to send poll and 'Image/Text
+View On' messages from initiator 0xf ('Unregistered') to destination 0 ('TV').
 
 .. tabularcolumns:: |p{1.0cm}|p{3.5cm}|p{13.0cm}|
 
@@ -315,6 +327,8 @@ EPERM
 ENONET
     The CEC adapter is not configured, i.e. :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
     was called, but the physical address is invalid so no logical address was claimed.
+    An exception is made in this case for transmits from initiator 0xf ('Unregistered')
+    to destination 0 ('TV'). In that case the transmit will proceed as usual.
 
 EBUSY
     Another filehandle is in exclusive follower or initiator mode, or the filehandle
-- 
2.11.0
