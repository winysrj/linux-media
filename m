Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41181 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbaLNLlL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 06:41:11 -0500
Message-ID: <548D774A.4030902@xs4all.nl>
Date: Sun, 14 Dec 2014 12:40:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [git:v4l-utils/master] Update INSTALL instructions and add a
 script to configure
References: <E1Y07L2-0005cD-72@www.linuxtv.org>
In-Reply-To: <E1Y07L2-0005cD-72@www.linuxtv.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/14/2014 12:26 PM, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/cgit.cgi/v4l-utils.git tree:
> 
> Subject: Update INSTALL instructions and add a script to configure
> Author:  Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Date:    Sun Dec 14 09:26:20 2014 -0200
> 
> Just running autoconf -vfi will override some needed configs
> at libdvbv5-po. So, add a bootstrap.sh script and document it.

FYI: after running ./bootstrap.sh I get the diff shown below if I run 'git diff'.
That suggests that there are autogenerated files in the git repo that do
not belong there.

I also see following message twice when running bootstrap:

-------
Please create libdvbv5-po/Makevars from the template in libdvbv5-po/Makevars.template.
You can then remove libdvbv5-po/Makevars.template.

Please run 'aclocal -I m4' to regenerate the aclocal.m4 file.
You need aclocal from GNU automake 1.9 (or newer) to do this.
Then run 'autoconf' to regenerate the configure file.

You might also want to copy the convenience header file gettext.h
from the /usr/share/gettext directory into your package.
It is a wrapper around <libintl.h> that implements the configure --disable-nls
option.

Press Return to acknowledge the previous three paragraphs.
--------

Regards,

	Hans

git diff output:

diff --git a/build-aux/config.rpath b/build-aux/config.rpath
index c38b914..ab6fd99 100755
--- a/build-aux/config.rpath
+++ b/build-aux/config.rpath
@@ -2,7 +2,7 @@
 # Output a system dependent set of variables, describing how to set the
 # run time search path of shared libraries in an executable.
 #
-#   Copyright 1996-2013 Free Software Foundation, Inc.
+#   Copyright 1996-2014 Free Software Foundation, Inc.
 #   Taken from GNU libtool, 2001
 #   Originally by Gordon Matzigkeit <gord@gnu.ai.mit.edu>, 1996
 #
diff --git a/configure.ac b/configure.ac
index d2ace79..bade69f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -78,7 +78,7 @@ DX_DOT_FEATURE(ON)
 DX_INIT_DOXYGEN($PACKAGE_NAME, doxygen_libdvbv5.cfg)
 ALL_LINGUAS=""
 AM_GNU_GETTEXT([external])
-AM_GNU_GETTEXT_VERSION([0.19])
+AM_GNU_GETTEXT_VERSION([0.19.3])
 
 LIBDVBV5_DOMAIN="libdvbv5"
 AC_DEFINE([LIBDVBV5_DOMAIN], "libdvbv5", [libdvbv5 domain])
diff --git a/libdvbv5-po/Makefile.in.in b/libdvbv5-po/Makefile.in.in
index 549e12e..4e265b2 100644
--- a/libdvbv5-po/Makefile.in.in
+++ b/libdvbv5-po/Makefile.in.in
@@ -374,7 +374,7 @@ mostlyclean:
 clean: mostlyclean
 
 distclean: clean
-	rm -f Makefile.in POTFILES *.mo
+	 rm -f Makefile.in POTFILES *.mo
 
 maintainer-clean: distclean
 	@echo "This command is intended for maintainers to use;"
diff --git a/libdvbv5-po/Makevars.template b/libdvbv5-po/Makevars.template
index 4a9ff7d..0648ec7 100644
--- a/libdvbv5-po/Makevars.template
+++ b/libdvbv5-po/Makevars.template
@@ -20,6 +20,13 @@ XGETTEXT_OPTIONS = --keyword=_ --keyword=N_
 # their copyright.
 COPYRIGHT_HOLDER = Free Software Foundation, Inc.
 
+# This tells whether or not to prepend "GNU " prefix to the package
+# name that gets inserted into the header of the $(DOMAIN).pot file.
+# Possible values are "yes", "no", or empty.  If it is empty, try to
+# detect it automatically by scanning the files in $(top_srcdir) for
+# "GNU packagename" string.
+PACKAGE_GNU =
+
 # This is the email address or URL to which the translators shall report
 # bugs in the untranslated strings:
 # - Strings which are not entire sentences, see the maintainer guidelines
@@ -51,3 +58,21 @@ USE_MSGCTXT = no
 #   --previous            to keep previous msgids of translated messages,
 #   --quiet               to reduce the verbosity.
 MSGMERGE_OPTIONS =
+
+# These options get passed to msginit.
+# If you want to disable line wrapping when writing PO files, add
+# --no-wrap to MSGMERGE_OPTIONS, XGETTEXT_OPTIONS, and
+# MSGINIT_OPTIONS.
+MSGINIT_OPTIONS =
+
+# This tells whether or not to regenerate a PO file when $(DOMAIN).pot
+# has changed.  Possible values are "yes" and "no".  Set this to no if
+# the POT file is checked in the repository and the version control
+# program ignores timestamps.
+PO_DEPENDS_ON_POT = yes
+
+# This tells whether or not to forcibly update $(DOMAIN).pot and
+# regenerate PO files on "make dist".  Possible values are "yes" and
+# "no".  Set this to no if the POT file and PO files are maintained
+# externally.
+DIST_DEPENDS_ON_UPDATE_PO = yes
diff --git a/libdvbv5-po/Rules-quot b/libdvbv5-po/Rules-quot
index 7b92c7e..9dc9630 100644
--- a/libdvbv5-po/Rules-quot
+++ b/libdvbv5-po/Rules-quot
@@ -21,7 +21,7 @@ en@boldquot.po-update: en@boldquot.po-update-en
 	ll=`echo $$lang | sed -e 's/@.*//'`; \
 	LC_ALL=C; export LC_ALL; \
 	cd $(srcdir); \
-	if $(MSGINIT) -i $(DOMAIN).pot --no-translator -l $$lang -o - 2>/dev/null \
+	if $(MSGINIT) $(MSGINIT_OPTIONS) -i $(DOMAIN).pot --no-translator -l $$lang -o - 2>/dev/null \
 	   | $(SED) -f $$tmpdir/$$lang.insert-header | $(MSGCONV) -t UTF-8 | \
 	   { case `$(MSGFILTER) --version | sed 1q | sed -e 's,^[^0-9]*,,'` in \
 	     '' | 0.[0-9] | 0.[0-9].* | 0.1[0-8] | 0.1[0-8].*) \
diff --git a/v4l-utils-po/Makefile.in.in b/v4l-utils-po/Makefile.in.in
index 9d3fd4e..ed7581c 100644
--- a/v4l-utils-po/Makefile.in.in
+++ b/v4l-utils-po/Makefile.in.in
@@ -374,7 +374,7 @@ mostlyclean:
 clean: mostlyclean
 
 distclean: clean
-	rm -f Makefile.in POTFILES *.mo
+	 rm -f Makefile.in POTFILES *.mo
 
 maintainer-clean: distclean
 	@echo "This command is intended for maintainers to use;"
diff --git a/v4l-utils-po/Rules-quot b/v4l-utils-po/Rules-quot
index 7b92c7e..9dc9630 100644
--- a/v4l-utils-po/Rules-quot
+++ b/v4l-utils-po/Rules-quot
@@ -21,7 +21,7 @@ en@boldquot.po-update: en@boldquot.po-update-en
 	ll=`echo $$lang | sed -e 's/@.*//'`; \
 	LC_ALL=C; export LC_ALL; \
 	cd $(srcdir); \
-	if $(MSGINIT) -i $(DOMAIN).pot --no-translator -l $$lang -o - 2>/dev/null \
+	if $(MSGINIT) $(MSGINIT_OPTIONS) -i $(DOMAIN).pot --no-translator -l $$lang -o - 2>/dev/null \
 	   | $(SED) -f $$tmpdir/$$lang.insert-header | $(MSGCONV) -t UTF-8 | \
 	   { case `$(MSGFILTER) --version | sed 1q | sed -e 's,^[^0-9]*,,'` in \
 	     '' | 0.[0-9] | 0.[0-9].* | 0.1[0-8] | 0.1[0-8].*) \


