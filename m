Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38588 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 05/41] Documentation: ca_function_calls: improve man-like format
Date: Mon,  4 Jul 2016 22:30:40 -0300
Message-Id: <c8d1295d0100fe9dbbe83661448d044e55845fbe.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parsing this file were causing lots of warnings with sphinx,
due to the c function prototypes.

Fix that by prepending them with .. cpp:function::

While here, use the same way we document man-like pages,
at the V4L side of the book and add escapes to asterisks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../linux_tv/media/dvb/ca_function_calls.rst       | 162 +++++++++++++--------
 1 file changed, 101 insertions(+), 61 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/ca_function_calls.rst b/Documentation/linux_tv/media/dvb/ca_function_calls.rst
index af110ba6496a..1aa9cb66edae 100644
--- a/Documentation/linux_tv/media/dvb/ca_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/ca_function_calls.rst
@@ -9,10 +9,11 @@ CA Function Calls
 
 .. _ca_fopen:
 
-open()
-======
+DVB CA open()
+=============
 
-DESCRIPTION
+Description
+-----------
 
 This system call opens a named ca device (e.g. /dev/ost/ca) for
 subsequent use.
@@ -27,11 +28,13 @@ system call, documented in the Linux manual page for fcntl. Only one
 user can open the CA Device in O_RDWR mode. All other attempts to open
 the device in this mode will fail, and an error code will be returned.
 
-SYNOPSIS
+Synopsis
+--------
 
-int open(const char *deviceName, int flags);
+.. cpp:function:: int  open(const char *deviceName, int flags)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -42,7 +45,7 @@ PARAMETERS
 
     -  .. row 1
 
-       -  const char *deviceName
+       -  const char \*deviceName
 
        -  Name of specific video device.
 
@@ -73,7 +76,8 @@ PARAMETERS
        -  (blocking mode is the default)
 
 
-RETURN VALUE
+Return Value
+------------
 
 
 
@@ -110,18 +114,21 @@ RETURN VALUE
 
 .. _ca_fclose:
 
-close()
-=======
+DVB CA close()
+==============
 
-DESCRIPTION
+Description
+-----------
 
 This system call closes a previously opened audio device.
 
-SYNOPSIS
+Synopsis
+--------
 
-int close(int fd);
+.. cpp:function:: int  close(int fd)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -137,7 +144,8 @@ PARAMETERS
        -  File descriptor returned by a previous call to open().
 
 
-RETURN VALUE
+Return Value
+------------
 
 
 
@@ -159,15 +167,18 @@ RETURN VALUE
 CA_RESET
 ========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is undocumented. Documentation is welcome.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = CA_RESET);
+.. cpp:function:: int  ioctl(fd, int request = CA_RESET)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -189,7 +200,8 @@ PARAMETERS
        -  Equals CA_RESET for this command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -201,15 +213,18 @@ appropriately. The generic error codes are described at the
 CA_GET_CAP
 ==========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is undocumented. Documentation is welcome.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = CA_GET_CAP, ca_caps_t *);
+.. cpp:function:: int  ioctl(fd, int request = CA_GET_CAP, ca_caps_t *)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -237,7 +252,8 @@ PARAMETERS
        -  Undocumented.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -249,15 +265,18 @@ appropriately. The generic error codes are described at the
 CA_GET_SLOT_INFO
 ================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is undocumented. Documentation is welcome.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = CA_GET_SLOT_INFO, ca_slot_info_t *);
+.. cpp:function:: int  ioctl(fd, int request = CA_GET_SLOT_INFO, ca_slot_info_t *)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -280,12 +299,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  ca_slot_info_t *
+       -  ca_slot_info_t \*
 
        -  Undocumented.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -297,15 +317,18 @@ appropriately. The generic error codes are described at the
 CA_GET_DESCR_INFO
 =================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is undocumented. Documentation is welcome.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = CA_GET_DESCR_INFO, ca_descr_info_t *);
+.. cpp:function:: int  ioctl(fd, int request = CA_GET_DESCR_INFO, ca_descr_info_t *)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -328,12 +351,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  ca_descr_info_t *
+       -  ca_descr_info_t \*
 
        -  Undocumented.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -345,15 +369,18 @@ appropriately. The generic error codes are described at the
 CA_GET_MSG
 ==========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is undocumented. Documentation is welcome.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = CA_GET_MSG, ca_msg_t *);
+.. cpp:function:: int  ioctl(fd, int request = CA_GET_MSG, ca_msg_t *)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -376,12 +403,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  ca_msg_t *
+       -  ca_msg_t \*
 
        -  Undocumented.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -393,15 +421,18 @@ appropriately. The generic error codes are described at the
 CA_SEND_MSG
 ===========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is undocumented. Documentation is welcome.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = CA_SEND_MSG, ca_msg_t *);
+.. cpp:function:: int  ioctl(fd, int request = CA_SEND_MSG, ca_msg_t *)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -424,12 +455,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  ca_msg_t *
+       -  ca_msg_t \*
 
        -  Undocumented.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -441,15 +473,18 @@ appropriately. The generic error codes are described at the
 CA_SET_DESCR
 ============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is undocumented. Documentation is welcome.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = CA_SET_DESCR, ca_descr_t *);
+.. cpp:function:: int  ioctl(fd, int request = CA_SET_DESCR, ca_descr_t *)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -472,12 +507,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  ca_descr_t *
+       -  ca_descr_t \*
 
        -  Undocumented.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -489,15 +525,18 @@ appropriately. The generic error codes are described at the
 CA_SET_PID
 ==========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is undocumented. Documentation is welcome.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = CA_SET_PID, ca_pid_t *);
+.. cpp:function:: int  ioctl(fd, int request = CA_SET_PID, ca_pid_t *)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -520,12 +559,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  ca_pid_t *
+       -  ca_pid_t \*
 
        -  Undocumented.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
-- 
2.7.4

