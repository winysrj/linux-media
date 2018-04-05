Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62600 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751178AbeDEK7O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 06:59:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: tfiga@google.com, hverkuil@xs4all.nl
Subject: [v4l-utils RFC 6/6] mediatext: Add vivid tests
Date: Thu,  5 Apr 2018 13:58:19 +0300
Message-Id: <1522925899-14073-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1522925899-14073-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1522925899-14073-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two scripts for vivid tests, with and without using requests.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/tests/test-vivid-mc.bash | 86 ++++++++++++++++++++++++++++++++
 utils/media-ctl/tests/test-vivid.bash    | 59 ++++++++++++++++++++++
 2 files changed, 145 insertions(+)
 create mode 100755 utils/media-ctl/tests/test-vivid-mc.bash
 create mode 100755 utils/media-ctl/tests/test-vivid.bash

diff --git a/utils/media-ctl/tests/test-vivid-mc.bash b/utils/media-ctl/tests/test-vivid-mc.bash
new file mode 100755
index 0000000..40c2e7d
--- /dev/null
+++ b/utils/media-ctl/tests/test-vivid-mc.bash
@@ -0,0 +1,86 @@
+#!/bin/bash
+
+coproc mediatext -c 2>&1
+
+# read initialisation
+read -ru ${COPROC[0]}; eval $REPLY
+
+cat <<EOF >&${COPROC[1]}
+verbose true
+
+v4l open entity="vim2m" name=vim
+v4l fmt vdev=vim type=VIDEO_OUTPUT width=480 height=320 \
+	pixelformat=RGB565X bytesperline=0 num_planes=1
+v4l reqbufs vdev=vim type=VIDEO_OUTPUT count=3 memory=MMAP
+v4l fmt vdev=vim type=VIDEO_CAPTURE width=480 height=320 \
+	pixelformat=RGB565X bytesperline=0 num_planes=1
+v4l reqbufs vdev=vim type=VIDEO_CAPTURE count=3 memory=MMAP
+
+media req-create req=foo
+media req-create req=foo1
+media req-create req=foo2
+
+v4l io vdev=vim type=VIDEO_OUTPUT fname=/bin/bash
+v4l io vdev=vim type=VIDEO_OUTPUT fname=/bin/systemctl
+v4l io vdev=vim type=VIDEO_OUTPUT fname=/vmlinuz
+
+v4l qbuf vdev=vim type=VIDEO_OUTPUT req=foo
+v4l qbuf vdev=vim type=VIDEO_OUTPUT req=foo1
+v4l qbuf vdev=vim type=VIDEO_CAPTURE req=foo1
+v4l qbuf vdev=vim type=VIDEO_CAPTURE req=foo
+
+media req-queue req=foo
+
+v4l qbuf vdev=vim type=VIDEO_OUTPUT req=foo2
+v4l qbuf vdev=vim type=VIDEO_CAPTURE req=foo2
+
+v4l streamon vdev=vim type=VIDEO_CAPTURE
+v4l streamon vdev=vim type=VIDEO_OUTPUT
+
+media req-queue req=foo2
+media req-queue req=foo1
+
+EOF
+
+queued=3
+finished=0
+
+while IFS= read -ru ${COPROC[0]}; do
+	unset p; declare -A p
+	eval eval_line $REPLY
+	echo $REPLY
+	#echo ${p[event]}
+	case ${p[event]} in
+	dqbuf)
+		#echo seq ${p[seq]}
+		if [ ${p[type]} == VIDEO_CAPTURE ]; then
+			echo v4l io vdev=vim type=VIDEO_CAPTURE \
+				sequence=${p[seq]} >&${COPROC[1]}
+		fi
+	;;
+	request-complete)
+		finished=$(($finished+1));
+		if (($queued < 10)); then
+			queued=$(($queued + 1))
+			cat <<EOF >&${COPROC[1]}
+				media req-create req=${p[req]}
+				v4l io vdev=vim type=VIDEO_OUTPUT fname=/bin/tar
+				v4l qbuf vdev=vim type=VIDEO_OUTPUT req=${p[req]}
+				v4l qbuf vdev=vim type=VIDEO_CAPTURE req=${p[req]}
+				media req-queue req=${p[req]}
+EOF
+		fi
+		echo $queued requests queued, $finished finished
+		if (($finished == 10)); then
+			cat <<EOF >&${COPROC[1]}
+				v4l streamoff vdev=vim type=VIDEO_CAPTURE
+				v4l streamoff vdev=vim type=VIDEO_OUTPUT
+				v4l reqbufs vdev=vim type=VIDEO_CAPTURE count=0 memory=MMAP
+				v4l reqbufs vdev=vim type=VIDEO_OUTPUT count=0 memory=MMAP
+				quit
+EOF
+		exit 0
+		fi
+	;;
+	esac;
+done
diff --git a/utils/media-ctl/tests/test-vivid.bash b/utils/media-ctl/tests/test-vivid.bash
new file mode 100755
index 0000000..3c9b2f4
--- /dev/null
+++ b/utils/media-ctl/tests/test-vivid.bash
@@ -0,0 +1,59 @@
+#!/bin/bash
+
+coproc mediatext -c 2>&1
+
+# read initialisation
+read -ru ${COPROC[0]}; eval $REPLY
+
+cat <<EOF >&${COPROC[1]}
+verbose true
+
+v4l open entity="vim2m" name=vim
+v4l fmt vdev=vim type=VIDEO_OUTPUT width=480 height=320 \
+	pixelformat=RGB565X bytesperline=0 num_planes=1
+v4l reqbufs vdev=vim type=VIDEO_OUTPUT count=3 memory=MMAP
+v4l fmt vdev=vim type=VIDEO_CAPTURE width=480 height=320 \
+	pixelformat=RGB565X bytesperline=0 num_planes=1
+v4l reqbufs vdev=vim type=VIDEO_CAPTURE count=3 memory=MMAP
+
+v4l io vdev=vim type=VIDEO_OUTPUT fname=/bin/bash
+v4l io vdev=vim type=VIDEO_OUTPUT fname=/bin/systemctl
+v4l io vdev=vim type=VIDEO_OUTPUT fname=/vmlinuz
+v4l qbuf vdev=vim type=VIDEO_OUTPUT
+v4l qbuf vdev=vim type=VIDEO_OUTPUT
+v4l qbuf vdev=vim type=VIDEO_CAPTURE
+v4l qbuf vdev=vim type=VIDEO_CAPTURE
+
+v4l streamon vdev=vim type=VIDEO_CAPTURE
+v4l streamon vdev=vim type=VIDEO_OUTPUT
+EOF
+
+while IFS= read -ru ${COPROC[0]} line; do
+	unset p; declare -A p
+	eval eval_line $line
+	echo $line
+	#echo ${p[event]}
+	case ${p[event]} in
+	dqbuf)
+		#echo seq ${p[seq]}
+		if [ ${p[type]} == VIDEO_CAPTURE ]; then
+			echo v4l io vdev=vim type=VIDEO_CAPTURE \
+				sequence=${p[seq]} >&${COPROC[1]}
+			echo v4l io vdev=vim type=VIDEO_OUTPUT \
+				fname=/bin/tar >&${COPROC[1]}
+			echo v4l qbuf vdev=vim type=VIDEO_OUTPUT >&${COPROC[1]}
+			echo v4l qbuf vdev=vim type=VIDEO_CAPTURE >&${COPROC[1]}
+			if ((${p[seq]} == 5)); then
+				echo <<EOF >&${COPROC[1]}
+				v4l streamoff vdev=vim type=VIDEO_CAPTURE
+				v4l streamoff vdev=vim type=VIDEO_OUTPUT
+				v4l reqbufs vdev=vim type=VIDEO_OUTPUT count=0
+				v4l reqbufs vdev=vim type=VIDEO_CAPTURE count=0
+				quit
+EOF
+				exit 0
+			fi
+		fi
+	;;
+	esac;
+done
-- 
2.7.4
