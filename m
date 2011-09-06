Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab1IFPaU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 11:30:20 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 07/10] Add mkinstalldirs
Date: Tue,  6 Sep 2011 12:29:53 -0300
Message-Id: <1315322996-10576-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1315322996-10576-6-git-send-email-mchehab@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
 <1315322996-10576-2-git-send-email-mchehab@redhat.com>
 <1315322996-10576-3-git-send-email-mchehab@redhat.com>
 <1315322996-10576-4-git-send-email-mchehab@redhat.com>
 <1315322996-10576-5-git-send-email-mchehab@redhat.com>
 <1315322996-10576-6-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is needed for make distcheck to be happy. Not sure why this
script is not here already... tvtime 1.0.2 tarball has it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 mkinstalldirs   |  111 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/Makefile.am |    3 +-
 2 files changed, 113 insertions(+), 1 deletions(-)
 create mode 100755 mkinstalldirs

diff --git a/mkinstalldirs b/mkinstalldirs
new file mode 100755
index 0000000..d2d5f21
--- /dev/null
+++ b/mkinstalldirs
@@ -0,0 +1,111 @@
+#! /bin/sh
+# mkinstalldirs --- make directory hierarchy
+# Author: Noah Friedman <friedman@prep.ai.mit.edu>
+# Created: 1993-05-16
+# Public domain
+
+errstatus=0
+dirmode=""
+
+usage="\
+Usage: mkinstalldirs [-h] [--help] [-m mode] dir ..."
+
+# process command line arguments
+while test $# -gt 0 ; do
+  case $1 in
+    -h | --help | --h*)         # -h for help
+      echo "$usage" 1>&2
+      exit 0
+      ;;
+    -m)                         # -m PERM arg
+      shift
+      test $# -eq 0 && { echo "$usage" 1>&2; exit 1; }
+      dirmode=$1
+      shift
+      ;;
+    --)                         # stop option processing
+      shift
+      break
+      ;;
+    -*)                         # unknown option
+      echo "$usage" 1>&2
+      exit 1
+      ;;
+    *)                          # first non-opt arg
+      break
+      ;;
+  esac
+done
+
+for file
+do
+  if test -d "$file"; then
+    shift
+  else
+    break
+  fi
+done
+
+case $# in
+  0) exit 0 ;;
+esac
+
+case $dirmode in
+  '')
+    if mkdir -p -- . 2>/dev/null; then
+      echo "mkdir -p -- $*"
+      exec mkdir -p -- "$@"
+    fi
+    ;;
+  *)
+    if mkdir -m "$dirmode" -p -- . 2>/dev/null; then
+      echo "mkdir -m $dirmode -p -- $*"
+      exec mkdir -m "$dirmode" -p -- "$@"
+    fi
+    ;;
+esac
+
+for file
+do
+  set fnord `echo ":$file" | sed -ne 's/^:\//#/;s/^://;s/\// /g;s/^#/\//;p'`
+  shift
+
+  pathcomp=
+  for d
+  do
+    pathcomp="$pathcomp$d"
+    case $pathcomp in
+      -*) pathcomp=./$pathcomp ;;
+    esac
+
+    if test ! -d "$pathcomp"; then
+      echo "mkdir $pathcomp"
+
+      mkdir "$pathcomp" || lasterr=$?
+
+      if test ! -d "$pathcomp"; then
+  	errstatus=$lasterr
+      else
+  	if test ! -z "$dirmode"; then
+	  echo "chmod $dirmode $pathcomp"
+    	  lasterr=""
+  	  chmod "$dirmode" "$pathcomp" || lasterr=$?
+
+  	  if test ! -z "$lasterr"; then
+  	    errstatus=$lasterr
+  	  fi
+  	fi
+      fi
+    fi
+
+    pathcomp="$pathcomp/"
+  done
+done
+
+exit $errstatus
+
+# Local Variables:
+# mode: shell-script
+# sh-indentation: 2
+# End:
+# mkinstalldirs ends here
diff --git a/src/Makefile.am b/src/Makefile.am
index 56e26a6..e48ef4c 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -45,7 +45,8 @@ COMMON_SRCS = mixer.c videoinput.c rtctimer.c leetft.c osdtools.c tvtimeconf.c \
 	utils.h utils.c pulldown.h pulldown.c hashtable.h hashtable.c \
 	cpuinfo.h cpuinfo.c menu.c menu.h \
 	outputfilter.h outputfilter.c xmltv.h xmltv.c gettext.h tvtimeglyphs.h \
-	copyfunctions.h copyfunctions.c alsa_stream.c mixer-oss.c $(ALSA_SRCS)
+	copyfunctions.h copyfunctions.c alsa_stream.c alsa_stream.h \
+	mixer-oss.c $(ALSA_SRCS)
 
 if ARCH_X86
 DSCALER_SRCS = $(top_srcdir)/plugins/dscalerapi.h \
-- 
1.7.6.1

