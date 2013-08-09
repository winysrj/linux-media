Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:27993 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966631Ab3HIMMj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:12:39 -0400
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: baard.e.winther@wintherstormer.no
Subject: [PATCH FINAL 5/6] qv4l2: add manpage
Date: Fri,  9 Aug 2013 14:12:11 +0200
Message-Id: <b8ef6661a73f7ce65b3510826d4a74d0b76ed1af.1376049957.git.bwinther@cisco.com>
In-Reply-To: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
References: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <42a47889f837e362abc7a527c1029329e62034b0.1376049957.git.bwinther@cisco.com>
References: <42a47889f837e362abc7a527c1029329e62034b0.1376049957.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/Makefile.am |  1 +
 utils/qv4l2/qv4l2.1     | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)
 create mode 100644 utils/qv4l2/qv4l2.1

diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
index 58ac097..bdc64fd 100644
--- a/utils/qv4l2/Makefile.am
+++ b/utils/qv4l2/Makefile.am
@@ -1,4 +1,5 @@
 bin_PROGRAMS = qv4l2
+man_MANS = qv4l2.1
 
 qv4l2_SOURCES = qv4l2.cpp general-tab.cpp ctrl-tab.cpp vbi-tab.cpp v4l2-api.cpp capture-win.cpp \
   capture-win-qt.cpp capture-win-qt.h capture-win-gl.cpp capture-win-gl.h alsa_stream.c alsa_stream.h \
diff --git a/utils/qv4l2/qv4l2.1 b/utils/qv4l2/qv4l2.1
new file mode 100644
index 0000000..c6abe7c
--- /dev/null
+++ b/utils/qv4l2/qv4l2.1
@@ -0,0 +1,58 @@
+.TH "QV4L2" "1" "August 2013" "v4l-utils" "User Commands"
+.SH NAME
+qv4l2 - A test bench application for video4linux devices
+.SH SYNOPSIS
+.B qv4l2
+[\fI-R\fR] [\fI-h\fR] [\fI-d <dev>\fR] [\fI-r <dev>\fR] [\fI-V <dev>\fR]
+.SH DESCRIPTION
+The qv4l2 tool is used to test video4linux capture devices, either video, vbi or radio.
+This application can also serve as a generic video/TV viewer application.
+.PP
+However, it does not (yet) support compressed video streams other than MJPEG
+.SH OPTIONS
+.TP
+\fB\-d\fR, \fB\-\-device\fR=\fI<dev>\fR
+Use device <dev> as the video device. If <dev> is a number, then /dev/video<dev> is used.
+.TP
+\fB\-r\fR, \fB\-\-radio-device\fR=\fI<dev>\fR
+Use device <dev> as the radio device. If <dev> is a number, then /dev/radio<dev> is used.
+.TP
+\fB\-V\fR, \fB\-\-vbi-device\fR=\fI<dev>\fR
+Use device <dev> as the vbi device. If <dev> is a number, then /dev/vbi<dev> is used.
+.TP
+\fB\-R\fR, \fB\-\-raw\fR
+Open device in raw mode, i.e. without using the libv4l2 wrapper functions.
+.TP
+\fB\-h\fR, \fB\-\-help\fR
+Prints the help message.
+.SH HOTKEYS
+.SS Main Window
+.TP
+\fICtrl + O\fR
+Open device
+.TP
+\fICtrl + R\fR
+Open device in raw mode
+.TP
+\fICtrl + W\fR
+Close the device
+.TP
+\fICtrl + V\fR
+Start capture
+.TP
+\fICtrl + F\fR
+Resize Capture Window to frame size
+.TP
+\fICtrl + Q\fR
+Exit the application
+.SS Capture Window
+.TP
+\fICtrl + W\fR
+Closes the window and stops capture
+.TP
+\fICtrl + F\fR
+Resize Capture Window to frame size
+.SH EXIT STATUS
+On success, it returns 0. Otherwise, it will return the error code.
+.SH BUGS
+Report bugs to Hans Verkuil <hverkuil@xs4all.nl>
-- 
1.8.4.rc1

