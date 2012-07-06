Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:40424 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750883Ab2GFM3P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 08:29:15 -0400
From: Federico Fuga <fuga@studiofuga.com>
To: linux-media@vger.kernel.org
Cc: Federico Fuga <fuga@studiofuga.com>
Subject: [PATCH] Cross compilation corrections and script
Date: Fri,  6 Jul 2012 14:27:41 +0200
Message-Id: <1341577661-12415-2-git-send-email-fuga@studiofuga.com>
In-Reply-To: <1341577661-12415-1-git-send-email-fuga@studiofuga.com>
References: <1341577661-12415-1-git-send-email-fuga@studiofuga.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch includes some corrections to makefiles and adds a script to be used when crosscompiling.
In particular, I introduced the option to specify the cross toolchain prefix, static linking and stripping
the binaries and specify eventually another jpeg library directory to be used instead of the current one.

./cross-compile.sh --help to have some help about.
---
 cross-compile.sh               |   56 ++++++++++++++++++++++++++++++++++++++++
 utils/Makefile                 |    2 ++
 utils/v4l2-compliance/Makefile |    6 ++++-
 utils/v4l2-ctl/Makefile        |   10 ++++---
 4 files changed, 70 insertions(+), 4 deletions(-)
 create mode 100755 cross-compile.sh

diff --git a/cross-compile.sh b/cross-compile.sh
new file mode 100755
index 0000000..22f47e5
--- /dev/null
+++ b/cross-compile.sh
@@ -0,0 +1,56 @@
+#!/bin/bash
+
+function help() {
+	cat << __END__
+Usage: $0 --host <cross-compiler-prefix> [--strip] [target]
+
+	--host <cross-compiler-prefix>	The toolchain prefix, for example: arm-linux-gnueabi
+						If required, you can define the complete path
+	--strip					Strip binaries (optional)
+	--with-jpeg-dir			Complete path to jpeg library installation (optional)
+	--static				Make compilation static (good for test on embedded systems) 
+						(optional)
+	target					The makefile target (clean, all, etc...)
+
+__END__
+}
+
+while [ "$END" == "" ] ; do
+	case "$1" in
+		--host)	
+			shift;
+			HOST="$1"
+			shift;
+			;;
+		--strip)
+			shift
+			STRIP="-s"
+			;;
+		--static)
+			OPT_LINKTYPE="LINKTYPE=static";
+			shift;
+			;;
+		--with-jpeg-dir)
+			shift
+			OPT_JPEG_INCLUDE="-I$1/include"
+			OPT_JPEG_LIB="-L$1/lib"
+			shift
+			;;
+		--help)
+			help $0
+			shift
+			exit 1
+			;;
+		*)
+			END=y
+			;;
+	esac
+done
+
+if [ "$HOST" == "" ] ; then
+	echo "--host is mandatory. $0 help to have assistance."
+	exit 1
+fi
+
+make CC="$HOST-gcc" LD="$HOST-g++" CXX="$HOST-g++" CFLAGS="$OPT_JPEG_INCLUDE" CPPFLAGS="$OPT_JPEG_INCLUDE" $OPT_LINKTYPE LDFLAGS="$STRIP $OPT_JPEG_LIB" NOQT4=y $@
+
diff --git a/utils/Makefile b/utils/Makefile
index 014b82d..565e46d 100644
--- a/utils/Makefile
+++ b/utils/Makefile
@@ -5,6 +5,7 @@ all install:
 		$(MAKE) -C $$i $@ || exit 1; \
 	done
 
+ifneq ($(NOQT4),y)
 	# Test whether qmake is installed, and whether it is for qt4.
 	@if which qmake-qt4 >/dev/null 2>&1; then \
 		QMAKE=qmake-qt4; \
@@ -19,6 +20,7 @@ all install:
 			$(MAKE) -C qv4l2 -f Makefile.install $@; \
 		fi \
 	fi
+endif
 
 sync-with-kernel:
 	$(MAKE) -C keytable $@
diff --git a/utils/v4l2-compliance/Makefile b/utils/v4l2-compliance/Makefile
index b65fc82..3a0cdc8 100644
--- a/utils/v4l2-compliance/Makefile
+++ b/utils/v4l2-compliance/Makefile
@@ -1,12 +1,16 @@
 TARGETS = v4l2-compliance
 
+ifeq ($(LINKTYPE),static)
+	EXTRA_LIBS=-ljpeg
+endif
+
 all: $(TARGETS)
 
 -include *.d
 
 v4l2-compliance: v4l2-compliance.o v4l2-test-debug.o v4l2-test-input-output.o \
 	v4l2-test-controls.o v4l2-test-io-config.o v4l2-test-formats.o
-	$(CXX) $(LDFLAGS) -o $@ $^ -lv4l2 -lv4lconvert -lrt
+	$(CXX) $(LDFLAGS) -o $@ $^ -lv4l2 -lv4lconvert -lrt $(EXTRA_LIBS)
 
 install: $(TARGETS)
 	mkdir -p $(DESTDIR)$(PREFIX)/bin
diff --git a/utils/v4l2-ctl/Makefile b/utils/v4l2-ctl/Makefile
index 5ea58c7..9f681f6 100644
--- a/utils/v4l2-ctl/Makefile
+++ b/utils/v4l2-ctl/Makefile
@@ -2,18 +2,22 @@ override CPPFLAGS += -DV4L_UTILS_VERSION=\"$(V4L_UTILS_VERSION)\"
 
 TARGETS = cx18-ctl ivtv-ctl v4l2-ctl
 
+ifeq ($(LINKTYPE),static)
+	EXTRA_LIBS=-ljpeg
+endif
+
 all: $(TARGETS)
 
 -include *.d
 
 cx18-ctl: cx18-ctl.o
-	$(CC) $(LDFLAGS) -o $@ $^
+	$(CC) $(LDFLAGS) -o $@ $^ $(EXTRA_LIBS) 
 
 ivtv-ctl: ivtv-ctl.o
-	$(CC) $(LDFLAGS) -o $@ $^ -lm
+	$(CC) $(LDFLAGS) -o $@ $^ -lm $(EXTRA_LIBS) 
 
 v4l2-ctl: v4l2-ctl.o
-	$(CXX) $(LDFLAGS) -o $@ $^ -lv4l2 -lv4lconvert -lrt
+	$(CXX) $(LDFLAGS) -o $@ $^ -lv4l2 -lv4lconvert -lrt $(EXTRA_LIBS) 
 
 install: $(TARGETS)
 	mkdir -p $(DESTDIR)$(PREFIX)/bin
-- 
1.7.9.5

