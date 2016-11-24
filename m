Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36488 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965327AbcKXOEd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 09:04:33 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OH500C7UGFIEE20@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2016 14:04:30 +0000 (GMT)
Subject: Re: [PATCH v4l-utils v7 2/7] mediatext: Add library
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, Teemu Tuominen <teemu.tuominen@intel.com>
From: Jacek Anaszewski <j.anaszewski@samsung.com>
Message-id: <45a0adaa-6f84-d1e0-7034-2889c2867d45@samsung.com>
Date: Thu, 24 Nov 2016 15:04:27 +0100
MIME-version: 1.0
In-reply-to: <20161124130131.GO16630@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-3-git-send-email-j.anaszewski@samsung.com>
 <CGME20161124130216epcas2p23ce619ca2ad613acfa6ad8dea7798c45@epcas2p2.samsung.com>
 <20161124130131.GO16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 11/24/2016 02:01 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Wed, Oct 12, 2016 at 04:35:17PM +0200, Jacek Anaszewski wrote:
>> libmediatext is a helper library for converting configurations (Media
>> controller links, V4L2 controls and V4L2 sub-device media bus formats and
>> selections) from text-based form into IOCTLs.
>>
>> libmediatext depends on libv4l2subdev and libmediactl.
>
> I'm not very happy with the plugin using the mediatext library as it was in
> 2013. I've heavily changed (and extended) the library since to cover
> additional use cases such as the request API:
>
> <URL:http://www.spinics.net/lists/linux-media/msg103242.html>
>
> This version is not meaningfully extensible in forward-compatible way. In
> order to resolve the matter quickly without making merging the further
> developed library difficult, I propose merging the code to the plugin
> itself. We could later check if it could be refactored.
>
> How about that?

It works for me.

Thanks,
Jacek Anaszewski

>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Signed-off-by: Teemu Tuominen <teemu.tuominen@intel.com>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> ---
>>  utils/media-ctl/Makefile.am        |  10 +-
>>  utils/media-ctl/libmediatext.pc.in |  10 ++
>>  utils/media-ctl/mediatext-test.c   |  64 ++++++++
>>  utils/media-ctl/mediatext.c        | 312 +++++++++++++++++++++++++++++++++++++
>>  utils/media-ctl/mediatext.h        |  52 +++++++
>>  5 files changed, 446 insertions(+), 2 deletions(-)
>>  create mode 100644 utils/media-ctl/libmediatext.pc.in
>>  create mode 100644 utils/media-ctl/mediatext-test.c
>>  create mode 100644 utils/media-ctl/mediatext.c
>>  create mode 100644 utils/media-ctl/mediatext.h
>>
>> diff --git a/utils/media-ctl/Makefile.am b/utils/media-ctl/Makefile.am
>> index ee7dcc9..2f12357 100644
>> --- a/utils/media-ctl/Makefile.am
>> +++ b/utils/media-ctl/Makefile.am
>> @@ -1,4 +1,4 @@
>> -noinst_LTLIBRARIES = libmediactl.la libv4l2subdev.la
>> +noinst_LTLIBRARIES = libmediactl.la libv4l2subdev.la libmediatext.la
>>
>>  libmediactl_la_SOURCES = libmediactl.c mediactl-priv.h
>>  libmediactl_la_CFLAGS = -static $(LIBUDEV_CFLAGS)
>> @@ -21,9 +21,15 @@ libv4l2subdev_la_LIBADD = libmediactl.la
>>  libv4l2subdev_la_CFLAGS = -static
>>  libv4l2subdev_la_LDFLAGS = -static
>>
>> +libmediatext_la_SOURCES = mediatext.c
>> +libmediatext_la_CFLAGS = -static $(LIBUDEV_CFLAGS)
>> +libmediatext_la_LDFLAGS = -static $(LIBUDEV_LIBS)
>> +
>>  mediactl_includedir=$(includedir)/mediactl
>>  noinst_HEADERS = mediactl.h v4l2subdev.h
>>
>> -bin_PROGRAMS = media-ctl
>> +bin_PROGRAMS = media-ctl mediatext-test
>>  media_ctl_SOURCES = media-ctl.c options.c options.h tools.h
>>  media_ctl_LDADD = libmediactl.la libv4l2subdev.la
>> +mediatext_test_SOURCES = mediatext-test.c
>> +mediatext_test_LDADD = libmediatext.la libmediactl.la libv4l2subdev.la
>> diff --git a/utils/media-ctl/libmediatext.pc.in b/utils/media-ctl/libmediatext.pc.in
>> new file mode 100644
>> index 0000000..6aa6353
>> --- /dev/null
>> +++ b/utils/media-ctl/libmediatext.pc.in
>> @@ -0,0 +1,10 @@
>> +prefix=@prefix@
>> +exec_prefix=@exec_prefix@
>> +libdir=@libdir@
>> +includedir=@includedir@
>> +
>> +Name: libmediatext
>> +Description: Media controller and V4L2 text-based configuration library
>> +Version: @PACKAGE_VERSION@
>> +Cflags: -I${includedir}
>> +Libs: -L${libdir} -lmediatext
>> diff --git a/utils/media-ctl/mediatext-test.c b/utils/media-ctl/mediatext-test.c
>> new file mode 100644
>> index 0000000..b8b9282
>> --- /dev/null
>> +++ b/utils/media-ctl/mediatext-test.c
>> @@ -0,0 +1,64 @@
>> +/*
>> + * libmediatext test program
>> + *
>> + * Copyright (C) 2013 Intel Corporation
>> + *
>> + * Contact: Sakari Ailus <sakari.ailus@linux.intel.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU Lesser General Public License as published
>> + * by the Free Software Foundation; either version 2.1 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU Lesser General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU Lesser General Public License
>> + * along with this program. If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +
>> +#include "mediactl.h"
>> +#include "mediatext.h"
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	struct media_device *device;
>> +	int rval;
>> +
>> +	if (argc != 3) {
>> +		fprintf(stderr, "usage: %s <media device> <string>\n\n", argv[0]);
>> +		fprintf(stderr, "\tstring := [ v4l2-ctrl |?v4l2-mbus | link-reset | link-conf]\n\n");
>> +		fprintf(stderr, "\tv4l2-ctrl := \"entity\" ctrl_type ctrl_id ctrl_value\n");
>> +		fprintf(stderr, "\tctrl_type := [ int | int64 | bitmask ]\n");
>> +		fprintf(stderr, "\tctrl_value := [ %%d | %%PRId64 | bitmask_value ]\n");
>> +		fprintf(stderr, "\tbitmask_value := b<binary_number>\n\n");
>> +		fprintf(stderr, "\tv4l2-mbus := \n");
>> +		fprintf(stderr, "\tlink-conf := \"entity\":pad -> \"entity\":pad[link-flags]\n");
>> +		fprintf(stderr, "\tv4l2-ctrl-binding := ctrl_id -> \"entity\"\n");
>> +		return EXIT_FAILURE;
>> +	}
>> +
>> +	device = media_device_new(argv[1]);
>> +	if (!device)
>> +		return EXIT_FAILURE;
>> +
>> +	rval = media_device_enumerate(device);
>> +	if (rval)
>> +		return EXIT_FAILURE;
>> +
>> +	rval = mediatext_parse(device, argv[2]);
>> +	if (rval) {
>> +		fprintf(stderr, "bad string %s (%s)\n", argv[2], strerror(-rval));
>> +		return EXIT_FAILURE;
>> +	}
>> +
>> +	media_device_unref(device);
>> +
>> +	return EXIT_SUCCESS;
>> +}
>> diff --git a/utils/media-ctl/mediatext.c b/utils/media-ctl/mediatext.c
>> new file mode 100644
>> index 0000000..9faf0db
>> --- /dev/null
>> +++ b/utils/media-ctl/mediatext.c
>> @@ -0,0 +1,312 @@
>> +/*
>> + * Media controller text-based configuration library
>> + *
>> + * Copyright (C) 2013 Intel Corporation
>> + *
>> + * Contact: Sakari Ailus <sakari.ailus@linux.intel.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU Lesser General Public License as published
>> + * by the Free Software Foundation; either version 2.1 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU Lesser General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU Lesser General Public License
>> + * along with this program. If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <sys/ioctl.h>
>> +
>> +#include <ctype.h>
>> +#include <errno.h>
>> +#include <fcntl.h>
>> +#include <inttypes.h>
>> +#include <stdbool.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <unistd.h>
>> +#include <sys/stat.h>
>> +
>> +#include <linux/types.h>
>> +
>> +#include "mediactl.h"
>> +#include "mediactl-priv.h"
>> +#include "tools.h"
>> +#include "v4l2subdev.h"
>> +
>> +struct parser {
>> +	char *prefix;
>> +	int (*parse)(struct media_device *media, const struct parser *p,
>> +		     char *string);
>> +	struct parser *next;
>> +	bool no_args;
>> +};
>> +
>> +static int parse(struct media_device *media, const struct parser *p, char *string)
>> +{
>> +	for (; p->prefix; p++) {
>> +		size_t len = strlen(p->prefix);
>> +
>> +		if (strncmp(p->prefix, string, len) || string[len] != ' ')
>> +			continue;
>> +
>> +		string += len;
>> +
>> +		for (; isspace(*string); string++);
>> +
>> +		if (p->no_args)
>> +			return p->parse(media, p->next, NULL);
>> +
>> +		if (strlen(string) == 0)
>> +			return -ENOEXEC;
>> +
>> +		return p->parse(media, p->next, string);
>> +	}
>> +
>> +	media_dbg(media, "Unknown parser prefix\n");
>> +
>> +	return -ENOENT;
>> +}
>> +
>> +struct ctrl_type {
>> +	uint32_t type;
>> +	char *str;
>> +} ctrltypes[] = {
>> +	{ V4L2_CTRL_TYPE_INTEGER, "int" },
>> +	{ V4L2_CTRL_TYPE_MENU, "menu" },
>> +	{ V4L2_CTRL_TYPE_INTEGER_MENU, "intmenu" },
>> +	{ V4L2_CTRL_TYPE_BITMASK, "bitmask" },
>> +	{ V4L2_CTRL_TYPE_INTEGER64, "int64" },
>> +};
>> +
>> +static int parse_v4l2_ctrl_id(struct media_device *media, const struct parser *p,
>> +			      char *string, char **endp, __u32 *ctrl_id)
>> +{
>> +	int rval;
>> +
>> +	for (; isspace(*string); string++);
>> +	rval = sscanf(string, "0x%" PRIx32, ctrl_id);
>> +	if (rval <= 0)
>> +		return -EINVAL;
>> +
>> +	for (; !isspace(*string) && *string; string++);
>> +	for (; isspace(*string); string++);
>> +
>> +	*endp = string;
>> +
>> +	return 0;
>> +}
>> +
>> +/* adapted from yavta.c */
>> +static int parse_v4l2_ctrl(struct media_device *media, const struct parser *p,
>> +			   char *string)
>> +{
>> +	struct v4l2_ext_control ctrl = { 0 };
>> +	struct v4l2_ext_controls ctrls = { .count = 1,
>> +					   .controls = &ctrl };
>> +	int64_t val;
>> +	int rval;
>> +	struct media_entity *entity;
>> +	struct ctrl_type *ctype;
>> +	unsigned int i;
>> +
>> +	entity = media_parse_entity(media, string, &string);
>> +	if (!entity)
>> +		return -ENOENT;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(ctrltypes); i++)
>> +		if (!strncmp(string, ctrltypes[i].str,
>> +			     strlen(ctrltypes[i].str)))
>> +			break;
>> +
>> +	if (i == ARRAY_SIZE(ctrltypes))
>> +		return -ENOENT;
>> +
>> +	ctype = &ctrltypes[i];
>> +
>> +	string += strlen(ctrltypes[i].str);
>> +
>> +	rval = parse_v4l2_ctrl_id(media, p, string, &string, &ctrl.id);
>> +	if (rval < 0)
>> +		return -EINVAL;
>> +
>> +	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
>> +
>> +	switch (ctype->type) {
>> +	case V4L2_CTRL_TYPE_BITMASK:
>> +		if (*string++ != 'b')
>> +			return -EINVAL;
>> +		while (*string == '1' || *string == '0') {
>> +			val <<= 1;
>> +			if (*string == '1')
>> +				val++;
>> +			string++;
>> +		}
>> +		break;
>> +	default:
>> +		rval = sscanf(string, "%" PRId64, &val);
>> +		break;
>> +	}
>> +	if (rval <= 0)
>> +		return -EINVAL;
>> +
>> +	media_dbg(media, "Setting control 0x%8.8x (type %s), value %" PRId64 "\n",
>> +		  ctrl.id, ctype->str, val);
>> +
>> +	if (ctype->type == V4L2_CTRL_TYPE_INTEGER64)
>> +		ctrl.value64 = val;
>> +	else
>> +		ctrl.value = val;
>> +
>> +	rval = v4l2_subdev_open(entity);
>> +	if (rval < 0)
>> +		return rval;
>> +
>> +	rval = ioctl(entity->sd->fd, VIDIOC_S_EXT_CTRLS, &ctrls);
>> +	if (ctype->type != V4L2_CTRL_TYPE_INTEGER64) {
>> +		if (rval != -1) {
>> +			ctrl.value64 = ctrl.value;
>> +		} else if (ctype->type != V4L2_CTRL_TYPE_STRING &&
>> +			   (errno == EINVAL || errno == ENOTTY)) {
>> +			struct v4l2_control old = { .id = ctrl.id,
>> +						    .value = val };
>> +
>> +			rval = ioctl(entity->sd->fd, VIDIOC_S_CTRL, &old);
>> +			if (rval != -1)
>> +				ctrl.value64 = old.value;
>> +		}
>> +	}
>> +	if (rval == -1) {
>> +		media_dbg(media,
>> +			  "Failed setting control 0x%8.8x: %s (%d) to value %"
>> +			  PRId64 "\n", ctrl.id, strerror(errno), errno, val);
>> +		return -errno;
>> +	}
>> +
>> +	if (val != ctrl.value64)
>> +		media_dbg(media, "Asking for %" PRId64 ", got %" PRId64 "\n",
>> +			  val, ctrl.value64);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> +
>> +parse_name(string, end)
>> +
>> +*/
>> +
>> +int parse_v4l2_ctrl_binding(struct media_device *media, const struct parser *p,
>> +			    char *string)
>> +{
>> +	struct media_entity *entity;
>> +	struct v4l2_subdev *sd;
>> +	__u32 ctrl_id;
>> +	int rval;
>> +
>> +	rval = parse_v4l2_ctrl_id(media, p, string, &string, &ctrl_id);
>> +	if (rval < 0)
>> +		return -EINVAL;
>> +
>> +	for (; isspace(*string); ++string);
>> +
>> +	if (string[0] != '-' || string[1] != '>') {
>> +		media_dbg(media, "Expected '->'\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	string += 2;
>> +
>> +	entity = media_parse_entity(media, string, &string);
>> +	if (!entity)
>> +		return -ENOENT;
>> +
>> +	rval = v4l2_subdev_supports_v4l2_ctrl(media, entity, ctrl_id);
>> +	if (rval < 0) {
>> +		media_dbg(media,
>> +			  "Failed to check v4l2 control support for entity %s\n",
>> +			  entity->info.name);
>> +		return rval;
>> +	}
>> +
>> +	sd = entity->sd;
>> +
>> +	sd->v4l2_ctrl_bindings = realloc(sd->v4l2_ctrl_bindings,
>> +					 sizeof(*sd->v4l2_ctrl_bindings) *
>> +					 (sd->num_v4l2_ctrl_bindings + 1));
>> +	if (!sd->v4l2_ctrl_bindings)
>> +		return -ENOMEM;
>> +
>> +	sd->v4l2_ctrl_bindings[sd->num_v4l2_ctrl_bindings] = ctrl_id;
>> +	++sd->num_v4l2_ctrl_bindings;
>> +
>> +	return 0;
>> +}
>> +
>> +static int parse_v4l2_mbus(struct media_device *media, const struct parser *p,
>> +			   char *string)
>> +{
>> +	media_dbg(media, "Media bus format setup: %s\n", string);
>> +	return v4l2_subdev_parse_setup_formats(media, string);
>> +}
>> +
>> +static int parse_link_reset(struct media_device *media, const struct parser *p,
>> +			    char *string)
>> +{
>> +	media_dbg(media, "Resetting links\n");
>> +	return media_reset_links(media);
>> +}
>> +
>> +static int parse_link_conf(struct media_device *media, const struct parser *p,
>> +			   char *string)
>> +{
>> +	media_dbg(media, "Configuring links: %s\n", string);
>> +	return media_parse_setup_links(media, string);
>> +}
>> +
>> +static const struct parser parsers[] = {
>> +	{ "v4l2-ctrl", parse_v4l2_ctrl },
>> +	{ "v4l2-ctrl-binding", parse_v4l2_ctrl_binding },
>> +	{ "v4l2-mbus", parse_v4l2_mbus },
>> +	{ "link-reset", parse_link_reset, NULL, true },
>> +	{ "link-conf", parse_link_conf },
>> +	{ 0 }
>> +};
>> +
>> +int mediatext_parse(struct media_device *media, char *string)
>> +{
>> +	return parse(media, parsers, string);
>> +}
>> +
>> +int mediatext_parse_setup_config(struct media_device *device, const char *conf_path)
>> +{
>> +	char *line;
>> +	size_t n = 0;
>> +	FILE *f;
>> +	int ret;
>> +
>> +	if (conf_path == NULL)
>> +		return -EINVAL;
>> +
>> +	f = fopen(conf_path, "r");
>> +	if (!f)
>> +		return -EINVAL;
>> +
>> +	while (getline(&line, &n, f) != -1) {
>> +		ret = mediatext_parse(device, line);
>> +		if (ret < 0)
>> +			goto err_parse;
>> +		free(line);
>> +		line = NULL;
>> +		n = 0;
>> +	}
>> +
>> +err_parse:
>> +	fclose(f);
>> +	return ret;
>> +}
>> diff --git a/utils/media-ctl/mediatext.h b/utils/media-ctl/mediatext.h
>> new file mode 100644
>> index 0000000..7dfbaf6
>> --- /dev/null
>> +++ b/utils/media-ctl/mediatext.h
>> @@ -0,0 +1,52 @@
>> +/*
>> + * Media controller text-based configuration library
>> + *
>> + * Copyright (C) 2013 Intel Corporation
>> + *
>> + * Contact: Sakari Ailus <sakari.ailus@linux.intel.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU Lesser General Public License as published
>> + * by the Free Software Foundation; either version 2.1 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU Lesser General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU Lesser General Public License
>> + * along with this program. If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#ifndef __MEDIATEXT_H__
>> +#define __MEDIATEXT_H__
>> +
>> +struct media_device;
>> +
>> +/**
>> + * @brief Parse and apply media device command
>> + * @param device - media device
>> + * @param string - string to parse
>> + *
>> + * Parse media device command and apply it to the media device
>> + * passed in the device argument.
>> + *
>> + * @return 0 on success, or a negative error code on failure.
>> + */
>> +int mediatext_parse(struct media_device *device, char *string);
>> +
>> +/**
>> + * @brief Parse and apply media device configuration
>> + * @param media - media device
>> + * @param conf_path - path to the configuration file
>> + *
>> + * Parse the media device commands listed in the file under
>> + * conf_path and apply them to the media device passed in the
>> + * device argument.
>> + *
>> + * @return 0 on success, or a negative error code on failure.
>> + */
>> +int mediatext_parse_setup_config(struct media_device *device, const char *conf_path);
>> +
>> +#endif /* __MEDIATEXT_H__ */
>

