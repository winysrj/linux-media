Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:34660 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965133AbeF2Sxd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 14:53:33 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 17/17] [media] v4l2-subdev.rst: Update doc regarding subdev descriptors
Date: Fri, 29 Jun 2018 11:50:01 -0700
Message-Id: <1530298220-5097-18-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1530298220-5097-1-git-send-email-steve_longerbeam@mentor.com>
References: <1530298220-5097-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the doc to describe the new method of adding subdevice
descriptors to async notifiers.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 Documentation/media/kapi/v4l2-subdev.rst | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index e1f0b72..7197eeb 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -247,20 +247,26 @@ performed using the :c:func:`v4l2_async_unregister_subdev` call. Subdevices
 registered this way are stored in a global list of subdevices, ready to be
 picked up by bridge drivers.
 
-Bridge drivers in turn have to register a notifier object with an array of
-subdevice descriptors that the bridge device needs for its operation. This is
+Bridge drivers in turn have to register a notifier object. This is
 performed using the :c:func:`v4l2_async_notifier_register` call. To
 unregister the notifier the driver has to call
 :c:func:`v4l2_async_notifier_unregister`. The former of the two functions
-takes two arguments: a pointer to struct :c:type:`v4l2_device` and a pointer to
-struct :c:type:`v4l2_async_notifier`. The latter contains a pointer to an array
-of pointers to subdevice descriptors of type struct :c:type:`v4l2_async_subdev`
-type. The V4L2 core will then use these descriptors to match asynchronously
-registered
-subdevices to them. If a match is detected the ``.bound()`` notifier callback
-is called. After all subdevices have been located the .complete() callback is
-called. When a subdevice is removed from the system the .unbind() method is
-called. All three callbacks are optional.
+takes two arguments: a pointer to struct :c:type:`v4l2_device` and a
+pointer to struct :c:type:`v4l2_async_notifier`.
+
+Before registering the notifier, bridge drivers form a list of
+subdevice descriptors that the bridge device needs for its operation.
+Subdevice descriptors are added to the notifier using the
+:c:func:`v4l2_async_notifier_add_subdev` call. This function takes
+two arguments: a pointer to struct :c:type:`v4l2_async_notifier`, and
+a pointer to the subdevice descripter, which is of type struct
+:c:type:`v4l2_async_subdev`.
+
+The V4L2 core will then use these descriptors to match asynchronously
+registered subdevices to them. If a match is detected the ``.bound()``
+notifier callback is called. After all subdevices have been located the
+.complete() callback is called. When a subdevice is removed from the
+system the .unbind() method is called. All three callbacks are optional.
 
 V4L2 sub-device userspace API
 -----------------------------
-- 
2.7.4
