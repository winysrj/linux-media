Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:37626 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932845AbeGIWkP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 18:40:15 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 17/17] [media] v4l2-subdev.rst: Update doc regarding subdev descriptors
Date: Mon,  9 Jul 2018 15:39:17 -0700
Message-Id: <1531175957-1973-18-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the doc to describe the new method of adding subdevice
descriptors to async notifiers.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v5:
- add info about v4l2_async_notifier_init().
---
 Documentation/media/kapi/v4l2-subdev.rst | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index e1f0b72..1280e05 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -247,20 +247,28 @@ performed using the :c:func:`v4l2_async_unregister_subdev` call. Subdevices
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
+Before registering the notifier, bridge drivers must do two things:
+first, the notifier must be initialized using the
+:c:func:`v4l2_async_notifier_init`. Second, bridge drivers can then
+begin to form a list of subdevice descriptors that the bridge device
+needs for its operation. Subdevice descriptors are added to the notifier
+using the :c:func:`v4l2_async_notifier_add_subdev` call. This function
+takes two arguments: a pointer to struct :c:type:`v4l2_async_notifier`,
+and a pointer to the subdevice descripter, which is of type struct
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
