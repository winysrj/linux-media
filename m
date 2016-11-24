Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56962 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757204AbcKXOdA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 09:33:00 -0500
Date: Thu, 24 Nov 2016 16:32:26 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com
Subject: Re: [PATCH v4l-utils v7 4/7] mediactl: Add media_device creation
 helpers
Message-ID: <20161124143226.GR16630@valkosipuli.retiisi.org.uk>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-5-git-send-email-j.anaszewski@samsung.com>
 <CGME20161124121817epcas3p24fa27e9afedce6356c75bf3e63730432@epcas3p2.samsung.com>
 <20161124121731.GF16630@valkosipuli.retiisi.org.uk>
 <65435934-bbbd-83ac-b101-63244c1a5651@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65435934-bbbd-83ac-b101-63244c1a5651@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Thu, Nov 24, 2016 at 02:50:39PM +0100, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> Thanks for the review.
> 
> On 11/24/2016 01:17 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >Thanks for the patchset.
> >
> >On Wed, Oct 12, 2016 at 04:35:19PM +0200, Jacek Anaszewski wrote:
> >>Add helper functions that allow for easy instantiation of media_device
> >>object basing on whether the media device contains v4l2 subdev with
> >>given file descriptor.
> >
> >Doesn't this work with video nodes as well? That's what you seem to be using
> >it for later on. And I think that's actually more useful.
> 
> Exactly, thanks for spotting this.
> 
> s/v4l2 subdev/video device opened/
> 
> >
> >The existing implementation uses udev to look up devices. Could you use
> >libudev device enumeration API to find the media devices, and fall back to
> >sysfs if udev doesn't work? There seems to be a reasonable-looking example
> >here:
> >
> ><URL:http://stackoverflow.com/questions/25361042/how-to-list-usb-mass-storage-devices-programatically-using-libudev-in-linux>
> 
> I'll check that, thanks.
> 
> >>
> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>---
> >> utils/media-ctl/libmediactl.c | 131 +++++++++++++++++++++++++++++++++++++++++-
> >> utils/media-ctl/mediactl.h    |  27 +++++++++
> >> 2 files changed, 156 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
> >>index 155b65f..d347a40 100644
> >>--- a/utils/media-ctl/libmediactl.c
> >>+++ b/utils/media-ctl/libmediactl.c
> >>@@ -27,6 +27,7 @@
> >> #include <sys/sysmacros.h>
> >>
> >> #include <ctype.h>
> >>+#include <dirent.h>
> >> #include <errno.h>
> >> #include <fcntl.h>
> >> #include <stdbool.h>
> >>@@ -440,8 +441,9 @@ static int media_get_devname_udev(struct udev *udev,
> >> 		return -EINVAL;
> >>
> >> 	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
> >>-	media_dbg(entity->media, "looking up device: %u:%u\n",
> >>-		  major(devnum), minor(devnum));
> >>+	if (entity->media)
> >>+		media_dbg(entity->media, "looking up device: %u:%u\n",
> >>+			  major(devnum), minor(devnum));
> >> 	device = udev_device_new_from_devnum(udev, 'c', devnum);
> >> 	if (device) {
> >> 		p = udev_device_get_devnode(device);
> >>@@ -523,6 +525,7 @@ static int media_get_devname_sysfs(struct media_entity *entity)
> >> 	return 0;
> >> }
> >>
> >>+
> >
> >Unrelated change.
> >
> >> static int media_enum_entities(struct media_device *media)
> >> {
> >> 	struct media_entity *entity;
> >>@@ -707,6 +710,92 @@ struct media_device *media_device_new(const char *devnode)
> >> 	return media;
> >> }
> >>
> >>+struct media_device *media_device_new_by_subdev_fd(int fd, struct media_entity **fd_entity)
> >>+{
> >>+	char video_devname[32], device_dir_path[256], media_dev_path[256], media_major_minor[10];
> >>+	struct media_device *media = NULL;
> >>+	struct dirent *entry;
> >>+	struct media_entity tmp_entity;
> >>+	DIR *device_dir;
> >>+	struct udev *udev;
> >>+	char *p;
> >>+	int ret, i;
> >>+
> >>+	if (fd_entity == NULL)
> >>+		return NULL;
> >>+
> >>+	ret = media_get_devname_by_fd(fd, video_devname);
> >>+	if (ret < 0)
> >>+		return NULL;
> >>+
> >>+	p = strrchr(video_devname, '/');
> >>+	if (p == NULL)
> >>+		return NULL;
> >>+
> >>+	ret = media_udev_open(&udev);
> >>+	if (ret < 0)
> >>+		return NULL;
> >>+
> >>+	sprintf(device_dir_path, "/sys/class/video4linux/%s/device/", p + 1);
> >>+
> >>+	device_dir = opendir(device_dir_path);
> >>+	if (device_dir == NULL)
> >>+		return NULL;
> >>+
> >>+	while ((entry = readdir(device_dir))) {
> >>+		if (strncmp(entry->d_name, "media", 4))
> >
> >Why 4? And isn't entry->d_name nul-terminated, so you could use strcmp()?
> 
> Media devices, as other devices, have numerical postfix, which is
> not of our interest.

Right. But still 5 would be the right number as we should also check the
last "a".

> 
> >>+			continue;
> >>+
> >>+		sprintf(media_dev_path, "%s%s/dev", device_dir_path, entry->d_name);
> >>+
> >>+		fd = open(media_dev_path, O_RDONLY);
> >>+		if (fd < 0)
> >>+			continue;
> >>+
> >>+		ret = read(fd, media_major_minor, sizeof(media_major_minor));
> >>+		if (ret < 0)
> >>+			continue;
> >>+
> >>+		sscanf(media_major_minor, "%d:%d", &tmp_entity.info.dev.major, &tmp_entity.info.dev.minor);
> >
> >This would be better split on two lines.
> 
> OK.
> 
> >>+
> >>+		/* Try to get the device name via udev */
> >>+		if (media_get_devname_udev(udev, &tmp_entity)) {
> >>+			/* Fall back to get the device name via sysfs */
> >>+			if (media_get_devname_sysfs(&tmp_entity))
> >>+				continue;
> >>+		}
> >>+
> >>+		media = media_device_new(tmp_entity.devname);
> >>+		if (media == NULL)
> >>+			continue;
> >>+
> >>+		ret = media_device_enumerate(media);
> >>+		if (ret < 0) {
> >>+			media_dbg(media, "Failed to enumerate %s (%d)\n",
> >>+				  tmp_entity.devname, ret);
> >>+			media_device_unref(media);
> >>+			media = NULL;
> >>+			continue;
> >>+		}
> >>+
> >>+		/* Get the entity associated with given fd */
> >>+		for (i = 0; i < media->entities_count; i++) {
> >>+			struct media_entity *entity = &media->entities[i];
> >>+
> >>+			if (!strcmp(entity->devname, video_devname)) {
> >>+				*fd_entity = &media->entities[i];
> >>+				break;
> >>+			}
> >>+		}
> >
> >What if you exit the loop without finding the entity you were looking for?
> 
> Ah, right, this case is unhandled.
> 
> Adding below condition should cover that:
> 
> if (i == media->entities_count)
>     media = NULL;

and media_device_unref()?

You could have a label for handling that at the end of the loop basic block
so you could implement handling of that just once to avoid such issues in
the future.

> 
> >>+
> >>+		break;
> 
> This break should be removed and the one in the inner for loop above
> should be replaced with goto here. Are you OK with that?

Um, yeah. There are indeed two loops. In Perl you could get out nicely but
in C we have to do something else. Two labels perhaps?

> 
> >>+	}
> >>+
> >>+	media_udev_close(udev);
> >>+
> >>+	return media;
> >>+}
> >>+
> >> struct media_device *media_device_new_emulated(struct media_device_info *info)
> >> {
> >> 	struct media_device *media;

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
