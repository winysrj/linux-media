Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43886 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965320AbcIHMET (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:19 -0400
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
Subject: [PATCH 39/47] [media] fix clock_gettime cross-references
Date: Thu,  8 Sep 2016 09:04:01 -0300
Message-Id: <f4ef9aa04ce919791efec7e0de65788f63ce6bba.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those warnings:

	Documentation/media/uapi/cec/cec-ioc-dqevent.rst:124: WARNING: c:func reference target not found: clock_gettime(2)

By replacing it with the right function name, using this shell script:

	for i in `find Documentation/media -type f`; do sed 's,clock_gettime(2),clock_gettime,' <$i >a && mv a $i; done

Please notice that this will make the nitpick mode to shut up
complaining about that, becasue clock_gettime is on its exclude list,
but the cross reference will be undefined until someone documents
this function at the core documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst | 2 +-
 Documentation/media/uapi/cec/cec-ioc-receive.rst | 4 ++--
 Documentation/media/uapi/v4l/buffer.rst          | 4 ++--
 Documentation/media/uapi/v4l/vidioc-dqevent.rst  | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 06b79361254c..060c455380ce 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -122,7 +122,7 @@ it is guaranteed that the state did change in between the two events.
        -  :cspan:`1` Timestamp of the event in ns.
 
 	  The timestamp has been taken from the ``CLOCK_MONOTONIC`` clock. To access
-	  the same clock from userspace use :c:func:`clock_gettime(2)`.
+	  the same clock from userspace use :c:func:`clock_gettime`.
 
     -  .. row 2
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 18620f81b7d9..d585b1bba6ac 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -95,7 +95,7 @@ result.
 
        -  Timestamp in ns of when the last byte of the message was transmitted.
 	  The timestamp has been taken from the ``CLOCK_MONOTONIC`` clock. To access
-	  the same clock from userspace use :c:func:`clock_gettime(2)`.
+	  the same clock from userspace use :c:func:`clock_gettime`.
 
     -  .. row 2
 
@@ -105,7 +105,7 @@ result.
 
        -  Timestamp in ns of when the last byte of the message was received.
 	  The timestamp has been taken from the ``CLOCK_MONOTONIC`` clock. To access
-	  the same clock from userspace use :c:func:`clock_gettime(2)`.
+	  the same clock from userspace use :c:func:`clock_gettime`.
 
     -  .. row 3
 
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 7d2d81a771b1..e71a458712d3 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -712,7 +712,7 @@ Buffer Flags
 	  clock). Monotonic clock has been favoured in embedded systems
 	  whereas most of the drivers use the realtime clock. Either kinds
 	  of timestamps are available in user space via
-	  :c:func:`clock_gettime(2)` using clock IDs ``CLOCK_MONOTONIC``
+	  :c:func:`clock_gettime` using clock IDs ``CLOCK_MONOTONIC``
 	  and ``CLOCK_REALTIME``, respectively.
 
     -  .. _`V4L2-BUF-FLAG-TIMESTAMP-MONOTONIC`:
@@ -723,7 +723,7 @@ Buffer Flags
 
        -  The buffer timestamp has been taken from the ``CLOCK_MONOTONIC``
 	  clock. To access the same clock outside V4L2, use
-	  :c:func:`clock_gettime(2)`.
+	  :c:func:`clock_gettime`.
 
     -  .. _`V4L2-BUF-FLAG-TIMESTAMP-COPY`:
 
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index 3038f349049c..1e435ab674a2 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -152,7 +152,7 @@ call.
        -
        -  Event timestamp. The timestamp has been taken from the
 	  ``CLOCK_MONOTONIC`` clock. To access the same clock outside V4L2,
-	  use :c:func:`clock_gettime(2)`.
+	  use :c:func:`clock_gettime`.
 
     -  .. row 12
 
-- 
2.7.4


