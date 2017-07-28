Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:43224 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751774AbdG1Kby (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:54 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: documentation fixes
Message-ID: <25dbe283-09e6-1448-3d6f-1a2917ebfe22@xs4all.nl>
Date: Fri, 28 Jul 2017 12:31:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various references to open() et al were wrong. Fix this so following
the link will get you to the correct place.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/cec/cec-func-close.rst      | 2 +-
 Documentation/media/uapi/cec/cec-func-ioctl.rst      | 2 +-
 Documentation/media/uapi/cec/cec-func-open.rst       | 4 ++--
 Documentation/media/uapi/cec/cec-func-poll.rst       | 8 ++++----
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst | 2 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst     | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-func-close.rst b/Documentation/media/uapi/cec/cec-func-close.rst
index 895d9c2d1c04..334358dfa72e 100644
--- a/Documentation/media/uapi/cec/cec-func-close.rst
+++ b/Documentation/media/uapi/cec/cec-func-close.rst
@@ -40,7 +40,7 @@ freed. The device configuration remain unchanged.
 Return Value
 ============

-:c:func:`close()` returns 0 on success. On error, -1 is returned, and
+:c:func:`close() <cec-close>` returns 0 on success. On error, -1 is returned, and
 ``errno`` is set appropriately. Possible error codes are:

 ``EBADF``
diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
index 22fb6304a2df..e2b6260b0086 100644
--- a/Documentation/media/uapi/cec/cec-func-ioctl.rst
+++ b/Documentation/media/uapi/cec/cec-func-ioctl.rst
@@ -39,7 +39,7 @@ Arguments
 Description
 ===========

-The :c:func:`ioctl()` function manipulates cec device parameters. The
+The :c:func:`ioctl() <cec-ioctl>` function manipulates cec device parameters. The
 argument ``fd`` must be an open file descriptor.

 The ioctl ``request`` code specifies the cec function to be called. It
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index 18dfb62f2efe..5d6663a649bd 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -46,7 +46,7 @@ Arguments
 Description
 ===========

-To open a cec device applications call :c:func:`open()` with the
+To open a cec device applications call :c:func:`open() <cec-open>` with the
 desired device name. The function has no side effects; the device
 configuration remain unchanged.

@@ -58,7 +58,7 @@ EBADF.
 Return Value
 ============

-:c:func:`open()` returns the new file descriptor on success. On error,
+:c:func:`open() <cec-open>` returns the new file descriptor on success. On error,
 -1 is returned, and ``errno`` is set appropriately. Possible error codes
 include:

diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
index fa0abd8fb160..d49f1ee0742d 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -39,10 +39,10 @@ Arguments
 Description
 ===========

-With the :c:func:`poll()` function applications can wait for CEC
+With the :c:func:`poll() <cec-poll>` function applications can wait for CEC
 events.

-On success :c:func:`poll()` returns the number of file descriptors
+On success :c:func:`poll() <cec-poll>` returns the number of file descriptors
 that have been selected (that is, file descriptors for which the
 ``revents`` field of the respective struct :c:type:`pollfd`
 is non-zero). CEC devices set the ``POLLIN`` and ``POLLRDNORM`` flags in
@@ -53,13 +53,13 @@ then the ``POLLPRI`` flag is set. When the function times out it returns
 a value of zero, on failure it returns -1 and the ``errno`` variable is
 set appropriately.

-For more details see the :c:func:`poll()` manual page.
+For more details see the :c:func:`poll() <cec-poll>` manual page.


 Return Value
 ============

-On success, :c:func:`poll()` returns the number structures which have
+On success, :c:func:`poll() <cec-poll>` returns the number structures which have
 non-zero ``revents`` fields, or zero if the call timed out. On error -1
 is returned, and the ``errno`` variable is set appropriately:

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 882d6e025747..0a7aa21f24f4 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -21,7 +21,7 @@ Arguments
 =========

 ``fd``
-    File descriptor returned by :ref:`open() <cec-func-open>`.
+    File descriptor returned by :c:func:`open() <cec-open>`.

 ``argp``

diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 3e2cd5fefd38..766d8b0ce431 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -22,7 +22,7 @@ Arguments
 =========

 ``fd``
-    File descriptor returned by :ref:`open() <cec-func-open>`.
+    File descriptor returned by :c:func:`open() <cec-open>`.

 ``argp``

-- 
2.13.1
