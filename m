Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36476 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751118AbcCTXjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2016 19:39:12 -0400
Date: Mon, 21 Mar 2016 01:39:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 01/15] mediactl: Introduce v4l2_subdev structure
Message-ID: <20160320233903.GD11084@valkosipuli.retiisi.org.uk>
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
 <1453133860-21571-2-git-send-email-j.anaszewski@samsung.com>
 <56BDD32D.5010105@linux.intel.com>
 <56C5D204.9040101@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56C5D204.9040101@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Thu, Feb 18, 2016 at 03:15:32PM +0100, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> Thanks for the review.
> 
> On 02/12/2016 01:42 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >Thanks for continuing this work! And my apologies for reviewing only
> >now... please see the comments below.
> >
> >Jacek Anaszewski wrote:
> >>Add struct v4l2_subdev - a representation of the v4l2 sub-device,
> >>related to the media entity. Add field 'sd', the pointer to
> >>the newly introduced structure, to the struct media_entity
> >>and move 'fd' property from struct media entity to struct v4l2_subdev.
> >>Avoid accessing sub-device file descriptor from libmediactl and
> >>make the v4l2_subdev_open capable of creating the v4l2_subdev
> >>if the 'sd' pointer is uninitialized.
> >>
> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>---
> >>  utils/media-ctl/libmediactl.c   |    4 --
> >>  utils/media-ctl/libv4l2subdev.c |   82 +++++++++++++++++++++++++++++++--------
> >>  utils/media-ctl/mediactl-priv.h |    5 ++-
> >>  utils/media-ctl/v4l2subdev.h    |   38 ++++++++++++++++++
> >>  4 files changed, 107 insertions(+), 22 deletions(-)
> >>
> >>diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
> >>index 4a82d24..7e98440 100644
> >>--- a/utils/media-ctl/libmediactl.c
> >>+++ b/utils/media-ctl/libmediactl.c
> >>@@ -525,7 +525,6 @@ static int media_enum_entities(struct media_device *media)
> >>
> >>  		entity = &media->entities[media->entities_count];
> >>  		memset(entity, 0, sizeof(*entity));
> >>-		entity->fd = -1;
> >>  		entity->info.id = id | MEDIA_ENT_ID_FLAG_NEXT;
> >>  		entity->media = media;
> >>
> >>@@ -719,8 +718,6 @@ void media_device_unref(struct media_device *media)
> >>
> >>  		free(entity->pads);
> >>  		free(entity->links);
> >>-		if (entity->fd != -1)
> >>-			close(entity->fd);
> >>  	}
> >>
> >>  	free(media->entities);
> >>@@ -747,7 +744,6 @@ int media_device_add_entity(struct media_device *media,
> >>  	entity = &media->entities[media->entities_count - 1];
> >>  	memset(entity, 0, sizeof *entity);
> >>
> >>-	entity->fd = -1;
> >>  	entity->media = media;
> >>  	strncpy(entity->devname, devnode, sizeof entity->devname);
> >>  	entity->devname[sizeof entity->devname - 1] = '\0';
> >>diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
> >>index 33c1ee6..3977ce5 100644
> >>--- a/utils/media-ctl/libv4l2subdev.c
> >>+++ b/utils/media-ctl/libv4l2subdev.c
> >>@@ -39,13 +39,61 @@
> >>  #include "tools.h"
> >>  #include "v4l2subdev.h"
> >>
> >>+int v4l2_subdev_create(struct media_entity *entity)
> >>+{
> >>+	if (entity->sd)
> >>+		return 0;
> >>+
> >>+	entity->sd = calloc(1, sizeof(*entity->sd));
> >>+	if (entity->sd == NULL)
> >>+		return -ENOMEM;
> >>+
> >>+	entity->sd->fd = -1;
> >>+
> >>+	return 0;
> >>+}
> >>+
> >>+int v4l2_subdev_create_with_fd(struct media_entity *entity, int fd)
> >>+{
> >>+	int ret;
> >>+
> >>+	if (entity->sd)
> >>+		return -EEXIST;
> >>+
> >>+	ret = v4l2_subdev_create(entity);
> >>+	if (ret < 0)
> >>+		return ret;
> >>+
> >>+	entity->sd->fd = fd;
> >>+
> >>+	return 0;
> >>+}
> >>+
> >>+void v4l2_subdev_release(struct media_entity *entity, bool close_fd)
> >>+{
> >>+	if (entity->sd == NULL)
> >>+		return;
> >>+
> >>+	if (close_fd)
> >>+		v4l2_subdev_close(entity);
> >>+
> >>+	free(entity->sd->v4l2_control_redir);
> >>+	free(entity->sd);
> >>+}
> >>+
> >>  int v4l2_subdev_open(struct media_entity *entity)
> >>  {
> >>-	if (entity->fd != -1)
> >>+	int ret;
> >>+
> >>+	ret = v4l2_subdev_create(entity);
> >
> >The current users of v4l2_subdev_open() in libv4l2subdev do not
> >explicitly close the sub-devices they open; thus calling
> >v4l2_subdev_create() here creates a memory leak.
> 
> Currently in my use cases there is no memory leak since I assumed
> that the one who instantiates struct media_device should take
> care of releasing it properly. I added v4l2_subdev_open_pipeline()
> and v4l2_subdev_release_pipeline() API that is called on plugin
> init and close respectively.

I'm referring to the use of the libv4l2subdev API as it's documented; the
media-ctl test program which also serves as a good example on the API.

Any sub-device IOCTL wrapper function will call v4l2_subdev_open() which
stores the file descriptor returned by open(2) to struct media_entity.fd.
v4l2_subdev_close() is not called explicitly. This is currently not
required.

The file handle is not leaked, as it is closed by media_device_unref() in
libmediactl.

This patch allocates memory for each sub-device in v4l2_subdev_create()
which is in turn called from v4l2_subdev_open(). As the calls to
v4l2_subdev_close() (which would release memory) are lacking, the memory is
leaked.

> 
> Probably it would be good to remove v4l2_subdev_open from
> v4l2_subdev_* prefixed API and return error if sd property
> of passed struct media_entity is not initialized.

The purpose of the libv4l2subdev library is to make accessing sub-devices
easier, and tossing that responsibility to the user is certainly not
advancing that goal.

I've been working on extending libmediatext library into an interactive test
program for V4L2, V4L2 sub-device and Media controller. What I've noticed
that libv4l2subdev does not currently bend really well for that purpose;
the data structure holding the media graph is sort of self-contained and
cannot be extended nor it can be used to refer to something else. That's a
bit aside from the topic of this patch, but I presume that you'd need to
associate information to media entities as well. For this reason I presume
that releasing the resources related to a media entity acquired for e.g.
IOCTL is not the right way to proceed.

Instead, I think the libraries (libmediactl and libv4l2subdev) need to
manage the resources (as has been done with file handles up to now).

How about adding a callback to release resources related to an entity, e.g.
as this:

	void (*release)(struct media_entity *entity);

It would be called by media_device_unref(). v4l2_subdev_close() prototype
already matches with that, so it could be used directly.

> 
> >I wonder if it'd do harm to open all the associated devices in
> >media_device_open() and close them in media_device_close().
> 
> Opening all sub-devices within a media device would be waste
> of resources since we only need the sub-devices that belong
> to the pipeline connected to the opened video device. It would
> also incur unnecessary additional power consumption as you
> mentioned below.
> 
> >The sub-device objects could exist for the entire lifespan of the media
> >device object (in user space), and they could be used to store whatever
> >information is needed.
> >
> >One would no longer need to call v4l2_subdev_open() directly either.
> >
> >I'd like to have Laurent's opinion on this, too.
> >
> >The power management currently is based on open file handles and this is
> >a bit of a problem, but we have to have a better solution on this (based
> >on latencies and perhaps PM QoS framework).
> >
> >>+	if (ret < 0)
> >>+		return ret;
> >>+
> >>+	if (entity->sd->fd != -1)
> >>  		return 0;
> >>
> >>-	entity->fd = open(entity->devname, O_RDWR);
> >>-	if (entity->fd == -1) {
> >>+	entity->sd->fd = open(entity->devname, O_RDWR);
> >>+	if (entity->sd->fd == -1) {
> >>  		int ret = -errno;
> >>  		media_dbg(entity->media,
> >>  			  "%s: Failed to open subdev device node %s\n", __func__,
> >>@@ -58,8 +106,8 @@ int v4l2_subdev_open(struct media_entity *entity)
> >>
> >>  void v4l2_subdev_close(struct media_entity *entity)
> >>  {
> >>-	close(entity->fd);
> >>-	entity->fd = -1;
> >>+	close(entity->sd->fd);
> >>+	entity->sd->fd = -1;
> >>  }
> >>
> >>  int v4l2_subdev_get_format(struct media_entity *entity,
> >>@@ -77,7 +125,7 @@ int v4l2_subdev_get_format(struct media_entity *entity,
> >>  	fmt.pad = pad;
> >>  	fmt.which = which;
> >>
> >>-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FMT, &fmt);
> >>+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_FMT, &fmt);
> >>  	if (ret < 0)
> >>  		return -errno;
> >>
> >>@@ -101,7 +149,7 @@ int v4l2_subdev_set_format(struct media_entity *entity,
> >>  	fmt.which = which;
> >>  	fmt.format = *format;
> >>
> >>-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FMT, &fmt);
> >>+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_FMT, &fmt);
> >>  	if (ret < 0)
> >>  		return -errno;
> >>
> >>@@ -128,7 +176,7 @@ int v4l2_subdev_get_selection(struct media_entity *entity,
> >>  	u.sel.target = target;
> >>  	u.sel.which = which;
> >>
> >>-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_SELECTION, &u.sel);
> >>+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_SELECTION, &u.sel);
> >>  	if (ret >= 0) {
> >>  		*rect = u.sel.r;
> >>  		return 0;
> >>@@ -140,7 +188,7 @@ int v4l2_subdev_get_selection(struct media_entity *entity,
> >>  	u.crop.pad = pad;
> >>  	u.crop.which = which;
> >>
> >>-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_CROP, &u.crop);
> >>+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_CROP, &u.crop);
> >>  	if (ret < 0)
> >>  		return -errno;
> >>
> >>@@ -168,7 +216,7 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
> >>  	u.sel.which = which;
> >>  	u.sel.r = *rect;
> >>
> >>-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_SELECTION, &u.sel);
> >>+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_SELECTION, &u.sel);
> >>  	if (ret >= 0) {
> >>  		*rect = u.sel.r;
> >>  		return 0;
> >>@@ -181,7 +229,7 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
> >>  	u.crop.which = which;
> >>  	u.crop.rect = *rect;
> >>
> >>-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_CROP, &u.crop);
> >>+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_CROP, &u.crop);
> >>  	if (ret < 0)
> >>  		return -errno;
> >>
> >>@@ -202,7 +250,7 @@ int v4l2_subdev_get_dv_timings_caps(struct media_entity *entity,
> >>  	memset(caps, 0, sizeof(*caps));
> >>  	caps->pad = pad;
> >>
> >>-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_DV_TIMINGS_CAP, caps);
> >>+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_DV_TIMINGS_CAP, caps);
> >>  	if (ret < 0)
> >>  		return -errno;
> >>
> >>@@ -220,7 +268,7 @@ int v4l2_subdev_query_dv_timings(struct media_entity *entity,
> >>
> >>  	memset(timings, 0, sizeof(*timings));
> >>
> >>-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_QUERY_DV_TIMINGS, timings);
> >>+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_QUERY_DV_TIMINGS, timings);
> >>  	if (ret < 0)
> >>  		return -errno;
> >>
> >>@@ -238,7 +286,7 @@ int v4l2_subdev_get_dv_timings(struct media_entity *entity,
> >>
> >>  	memset(timings, 0, sizeof(*timings));
> >>
> >>-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_DV_TIMINGS, timings);
> >>+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_DV_TIMINGS, timings);
> >>  	if (ret < 0)
> >>  		return -errno;
> >>
> >>@@ -254,7 +302,7 @@ int v4l2_subdev_set_dv_timings(struct media_entity *entity,
> >>  	if (ret < 0)
> >>  		return ret;
> >>
> >>-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_DV_TIMINGS, timings);
> >>+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_DV_TIMINGS, timings);
> >>  	if (ret < 0)
> >>  		return -errno;
> >>
> >>@@ -273,7 +321,7 @@ int v4l2_subdev_get_frame_interval(struct media_entity *entity,
> >>
> >>  	memset(&ival, 0, sizeof(ival));
> >>
> >>-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FRAME_INTERVAL, &ival);
> >>+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_FRAME_INTERVAL, &ival);
> >>  	if (ret < 0)
> >>  		return -errno;
> >>
> >>@@ -294,7 +342,7 @@ int v4l2_subdev_set_frame_interval(struct media_entity *entity,
> >>  	memset(&ival, 0, sizeof(ival));
> >>  	ival.interval = *interval;
> >>
> >>-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FRAME_INTERVAL, &ival);
> >>+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_FRAME_INTERVAL, &ival);
> >>  	if (ret < 0)
> >>  		return -errno;
> >>
> >>diff --git a/utils/media-ctl/mediactl-priv.h b/utils/media-ctl/mediactl-priv.h
> >>index a0d3a55..f531c52 100644
> >>--- a/utils/media-ctl/mediactl-priv.h
> >>+++ b/utils/media-ctl/mediactl-priv.h
> >>@@ -26,6 +26,8 @@
> >>
> >>  #include "mediactl.h"
> >>
> >>+struct v4l2_subdev;
> >>+
> >>  struct media_entity {
> >>  	struct media_device *media;
> >>  	struct media_entity_desc info;
> >>@@ -34,8 +36,9 @@ struct media_entity {
> >>  	unsigned int max_links;
> >>  	unsigned int num_links;
> >>
> >>+	struct v4l2_subdev *sd;
> >>+
> >>  	char devname[32];
> >>-	int fd;
> >>  };
> >>
> >>  struct media_device {
> >>diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
> >>index 104e420..ba9b8c4 100644
> >>--- a/utils/media-ctl/v4l2subdev.h
> >>+++ b/utils/media-ctl/v4l2subdev.h
> >>@@ -27,6 +27,44 @@
> >>  struct media_device;
> >>  struct media_entity;
> >>
> >>+struct v4l2_subdev {
> >>+	int fd;
> >>+};
> >>+
> >>+/**
> >>+ * @brief Create a v4l2-subdev
> >>+ * @param entity - sub-device media entity.
> >>+ *
> >>+ * Create the representation of the entity sub-device.
> >>+ *
> >>+ * @return 0 on success, or a negative error code on failure.
> >>+ */
> >>+int v4l2_subdev_create(struct media_entity *entity);
> >>+
> >>+/**
> >>+ * @brief Create a representation of the already opened v4l2-subdev
> >>+ * @param entity - sub-device media entity.
> >>+ * @param fd - sub-device file descriptor.
> >>+ *
> >>+ * Create the representation of the sub-device that had been opened
> >>+ * before the parent media device was created, and associate it
> >>+ * with the media entity.
> >>+ *
> >>+ * @return 0 on success, or a negative error code on failure.
> >>+ */
> >>+int v4l2_subdev_create_with_fd(struct media_entity *entity, int fd);
> >>+
> >>+/**
> >>+ * @brief Release a v4l2-subdev
> >>+ * @param entity - sub-device media entity.
> >>+ * @param close_fd - indicates whether subdev fd should be closed.
> >>+ *
> >>+ * Release the representation of the entity sub-device.
> >>+ *
> >>+ * @return 0 on success, or a negative error code on failure.
> >>+ */
> >>+void v4l2_subdev_release(struct media_entity *entity, bool close_fd);
> >>+
> >
> >Is there a need to call these outside the library itself? Should they be
> >static instead?
> >
> >>  /**
> >>   * @brief Open a sub-device.
> >>   * @param entity - sub-device media entity.
> >>
> >
> 
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
