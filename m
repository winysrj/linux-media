Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:35481 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751353AbdABMP4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 07:15:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH for v4.10 2/2] cec-intro.rst: mention the v4l-utils package and CEC utilities
Date: Mon,  2 Jan 2017 13:15:45 +0100
Message-Id: <1483359345-24652-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1483359345-24652-1-git-send-email-hverkuil@xs4all.nl>
References: <1483359345-24652-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Mention where to find the CEC utilities.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 Documentation/media/uapi/cec/cec-intro.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/media/uapi/cec/cec-intro.rst b/Documentation/media/uapi/cec/cec-intro.rst
index 7d31d37..07ee2b8 100644
--- a/Documentation/media/uapi/cec/cec-intro.rst
+++ b/Documentation/media/uapi/cec/cec-intro.rst
@@ -26,3 +26,15 @@ control just the CEC pin.
 Drivers that support CEC will create a CEC device node (/dev/cecX) to
 give userspace access to the CEC adapter. The
 :ref:`CEC_ADAP_G_CAPS` ioctl will tell userspace what it is allowed to do.
+
+In order to check the support and test it, it is suggested to download
+the `v4l-utils <https://git.linuxtv.org/v4l-utils.git/>`_ package. It
+provides three tools to handle CEC:
+
+- cec-ctl: the Swiss army knife of CEC. Allows you to configure, transmit
+  and monitor CEC messages.
+
+- cec-compliance: does a CEC compliance test of a remote CEC device to
+  determine how compliant the CEC implementation is.
+
+- cec-follower: emulates a CEC follower.
-- 
2.8.1

