Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36060 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751088AbaKZK2X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 05:28:23 -0500
Date: Wed, 26 Nov 2014 12:20:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hans.verkuil@cisco.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v4 01/11] mediactl: Introduce v4l2_subdev structure
Message-ID: <20141126102039.GL8907@valkosipuli.retiisi.org.uk>
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
 <1416586480-19982-2-git-send-email-j.anaszewski@samsung.com>
 <20141125113655.GK8907@valkosipuli.retiisi.org.uk>
 <5474749A.7090804@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5474749A.7090804@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Tue, Nov 25, 2014 at 01:22:50PM +0100, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 11/25/2014 12:36 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >Thank you for the updated patchset.
> >
> >On Fri, Nov 21, 2014 at 05:14:30PM +0100, Jacek Anaszewski wrote:
> >>Add struct v4l2_subdev as a representation of the v4l2 sub-device
> >>related to a media entity. Add sd property, the pointer to
> >>the newly introduced structure, to the struct media_entity
> >>and move fd property to it.
> >>
> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>---
> >>  utils/media-ctl/libmediactl.c   |   30 +++++++++++++++++++++++++-----
> >>  utils/media-ctl/libv4l2subdev.c |   34 +++++++++++++++++-----------------
> >>  utils/media-ctl/mediactl-priv.h |    5 +++++
> >>  utils/media-ctl/mediactl.h      |   22 ++++++++++++++++++++++
> >>  4 files changed, 69 insertions(+), 22 deletions(-)
> >>
> >>diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
> >>index ec360bd..53921f5 100644
> >>--- a/utils/media-ctl/libmediactl.c
> >>+++ b/utils/media-ctl/libmediactl.c
> >>@@ -511,7 +511,6 @@ static int media_enum_entities(struct media_device *media)
> >>
> >>  		entity = &media->entities[media->entities_count];
> >>  		memset(entity, 0, sizeof(*entity));
> >>-		entity->fd = -1;
> >
> >I think I'd definitely leave the fd to the media_entity itself. Not all the
> >entities are sub-devices, even right now.
> 
> I am aware of it, I even came across this issue while implementing the
> function v4l2_subdev_apply_pipeline_fmt. I added suitable comment
> explaining why the entity not being a sub-device has its representation.
> 
> I moved the fd out of media_entity by following Laurent's message [1],
> where he mentioned this, however I think that it would be indeed
> best if it remained intact.

I read Laurent's reply again, and I can see why he suggested that. I
wouldn't mind, but then we should avoid touching it from libmediactl, and
only access it from libv4l2subdev.

> >>  		entity->info.id = id | MEDIA_ENT_ID_FLAG_NEXT;
> >>  		entity->media = media;
> >>
> >>@@ -529,11 +528,13 @@ static int media_enum_entities(struct media_device *media)
> >>
> >>  		entity->pads = malloc(entity->info.pads * sizeof(*entity->pads));
> >>  		entity->links = malloc(entity->max_links * sizeof(*entity->links));
> >>-		if (entity->pads == NULL || entity->links == NULL) {
> >>+		entity->sd = calloc(1, sizeof(*entity->sd));
> >>+		if (entity->pads == NULL || entity->links == NULL || entity->sd == NULL) {
> >>  			ret = -ENOMEM;
> >>  			break;
> >>  		}
> >>
> >>+		entity->sd->fd = -1;
> >>  		media->entities_count++;
> >>
> >>  		if (entity->info.flags & MEDIA_ENT_FL_DEFAULT) {
> >>@@ -704,8 +705,9 @@ void media_device_unref(struct media_device *media)
> >>
> >>  		free(entity->pads);
> >>  		free(entity->links);
> >>-		if (entity->fd != -1)
> >>-			close(entity->fd);
> >>+		if (entity->sd->fd != -1)
> >>+			close(entity->sd->fd);
> >>+		free(entity->sd);
> >>  	}
> >>
> >>  	free(media->entities);
> >>@@ -726,13 +728,17 @@ int media_device_add_entity(struct media_device *media,
> >>  	if (entity == NULL)
> >>  		return -ENOMEM;
> >>
> >>+	entity->sd = calloc(1, sizeof(*entity->sd));
> >>+	if (entity->sd == NULL)
> >>+		return -ENOMEM;
> >>+
> >>  	media->entities = entity;
> >>  	media->entities_count++;
> >>
> >>  	entity = &media->entities[media->entities_count - 1];
> >>  	memset(entity, 0, sizeof *entity);
> >>
> >>-	entity->fd = -1;
> >>+	entity->sd->fd = -1;
> >>  	entity->media = media;
> >>  	strncpy(entity->devname, devnode, sizeof entity->devname);
> >>  	entity->devname[sizeof entity->devname - 1] = '\0';
> >>@@ -955,3 +961,17 @@ int media_parse_setup_links(struct media_device *media, const char *p)
> >>
> >>  	return *end ? -EINVAL : 0;
> >>  }
> >>+
> >>+/* -----------------------------------------------------------------------------
> >>+ * Media entity access
> >>+ */
> >>+
> >>+int media_entity_get_fd(struct media_entity *entity)
> >>+{
> >>+	return entity->sd->fd;
> >>+}
> >>+
> >>+void media_entity_set_fd(struct media_entity *entity, int fd)
> >>+{
> >>+	entity->sd->fd = fd;
> >>+}
> >
> >You access the fd directly now inside the library. I don't think there
> >should be a need to set it.
> 
> struct media_entity is defined in mediactl-priv.h, whose name implies
> that it shouldn't be made public. Thats way I implemented the setter.
> I use it in the libv4l-exynos4-camera.c.

Ah, I now understand why you wnat to do this. You should also close the file
handle --- this is used internally by the library, and simply setting the
value will lead the loss of the existing handle.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
