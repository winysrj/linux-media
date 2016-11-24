Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39128 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750696AbcKXXz4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 18:55:56 -0500
Date: Fri, 25 Nov 2016 01:55:50 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, gjasny@googlemail.com
Subject: Re: [PATCH v4l-utils v7 7/7] Add a libv4l plugin for Exynos4 camera
Message-ID: <20161124235550.GX16630@valkosipuli.retiisi.org.uk>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-8-git-send-email-j.anaszewski@samsung.com>
 <CGME20161124151154epcas2p3f2cf276dae37e27752a91251ebb3d8af@epcas2p3.samsung.com>
 <20161124151110.GT16630@valkosipuli.retiisi.org.uk>
 <6992e01c-9240-0e3b-d25f-1eeafac5fa73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6992e01c-9240-0e3b-d25f-1eeafac5fa73@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Thu, Nov 24, 2016 at 05:14:40PM +0100, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 11/24/2016 04:11 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >Thank you for your continued work on the Exynos plugin patchset!
> >
> >I think we're pretty close to being able to merge the set, if you could
> >still bear with me awhile. :-)
> 
> Your demanding reviewer I must admit. :-)
> Of course, I appreciate all your remarks, they're highly valuable.
> 
> >On Wed, Oct 12, 2016 at 04:35:22PM +0200, Jacek Anaszewski wrote:
> >...
> >>diff --git a/lib/libv4l-exynos4-camera/Makefile.am b/lib/libv4l-exynos4-camera/Makefile.am
> >>new file mode 100644
> >>index 0000000..c38b7f6
> >>--- /dev/null
> >>+++ b/lib/libv4l-exynos4-camera/Makefile.am
> >>@@ -0,0 +1,19 @@
> >>+if WITH_V4L_PLUGINS
> >>+libv4l2plugin_LTLIBRARIES = libv4l-exynos4-camera.la
> >>+endif
> >>+
> >>+media-bus-format-names.h: ../../include/linux/media-bus-format.h
> >>+	sed -e '/#define MEDIA_BUS_FMT/ ! d; s/.*FMT_//; /FIXED/ d; s/\t.*//; s/.*/{ \"&\", MEDIA_BUS_FMT_& },/;' \
> >>+	< $< > $@
> >>+
> >>+media-bus-format-codes.h: ../../include/linux/media-bus-format.h
> >>+	sed -e '/#define MEDIA_BUS_FMT/ ! d; s/.*#define //; /FIXED/ d; s/\t.*//; s/.*/ &,/;' \
> >>+	< $< > $@
> >>+
> >>+BUILT_SOURCES = media-bus-format-names.h media-bus-format-codes.h
> >>+CLEANFILES = $(BUILT_SOURCES)
> >
> >It'd be nice to be able to use the same generated headers that now are under
> >utils/media-ctl, instead of copying the sed script here in verbatim. If the
> >script is changed or fixed in some way, the other location probably will
> >remain unchanged...
> 
> The problem is that those headers are built after this plugin.

They could be moved to another directory from where they are now, and
explicitly built as a dependency. I don't know how to properly do that with
automake though.

I cc'd Gregor to the thread.

> 
> >I wonder if there's a proper way to generate build time headers such as
> >these.
> >
> >Another less good alternative would be to put these into a separate Makefile
> >and include that Makefile where the headers are needed. But I don't like
> >that much either, it's a hack.
> 
> In this case it seems to be the only feasible optimization.

I'm ok with that but still hope we could have something better. :-)

> 
> >>+
> >>+nodist_libv4l_exynos4_camera_la_SOURCES = $(BUILT_SOURCES)
> >>+libv4l_exynos4_camera_la_SOURCES = libv4l-exynos4-camera.c ../../utils/media-ctl/libmediactl.c ../../utils/media-ctl/libv4l2subdev.c ../../utils/media-ctl/mediatext.c
> >>+libv4l_exynos4_camera_la_CFLAGS = -fvisibility=hidden -std=gnu99
> >>+libv4l_exynos4_camera_la_LDFLAGS = -avoid-version -module -shared -export-dynamic -lpthread
> >>diff --git a/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c b/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
> >>new file mode 100644
> >>index 0000000..c219fe5
> >>--- /dev/null
> >>+++ b/lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
> >>@@ -0,0 +1,1325 @@
> >>+/*
> >>+ * Copyright (c) 2016 Samsung Electronics Co., Ltd.
> >>+ *              http://www.samsung.com
> >>+ *
> >>+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>+ *
> >>+ * This program is free software; you can redistribute it and/or modify
> >>+ * it under the terms of the GNU Lesser General Public License as published by
> >>+ * the Free Software Foundation; either version 2.1 of the License, or
> >>+ * (at your option) any later version.
> >>+ *
> >>+ * This program is distributed in the hope that it will be useful,
> >>+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> >>+ * Lesser General Public License for more details.
> >>+ */
> >>+
> >>+#include <config.h>
> >>+#include <errno.h>
> >>+#include <linux/types.h>
> >>+#include <stdbool.h>
> >>+#include <stdint.h>
> >>+#include <stdio.h>
> >>+#include <stdlib.h>
> >>+#include <string.h>
> >>+#include <sys/ioctl.h>
> >>+#include <sys/syscall.h>
> >>+#include <unistd.h>
> >>+
> >>+#include "../../utils/media-ctl/mediactl.h"
> >>+#include "../../utils/media-ctl/mediatext.h"
> >>+#include "../../utils/media-ctl/v4l2subdev.h"
> >>+#include "libv4l-plugin.h"
> >>+
> >>+#ifdef DEBUG
> >>+#define V4L2_EXYNOS4_DBG(format, ARG...)\
> >>+	printf("[%s:%d] [%s] " format " \n", __FILE__, __LINE__, __func__, ##ARG)
> >>+#else
> >>+#define V4L2_EXYNOS4_DBG(format, ARG...)
> >>+#endif
> >>+
> >>+#define V4L2_EXYNOS4_ERR(format, ARG...)\
> >>+	fprintf(stderr, "Libv4l Exynos4 camera plugin: "format "\n", ##ARG)
> >>+
> >>+#define V4L2_EXYNOS4_LOG(format, ARG...)\
> >>+	fprintf(stdout, "Libv4l Exynos4 camera plugin: "format "\n", ##ARG)
> >>+
> >>+#define VIDIOC_CTRL(type)				\
> >>+	((type) == VIDIOC_S_CTRL ? "VIDIOC_S_CTRL" :	\
> >>+				   "VIDIOC_G_CTRL")
> >>+
> >>+#if HAVE_VISIBILITY
> >>+#define PLUGIN_PUBLIC __attribute__ ((visibility("default")))
> >>+#else
> >>+#define PLUGIN_PUBLIC
> >>+#endif
> >>+
> >>+#define SYS_IOCTL(fd, cmd, arg) \
> >>+	syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd), (void *)(arg))
> >>+
> >>+#define SIMPLE_CONVERT_IOCTL(fd, cmd, arg, __struc) ({  \
> >>+	int __ret;                                      \
> >>+	struct __struc *req = arg;                      \
> >>+	uint32_t type = req->type;                      \
> >>+	req->type = convert_type(type);                 \
> >>+	__ret = SYS_IOCTL(fd, cmd, arg);                \
> >>+	req->type = type;                               \
> >>+	__ret;                                          \
> >>+	})
> >>+
> >>+#ifndef min
> >>+#define min(a, b) (((a) < (b)) ? (a) : (b))
> >>+#endif
> >>+
> >>+#ifndef max
> >>+#define max(a, b) (((a) > (b)) ? (a) : (b))
> >>+#endif
> >>+
> >>+#define EXYNOS4_FIMC_DRV	"exynos4-fimc"
> >>+#define EXYNOS4_FIMC_LITE_DRV	"exynos-fimc-lit"
> >>+#define EXYNOS4_FIMC_IS_ISP_DRV	"exynos4-fimc-is"
> >>+#define EXYNOS4_CAPTURE_CONF	"/var/lib/libv4l/exynos4_capture_conf"
> >
> >Is this something that should be configurable in ./configure?
> 
> OK.
> 
> >
> >>+#define EXYNOS4_FIMC_IS_ISP	"FIMC-IS-ISP"
> >>+#define EXYNOS4_S5K6A3		"S5K6A3"
> >
> >Maybe this one as well. But it could come from a configuration file, too.
> 
> Right, the sensor is independent of SoC.
> 
> >
> >The problem at large is actually something else: how do you recognise the
> >hardware you're running on?
> >
> >You could find the sensor by walking the media graph.
> >
> >But if you need to know something very hardware specific it might not be
> >available through the generic interfaces, and you might need to know the
> >exact hardware you have.
> >
> >How do you know that you should load a particular plugin? I wonder if we
> >could add a small snippet of code to detect different kinds of systems, I
> >presume this is the plugin you want to load if the user has opened a video
> >node of the Exynos4 ISP; you could find through the Media controller.
> 
> This code snippet in plugin_init() detects if we are on Exynos4 media
> device:
> 
>         ret = SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap);
>         if (ret < 0) {
>                 V4L2_EXYNOS4_ERR("Failed to query video capabilities.");
>                 return NULL;
>         }
> 
>         /* Check if this is Exynos4 media device */
>         if (strcmp((char *) cap.driver, EXYNOS4_FIMC_DRV) &&
>             strcmp((char *) cap.driver, EXYNOS4_FIMC_LITE_DRV) &&
>             strcmp((char *) cap.driver, EXYNOS4_FIMC_IS_ISP_DRV)) {
>                 V4L2_EXYNOS4_ERR("Not an Exynos4 media device.");
>                 return NULL;
>         }
> 
> Additionally I check if this is capture and not m2m device:
> 
>         /* Check if video entity is of capture type, not m2m */
>         if (!is_capture_entity(sink_entity_name)) {
>                 V4L2_EXYNOS4_ERR("Device not of capture type.");
>                 goto err_get_sink_entity;
>         }

Ah, indeed. I presume it should work just fine then. Good.

The approach doesn't look too scalable still, but I don't think there's
a reason to worry about that now.

> 
> 
> 
> >
> >That's certainly out of scope of the patchset, I just thought of binging up
> >the topics for discussion. :-)
> >
> >>+#define EXYNOS4_FIMC_LITE_PREFIX "FIMC-LITE."
> >>+#define EXYNOS4_FIMC_PREFIX	"FIMC."
> >>+#define EXYNOS4_MAX_FMT_NEGO_NUM 50
> >>+#define EXYNOS4_MAX_PIPELINE_LEN 7
> >>+
> >>+struct media_device;
> >>+struct media_entity;
> >>+
> >>+/*
> >>+ * struct pipeline_entity - linked media device pipeline
> >>+ * @entity:		linked entity
> >>+ * @sink_pad:		inbound link pad of the entity
> >>+ * @src_pad:		outbound link pad of the entity
> >>+ */
> >>+struct pipeline_entity {
> >>+	struct media_entity *entity;
> >>+	struct media_pad *sink_pad;
> >>+	struct media_pad *src_pad;
> >>+};
> >>+
> >>+/*
> >>+ * struct media_entity_to_cid - entity to control map
> >>+ * @entity:		media entity
> >>+ * @sink_pad:		inbound link pad of the entity
> >>+ * @src_pad:		outbound link pad of the entity
> >>+ */
> >>+struct media_entity_to_cid {
> >>+	struct media_entity *entity;
> >>+	union {
> >>+		struct v4l2_queryctrl queryctrl;
> >>+		struct v4l2_query_ext_ctrl query_ext_ctrl;
> >>+	};
> >>+};
> >>+
> >>+/*
> >>+ * struct exynos4_camera_plugin - libv4l exynos4 camera plugin
> >>+ * @media:		media device comprising the opened video device
> >>+ * @pipeline:		video pipeline, element 0 is the source entity
> >>+ * @pipeline_len:	length of the video pipeline
> >>+ */
> >>+struct exynos4_camera_plugin {
> >
> >static?
> 
> Right.
> 
> >>+	struct media_device *media;
> >>+	struct pipeline_entity pipeline[EXYNOS4_MAX_PIPELINE_LEN];
> >>+	unsigned int pipeline_len;
> >>+};
> >>+
> >>+/* -----------------------------------------------------------------------------
> >>+ * Pipeline operations
> >>+ */
> >>+
> >>+/**
> >>+ * @brief Discover video pipeline for given sink entity
> >>+ * @param plugin - this plugin.
> >>+ * @param entity - sink entity of the pipeline.
> >>+ *
> >>+ * Discover the video pipeline, by walking starting from the
> >>+ * sink entity upwards until a source entity is encountered.
> >>+ *
> >>+ * @return 0 if the sensor entity was detected,
> >>+ * 	   or negative error code on failure.
> >>+ */
> >>+static int discover_pipeline_by_entity(struct exynos4_camera_plugin *plugin,
> >>+				       struct media_entity *entity)
> >>+{
> >>+	struct pipeline_entity reverse_pipeline[EXYNOS4_MAX_PIPELINE_LEN];
> >>+	struct media_pad *src_pad;
> >>+	struct media_link *link = NULL, *backlinks[2];
> >>+	unsigned int num_backlinks, cur_pipe_pos = 0;
> >>+	int i, j;
> >>+	int ret;
> >>+
> >>+	if (entity == NULL)
> >>+		return -EINVAL;
> >>+
> >>+	for (;;) {
> >>+		/* Cache the recently discovered entity. */
> >>+		reverse_pipeline[cur_pipe_pos].entity = entity;
> >>+
> >>+		/* Cache the source pad used for linking the entity. */
> >>+		if (link)
> >>+			reverse_pipeline[cur_pipe_pos].src_pad = link->source;
> >>+
> >>+		ret = media_entity_get_backlinks(entity, backlinks,
> >>+						 &num_backlinks);
> >>+		if (ret < 0)
> >>+			return ret;
> >>+
> >>+		/* Check if pipeline source entity has been reached. */
> >>+		if (num_backlinks > 2) {
> >>+			V4L2_EXYNOS4_DBG("Unexpected number of busy sink pads (%d)",
> >>+					 num_backlinks);
> >>+			return -EINVAL;
> >>+		} else if (num_backlinks == 2) {
> >>+			/*
> >>+			 * Allow two active pads only in case of
> >>+			 * S5C73M3-OIF entity.
> >>+			 */
> >>+			if (strcmp(media_entity_get_info(entity)->name,
> >>+				   "S5C73M3-OIF")) {
> >>+				V4L2_EXYNOS4_DBG("Ambiguous media device topology: "
> >>+						 "two busy sink pads");
> >>+				return -EINVAL;
> >>+			}
> >>+			/*
> >>+			 * Two active links are allowed betwen S5C73M3-OIF and
> >>+			 * S5C73M3 entities. In such a case route through the
> >>+			 * pad with id == 0 has to be chosen.
> >>+			 */
> >>+			link = NULL;
> >>+			for (i = 0; i < num_backlinks; i++)
> >>+				if (backlinks[i]->sink->index == 0)
> >>+					link = backlinks[i];
> >>+			if (link == NULL)
> >>+				return -EINVAL;
> >>+		} else if (num_backlinks == 1) {
> >>+			link = backlinks[0];
> >>+		} else {
> >>+			reverse_pipeline[cur_pipe_pos].sink_pad = NULL;
> >>+			break;
> >>+		}
> >>+
> >>+		/* Cache the sink pad used for linking the entity. */
> >>+		reverse_pipeline[cur_pipe_pos].sink_pad = link->sink;
> >>+
> >>+		V4L2_EXYNOS4_DBG("Discovered sink pad %d for the %s entity",
> >>+				 reverse_pipeline[cur_pipe_pos].sink_pad->index,
> >>+				 media_entity_get_info(entity)->name);
> >>+
> >>+		src_pad = media_entity_remote_source(link->sink);
> >>+		if (!src_pad)
> >>+			return -EINVAL;
> >>+
> >>+		entity = src_pad->entity;
> >>+		if (++cur_pipe_pos == EXYNOS4_MAX_PIPELINE_LEN)
> >>+			return -EINVAL;
> >>+	}
> >>+
> >>+	/*
> >>+	 * Reorder discovered pipeline elements so that the sensor
> >>+	 * entity was the pipeline head.
> >>+	 */
> >>+	j = 0;
> >>+	for (i = cur_pipe_pos; i >= 0; i--)
> >
> >How about:
> >
> >	for (i = cur_pipe_pos, j = 0; i >= 0; i--, j++)
> >
> >And you can avoid setting j to zero outside the loop plus incrementing j++
> >where it doesn't seem to fit too well.
> 
> I was thinking about it, but finally decided that this arrangement
> will improve readability. Nothing prevents us to apply the
> optimizations you've just suggested though.

You could do that using a single loop variable, replacing j by cur_pipe_pos
- i. Up to you. :-)

> 
> >>+		plugin->pipeline[j++] = reverse_pipeline[i];
> >>+
> >>+	plugin->pipeline_len = j;
> >>+
> >>+	return 0;
> >>+}
> >>+

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
