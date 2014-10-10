Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40278 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaJJUeK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 16:34:10 -0400
Date: Fri, 10 Oct 2014 17:34:02 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Upcoming v4l-utils 1.6.0 release
Message-ID: <20141010173402.7095e5fb@recife.lan>
In-Reply-To: <54319E45.3050906@googlemail.com>
References: <20140925213820.1bbf43c2@recife.lan>
	<54269807.50109@googlemail.com>
	<20140927085455.5b0baf89@recife.lan>
	<542ACA32.3050403@googlemail.com>
	<542ADA66.3040905@redhat.com>
	<20141004112245.7a5de7de@recife.lan>
	<54319E45.3050906@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

Em Sun, 05 Oct 2014 21:38:45 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello,
> 
> On 04/10/14 16:22, Mauro Carvalho Chehab wrote:
> > Em Tue, 30 Sep 2014 18:29:26 +0200
> > Hans de Goede <hdegoede@redhat.com> escreveu:
> >> About the 1.6.0 release, please do not release it until the series
> >> fixing the regression in 1.4.0 with gstreamer which I've posted
> >> today. A review of that series would be appreciated. If you're ok
> >> with the series feel free to push it to master.
> 
> I pushed the changes to master ans built a Debian package with the
> changes. The bug reported verified that it properly fixed the bug.

While waiting for this package to get enough carma to merge it on F21,
I was wandering that, as we don't quite follow http://semver.org/
versioning, we should document it. So, I wrote the enclosed patch.

Please review.

Regards,
Mauro

README: better document the package

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>


diff --git a/README b/README
index a9f8089..f12b37d 100644
--- a/README
+++ b/README
@@ -1,20 +1,124 @@
 v4l-utils
 ---------
 
-Linux V4L2 and DVB API utilities and v4l libraries (libv4l).
+Linux utilities and libraries to handle media devices (TV devices,
+capture devices, radio devices, remote controllers).
+
 You can always find the latest development v4l-utils in the git repo:
-http://git.linuxtv.org/v4l-utils.git
+	http://git.linuxtv.org/v4l-utils.git
 
+Those utilities follow the latest Linux Kernel media API, as documented
+at:
+	http://linuxtv.org/downloads/v4l-dvb-apis/
 
-v4l libraries (libv4l, libdvbv5)
---------------------------------
+----------
+versioning
+----------
 
-See README.libv4l for more information on libv4l, libv4l is released
-under the GNU Lesser General Public License.
+The v4l-utils doesn't quite follow the release versioning defined
+at semver.org.
 
+Instead, since version 1.0, it uses:
 
-v4l-utils
+	MAJOR.MINOR.PATCH
+
+Where:
+
+	MINOR - an odd number means a development version. When
+		the development is closed, we release an even
+		numbered version and start a newer odd version;
+
+	MAJOR - It is incremented when MINOR number starts to be
+		too big. The last change occurred from 0.9.x to 1.0.
+
+	All numbers start with 0.
+
+All versions have their own tags, except for the current
+deveopment version (with uses the master branch at the git tree).
+
+The PATCH meaning actually depends if the version is stable
+or developent.
+
+For even MAJOR.MINOR versions (1.0, 1.2, 1.4, 1.6, ...)
+
+	PATCH is incremented when just bug fixes are added;
+
+For odd MAJOR.MINOR versions (1.1, 1.3, 1.5, 1.7, ...)
+	PATCH is incremented for release candidate versions.
+
+API/ABI stability:
+-----------------
+
+There should not have any API/ABI changes when PATCH is incremented.
+
+When MAJOR and/or MINOR are incremented, the API/ABI for the
+libraries might change, although we do all the efforts for not
+doing it, except when inevitable.
+
+The TODO files should specify the events that will generate
+API/ABI breaks.
+
+---------------
+media libraries
+---------------
+
+There are currently three media libraries defined at /lib directory,
+meant to be used internally and by other applications.
+
+libv4l
+------
+
+This library is meant to be used by applications that need to
+talk with V4L2 devices (webcams, analog TV, stream grabbers).
+
+It can be found on the following directories:
+	lib/libv4l1
+	lib/libv4l2
+	lib/libv4l-mplane
+	lib/libv4lconvert
+
+See README.libv4l for more information on libv4l.
+
+The libv4l is released under the GNU Lesser General Public License.
+
+libdvbv5
+--------
+
+This library is meant to be used by digital TV applications that
+need to talk with media hardware.
+
+Full documentation is provided via Doxygen. It can be built,
+after configuring the package, with:
+	$ make doxygen-run
+
+It is possible to generate documentation in html, man pages and pdf
+formats.
+
+The documentation is also available via web, at:
+	http://linuxtv.org/docs/libdvbv5/
+
+It can be found on the following directory:
+	lib/libdvbv5
+
+The libdvbv5 is released under GPL version 2.
+
+
+libv4l2rds
+----------
+
+This library provides support for RDS radio applications.
+
+It can be found on the following directory:
+	lib/libv4l2rds
+
+The libv4l is released under the GNU Lesser General Public License.
+
+---------
+Utilities
 ---------
+
+The utilities are stored under /util directory.
+
 The (for now for v4l-utils private use only) libv4l2util library is
 released under the GNU Lesser General Public License, all other code is
 released under the GNU General Public License.
