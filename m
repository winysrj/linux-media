Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbcBNNBQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2016 08:01:16 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 1EEDC8E24E
	for <linux-media@vger.kernel.org>; Sun, 14 Feb 2016 13:01:16 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 2/2] Remove redhat packaging files
Date: Sun, 14 Feb 2016 14:01:08 +0100
Message-Id: <1455454868-28512-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455454868-28512-1-git-send-email-hdegoede@redhat.com>
References: <1455454868-28512-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are no longer used by the Red Hat / Fedora pkgs.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 redhat/custom-tvtime.desktop |  8 ----
 redhat/tvtime-0.9.6.spec     | 36 ------------------
 redhat/tvtime-0.9.7.spec     | 87 --------------------------------------------
 3 files changed, 131 deletions(-)
 delete mode 100644 redhat/custom-tvtime.desktop
 delete mode 100644 redhat/tvtime-0.9.6.spec
 delete mode 100644 redhat/tvtime-0.9.7.spec

diff --git a/redhat/custom-tvtime.desktop b/redhat/custom-tvtime.desktop
deleted file mode 100644
index 9c35ae2..0000000
--- a/redhat/custom-tvtime.desktop
+++ /dev/null
@@ -1,8 +0,0 @@
-[Desktop Entry]
-Comment=High quality TV viewer
-Icon=tvtime-logo.png
-Exec=tvtime
-Name=Television Viewer
-Terminal=0
-Type=Application
-Categories=Application;AudioVideo;
diff --git a/redhat/tvtime-0.9.6.spec b/redhat/tvtime-0.9.6.spec
deleted file mode 100644
index a995e09..0000000
--- a/redhat/tvtime-0.9.6.spec
+++ /dev/null
@@ -1,36 +0,0 @@
-Summary: A high quality TV viewer.
-Name: tvtime
-Version: 0.9.6
-Release: 1
-URL: http://tvtime.sourceforge.net
-Source0: %{name}-%{version}.tar.gz
-License: GPL
-Group: Applications/Multimedia
-BuildRoot: %{_tmppath}/%{name}-root
-
-%description
-tvtime is a high quality television application for use with video capture cards. tvtime processes the input from a capture card and displays it on a computer monitor or projector.
-
-%prep
-%setup -q
-
-%build
-%configure
-make %{_smp_mflags}
-
-%install
-rm -rf %{buildroot}
-%makeinstall
-
-%clean
-rm -rf %{buildroot}
-
-%files
-%defattr(-,root,root)
-%doc AUTHORS BUGS COPYING ChangeLog INSTALL NEWS README ./docs/DESIGN ./docs/TODO
-%{_bindir}/tvtime
-%{_datadir}/tvtime
-
-%changelog
-* Thu Nov 14 2002 Paul Jara
-- Initial build.
diff --git a/redhat/tvtime-0.9.7.spec b/redhat/tvtime-0.9.7.spec
deleted file mode 100644
index 01c0995..0000000
--- a/redhat/tvtime-0.9.7.spec
+++ /dev/null
@@ -1,87 +0,0 @@
-# Some useful constants
-%define ver 0.9.7
-#%define beta beta
-%define rpm_ver 2
-%define rh_addon tvtime-redhat.tar.gz
-%define docsdir docs
-%define rhdocsdir redhat
-%define icon %{docsdir}/tvtime-icon-black.png
-%define desktop_filename %{rhdocsdir}/custom-tvtime.desktop
-
-# Check if we're running RedHat 8.0 or higher
-%{!?rh_ver:%define rh_ver %(cut -d' ' -f5 /etc/redhat-release )}
-
-Summary: A high quality TV viewer.
-Name: tvtime
-Version: %{ver}
-Release: %{!?beta:0.%{beta}.}%{rpm_ver}
-URL: http://%{name}.sourceforge.net
-Source0: %{name}-%{version}.tar.gz
-Source1: %{rh_addon}
-License: GPL
-Group: Applications/Multimedia
-BuildRoot: %{_tmppath}/%{name}-root
-BuildRequires: freetype-devel zlib-devel libstdc++-devel libpng-devel XFree86-libs libgcc freetype-devel glibc-debug textutils
-Requires: sh-utils desktop-file-utils
-
-%description
-%{name} is a high quality television application for use with video capture cards. %{name} processes the input from a capture card and displays it on a computer monitor or projector.
-
-%prep
-%setup -q -b1
-
-%build
-%configure
-%{__make} %{_smp_mflags}
-
-%install
-%{__rm} -rf %{buildroot}
-%makeinstall
-
-# Remove freefont source from binary
-%{__rm} %{buildroot}%{_datadir}/%{name}/freefont-sfd.tar.gz
-
-# On RedHat 8.0+ distributions, add a menu entry
-%if "%{rh_ver}" >= "8.0"
-
-# Copy icon
-install -D -m 644 %{icon} %{buildroot}%{_datadir}/pixmaps/%{name}-logo.png
-
-# Copy desktop file
-%{__mkdir_p} %{buildroot}%{_datadir}/applications
-desktop-file-install --vendor custom --delete-original --dir %{buildroot}%{_datadir}/applications --add-category X-Red-Hat-Extra --add-category Application --add-category AudioVideo %{desktop_filename}
-%endif
-
-# Add man pages
-%{__mkdir_p} %{_mandir}/man1
-%{__mkdir_p} %{_mandir}/man5
-install -D -m 644 %{docsdir}/%{name}.1 %{buildroot}%{_mandir}/man1/%{name}.1
-install -D -m 644 %{docsdir}/%{name}rc.5 %{buildroot}%{_mandir}/man5/%{name}rc.5
-%clean
-%{__rm} -rf %{buildroot}
-
-%files
-%defattr(-,root,root)
-%doc AUTHORS BUGS COPYING ChangeLog INSTALL NEWS README docs/DESIGN docs/default.tvtimerc
-%{_bindir}/%{name}
-%{_datadir}/%{name}
-%{_datadir}/pixmaps/%{name}-logo.png
-%{_datadir}/applications/*%{name}.desktop
-%{_mandir}/man1/%{name}.1*
-%{_mandir}/man5/%{name}rc.5*
-
-%changelog
-* Thu Feb 27 2003 Paul Jara <rascasse at users.sourceforge.net>
-- Binary RPM no longer contains freefont source code
-* Wed Feb 26 2003 Paul Jara <rascasse at users.sourceforge.net>
-- Initial build with official tvtime 0.9.7 source
-* Mon Feb 24 2003 Paul Jara <rascasse at users.sourceforge.net>
-- Added default.tvtimerc to docs directory
-- Sync'd with latest CVS version
-- tvscanner replaced with timingtest
-* Mon Feb 24 2003 Paul Jara <rascasse at users.sourceforge.net>
-- Added man pages for tvtime and tvtimerc
-- Macro-ized some common shell commands
-- Added icon and menu entry for RedHat 8.0+
-* Sun Feb 23 2003 Paul Jara <rascasse at users.sourceforge.net>
-- Initial build.
-- 
2.7.1

