Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3HM8gP4007672
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 18:08:42 -0400
Received: from mylar.outflux.net (mylar.outflux.net [69.93.193.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3HM8VhM004826
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 18:08:32 -0400
Received: from www.outflux.net (serenity-end.outflux.net [10.2.0.2])
	by mylar.outflux.net (8.13.8/8.13.8/Debian-3) with ESMTP id
	m3HM8FhX028231
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 15:08:20 -0700
Date: Thu, 17 Apr 2008 15:08:15 -0700
From: Kees Cook <kees@outflux.net>
To: video4linux-list@redhat.com
Message-ID: <20080417220815.GQ18929@outflux.net>
References: <20080417012346.GG18929@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417012346.GG18929@outflux.net>
Subject: Re: [PATCH 0/2] V4L: add "function" sysfs attribute to v4l devices
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, Apr 16, 2008 at 06:23:46PM -0700, Kees Cook wrote:
> [2] some recent discussion on the new hotplug list, but I can't find an
>     archive link since it moved to vger...

Since I can't link to it, I'll just include the udev patches here too.
:)

---
Update of path_id and example symlink-creation update for udev to take
advantage of the new "function" string exported from video4linux
devices.

Signed-off-by: Kees Cook <kees@outflux.net>
---
 debian/rules.d/60-symlinks.rules |    9 +++++++++
 extras/path_id/path_id           |   14 ++++++++++++++
 2 files changed, 23 insertions(+)

--- udev-113/debian/rules.d/60-symlinks.rules~	2008-04-16 17:02:58.000000000 -0700
+++ udev-113/debian/rules.d/60-symlinks.rules	2008-04-16 17:04:32.000000000 -0700
@@ -14,3 +14,12 @@
 # Create /dev/pilot symlink for Palm Pilots
 KERNEL=="ttyUSB*", ATTRS{product}=="Palm Handheld*|Handspring *|palmOne Handheld", \
 					SYMLINK+="pilot"
+
+# Create video4linux PCI path symlinks
+ACTION!="add", GOTO="video4linux_path_end"
+SUBSYSTEM!="video4linux", GOTO="video4linux_path_end"
+
+IMPORT{program}="path_id %p"
+ENV{ID_PATH}=="?*", KERNEL=="video*", SYMLINK+="v4l/by-path/$env{ID_PATH}"
+
+LABEL="video4linux_path_end"
--- udev-113/extras/path_id/path_id~	2007-06-23 08:44:48.000000000 -0700
+++ udev-113/extras/path_id/path_id	2008-04-16 17:10:23.000000000 -0700
@@ -462,6 +462,10 @@
 	full_sysfs_device_path="`pwd -P`"
 	cd "$OPWD"
 
+	if [ "$TYPE" = "video4linux" ] ; then
+		d="video"
+	fi
+
 	D=$full_sysfs_device_path
 	while [ ! -z "$D" ] ; do
 		case "$D" in
@@ -566,6 +570,16 @@
 		handle_device
 		echo "ID_PATH=$d"
 		;;
+	video4linux)
+		handle_device
+		if [ "$d" ]; then
+			# Only report v4l devices that have a "function" defined
+			func=$(cat $SYSFS$DEVPATH/function 2>/dev/null ||true)
+			if [ "$func" ]; then
+				echo "ID_PATH=$d-$func"
+			fi
+		fi
+		;;
 	*)
 		RESULT=1
 		;;


-- 
Kees Cook                                            @outflux.net

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
