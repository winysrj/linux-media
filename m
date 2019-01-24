Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5E0C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 20:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CEA6217D7
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 20:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="nxCN1XQq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbfAXUQI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 15:16:08 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:39396 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbfAXUQF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 15:16:05 -0500
Received: from pendragon.ideasonboard.com (unknown [37.185.172.133])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 3E5632F6;
        Thu, 24 Jan 2019 21:16:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1548360961;
        bh=mcT8RJ+SwsoNMEgn96fXKAG4yH4m82/98ae3Uj9VKhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nxCN1XQq6FddpgO1Ok/gxGlx6zi7qUvCihLXadFOTKj4Z4AiFPVYV0QxPRRHvPvGV
         DUlU3isfg2z1l+P6aH2kbm75k7+X3Z5Xi4Etg8cu8CabQd9sNJsUR6/FJt8CeY/vAS
         vX/LtX/h7rPMoxT44BJ/3j1Z3Iu0pBi/llvTcvnY=
Date:   Thu, 24 Jan 2019 22:16:00 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v4l-utils] Introduce v4l2-get-device tool
Message-ID: <20190124172623.GA4444@pendragon.ideasonboard.com>
References: <20181109215238.2384-1-ezequiel@collabora.com>
 <63a1fe74-80ef-7e8a-54a2-52452a4096fe@xs4all.nl>
 <33191bbab51f254ebbfe55a8d7be4f23b060d469.camel@collabora.com>
 <9ed0a03a-6330-d738-d849-3ab2529e4441@xs4all.nl>
 <ed8a4091c959cec3d5606be7e2cb60e394aefd91.camel@collabora.com>
 <67b1ffba-4ba5-b182-d432-24437c628a15@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <67b1ffba-4ba5-b182-d432-24437c628a15@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

On Thu, Jan 24, 2019 at 10:24:48AM +0100, Hans Verkuil wrote:
> Resurrecting this thread, since this functionality would be really useful :-)
> 
> On 11/10/18 12:17 PM, Ezequiel Garcia wrote:
> > On Sat, 2018-11-10 at 12:09 +0100, Hans Verkuil wrote:
> >> On 11/10/2018 12:01 PM, Ezequiel Garcia wrote:
> >>> On Sat, 2018-11-10 at 11:29 +0100, Hans Verkuil wrote:
> >>>> On 11/09/2018 10:52 PM, Ezequiel Garcia wrote:
> >>>>> This tool allows to find a device by driver name,
> >>>>> this is useful for scripts to be written in a generic way.
> >>>>
> >>>> Why not add support for this to v4l2-sysfs-path? And improve it at the same
> >>>> time (swradio devices do not show up when I run v4l2-sysfs-path, I also suspect
> >>>> v4l-touch devices aren't recognized. Ditto for media devices.
> >>>>
> >>>
> >>> I can add the functionality to v4l2-sysfs-path, and we can document
> >>> the rest in some TODO list, as I don't think we need to get everything
> >>> solved right now :-)
> >>
> >> I agree with that.
> > 
> > Great!
> > 
> > About adding it to v4l2-sysfs-path, is there any scenario where we'll want
> > to use udev-based scanning instead of sysfs-based? Maybe we can rename
> > the tool, and still install a v4l2-sysfs-path alias?
> 
> To be honest, I don't know. It appears that sysfs is the most generic approach
> and I have seen cases where udev isn't installed on an embedded system.
> 
> So I feel that sysfs is the best approach for now.

The problem with sysfs is that it won't give you the device node path.
You can use it to get the device node name known to the kernel, but if
the device node gets renamed by a udev policy, you won't know. That's
why it's better to use udev if available, and fall back on sysfs
otherwise.

Please see below for an additional comment.

> BTW, I've added support for swradio and v4l-touch devices to v4l2-sysfs-path, but I
> noticed that it didn't recognize media devices, I need to dig into it a bit to
> understand how to find those devices.
> 
> >>>>> Usage:
> >>>>>
> >>>>> v4l2-get-device -d uvcvideo -c V4L2_CAP_VIDEO_CAPTURE
> >>>>> /dev/video0
> >>>>> /dev/video2
> >>>>>
> >>>>> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> >>>>> ---
> >>>>>  configure.ac                            |   1 +
> >>>>>  utils/Makefile.am                       |   1 +
> >>>>>  utils/v4l2-get-device/.gitignore        |   1 +
> >>>>>  utils/v4l2-get-device/Makefile.am       |   4 +
> >>>>>  utils/v4l2-get-device/v4l2-get-device.c | 147 ++++++++++++++++++++++++
> >>>>>  v4l-utils.spec.in                       |   1 +
> >>>>>  6 files changed, 155 insertions(+)
> >>>>>  create mode 100644 utils/v4l2-get-device/.gitignore
> >>>>>  create mode 100644 utils/v4l2-get-device/Makefile.am
> >>>>>  create mode 100644 utils/v4l2-get-device/v4l2-get-device.c
> >>>>>
> >>>>> diff --git a/configure.ac b/configure.ac
> >>>>> index 5cc34c248fbf..918cb59704b9 100644
> >>>>> --- a/configure.ac
> >>>>> +++ b/configure.ac
> >>>>> @@ -31,6 +31,7 @@ AC_CONFIG_FILES([Makefile
> >>>>>  	utils/v4l2-compliance/Makefile
> >>>>>  	utils/v4l2-ctl/Makefile
> >>>>>  	utils/v4l2-dbg/Makefile
> >>>>> +	utils/v4l2-get-device/Makefile
> >>>>>  	utils/v4l2-sysfs-path/Makefile
> >>>>>  	utils/qv4l2/Makefile
> >>>>>  	utils/cec-ctl/Makefile
> >>>>> diff --git a/utils/Makefile.am b/utils/Makefile.am
> >>>>> index 2d5070288c13..2b2b27107d13 100644
> >>>>> --- a/utils/Makefile.am
> >>>>> +++ b/utils/Makefile.am
> >>>>> @@ -9,6 +9,7 @@ SUBDIRS = \
> >>>>>  	v4l2-compliance \
> >>>>>  	v4l2-ctl \
> >>>>>  	v4l2-dbg \
> >>>>> +	v4l2-get-device \
> >>>>>  	v4l2-sysfs-path \
> >>>>>  	cec-ctl \
> >>>>>  	cec-compliance \
> >>>>> diff --git a/utils/v4l2-get-device/.gitignore b/utils/v4l2-get-device/.gitignore
> >>>>> new file mode 100644
> >>>>> index 000000000000..b222144c9f4e
> >>>>> --- /dev/null
> >>>>> +++ b/utils/v4l2-get-device/.gitignore
> >>>>> @@ -0,0 +1 @@
> >>>>> +v4l2-get-device
> >>>>> diff --git a/utils/v4l2-get-device/Makefile.am b/utils/v4l2-get-device/Makefile.am
> >>>>> new file mode 100644
> >>>>> index 000000000000..2e5a6e0ba32f
> >>>>> --- /dev/null
> >>>>> +++ b/utils/v4l2-get-device/Makefile.am
> >>>>> @@ -0,0 +1,4 @@
> >>>>> +bin_PROGRAMS = v4l2-get-device
> >>>>> +v4l2_get_device_SOURCES = v4l2-get-device.c
> >>>>> +v4l2_get_device_LDADD = ../libmedia_dev/libmedia_dev.la
> >>>>> +v4l2_get_device_LDFLAGS = $(ARGP_LIBS)
> >>>>> diff --git a/utils/v4l2-get-device/v4l2-get-device.c b/utils/v4l2-get-device/v4l2-get-device.c
> >>>>> new file mode 100644
> >>>>> index 000000000000..f9cc323b7057
> >>>>> --- /dev/null
> >>>>> +++ b/utils/v4l2-get-device/v4l2-get-device.c
> >>>>> @@ -0,0 +1,147 @@
> >>>>> +/*
> >>>>> + * Copyright © 2018 Collabora, Ltd.
> >>>>> + *
> >>>>> + * Based on v4l2-sysfs-path by Mauro Carvalho Chehab:
> >>>>> + *
> >>>>> + * Copyright © 2011 Red Hat, Inc.
> >>>>> + *
> >>>>> + * Permission to use, copy, modify, distribute, and sell this software
> >>>>> + * and its documentation for any purpose is hereby granted without
> >>>>> + * fee, provided that the above copyright notice appear in all copies
> >>>>> + * and that both that copyright notice and this permission notice
> >>>>> + * appear in supporting documentation, and that the name of Red Hat
> >>>>> + * not be used in advertising or publicity pertaining to distribution
> >>>>> + * of the software without specific, written prior permission.  Red
> >>>>> + * Hat makes no representations about the suitability of this software
> >>>>> + * for any purpose.  It is provided "as is" without express or implied
> >>>>> + * warranty.
> >>>>> + *
> >>>>> + * THE AUTHORS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
> >>>>> + * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN
> >>>>> + * NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
> >>>>> + * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
> >>>>> + * OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
> >>>>> + * NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
> >>>>> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> >>>>> + *
> >>>>> + */
> >>>>> +
> >>>>> +#include <argp.h>
> >>>>> +#include <config.h>
> >>>>> +#include <fcntl.h>
> >>>>> +#include <stdio.h>
> >>>>> +#include <stdlib.h>
> >>>>> +#include <string.h>
> >>>>> +#include <sys/types.h>
> >>>>> +#include <sys/stat.h>
> >>>>> +#include <sys/ioctl.h>
> >>>>> +#include <sys/unistd.h>
> >>>>> +
> >>>>> +#include <linux/videodev2.h>
> >>>>> +
> >>>>> +#include "../libmedia_dev/get_media_devices.h"
> >>>>> +
> >>>>> +const char *argp_program_version = "v4l2-get-device " V4L_UTILS_VERSION;
> >>>>> +const char *argp_program_bug_address = "Ezequiel Garcia <ezequiel@collabora.com>";
> >>>>> +
> >>>>> +struct args {
> >>>>> +	const char *driver;
> >>>>> +	unsigned int device_caps;
> >>>>> +};
> >>>>> +
> >>>>> +static const struct argp_option options[] = {
> >>>>> +	{"driver", 'd', "DRIVER", 0, "device driver name", 0},
> >>>>> +	{"v4l2-device-caps", 'c', "CAPS", 0, "v4l2 device capabilities", 0},
> >>>>
> >>>> I'd like a bus-info option as well, if possible.
> >>>>
> >>>
> >>> Guess that works.
> >>>
> >>>>> +	{ 0 }
> >>>>> +};
> >>>>> +
> >>>>> +static unsigned int parse_capabilities(const char *arg)
> >>>>> +{
> >>>>> +	char *s, *str = strdup(arg);
> >>>>> +	unsigned int caps = 0;
> >>>>> +
> >>>>> +	s = strtok (str,",");
> >>>>> +	while (s != NULL) {
> >>>>> +		if (!strcmp(s, "V4L2_CAP_VIDEO_CAPTURE"))
> >>>>> +			caps |= V4L2_CAP_VIDEO_CAPTURE;
> >>>>> +		else if (!strcmp(s, "V4L2_CAP_VIDEO_OUTPUT"))
> >>>>> +			caps |= V4L2_CAP_VIDEO_OUTPUT;
> >>>>> +		else if (!strcmp(s, "V4L2_CAP_VIDEO_OVERLAY"))
> >>>>> +			caps |= V4L2_CAP_VIDEO_OVERLAY;
> >>>>> +		else if (!strcmp(s, "V4L2_CAP_VBI_CAPTURE"))
> >>>>> +			caps |= V4L2_CAP_VBI_CAPTURE;
> >>>>> +		else if (!strcmp(s, "V4L2_CAP_VBI_OUTPUT"))
> >>>>> +			caps |= V4L2_CAP_VBI_OUTPUT;
> >>>>
> >>>> Let's support all CAPS here. I'd also drop the V4L2_CAP_ prefix (or make it optional)
> >>>> and make the strcmp case-insensitive to ease typing.
> >>>>
> >>>
> >>> OK.
> >>>
> >>>>> +		s = strtok (NULL, ",");
> >>>>> +	}
> >>>>> +	free(str);
> >>>>> +	return caps;
> >>>>> +}
> >>>>> +
> >>>>> +static error_t parse_opt(int k, char *arg, struct argp_state *state)
> >>>>> +{
> >>>>> +	struct args *args = state->input;
> >>>>> +
> >>>>> +	switch (k) {
> >>>>> +	case 'd':
> >>>>> +		args->driver = arg;
> >>>>> +		break;
> >>>>> +	case 'c':
> >>>>> +		args->device_caps = parse_capabilities(arg);
> >>>>> +		break;
> >>>>> +	default:
> >>>>> +		return ARGP_ERR_UNKNOWN;
> >>>>> +	}
> >>>>> +	return 0;
> >>>>> +}
> >>>>> +
> >>>>> +static struct argp argp = {
> >>>>> +	.options = options,
> >>>>> +	.parser = parse_opt,
> >>>>> +};
> >>>>> +
> >>>>> +int main(int argc, char *argv[])
> >>>>> +{
> >>>>> +	const char *vid;
> >>>>> +	struct args args;
> >>>>> +	void *md;
> >>>>> +
> >>>>> +	args.driver = NULL;
> >>>>> +	args.device_caps = 0;
> >>>>> +	argp_parse(&argp, argc, argv, 0, 0, &args);
> >>>>> +
> >>>>> +	md = discover_media_devices();
> >>>>
> >>>> I never really liked this. My main problem is that it doesn't know about media devices.
> >>>
> >>> Sorry, not sure what you don't really like?
> >>>
> >>> The discover_media_devices() is maybe not the best API, but it's what v4l2-sysfs-path
> >>> uses, and it seemed to fit what we need as a first step (to find v4l2 devices).
> >>>
> >>> Perhaps we can use this for now and pospone improving the discovery library?
> >>
> >> Yes, that can be postponed (I should have been clear about that, sorry).
> >>
> >>>> In my view it should look for media devices first, query them and get all the device
> >>>> nodes referenced in the topology, and then fall back to the old method to discover
> >>>> any remaining device nodes for drivers that do not create a media device.

I agree with Hans here. It's about time to make new development media
device-centric, and only fall back to legacy methods for legacy drivers.

> >>>> You need media device support anyway since you also want to be able to query the media
> >>>> device for a specific driver and find the device node for a specific entity.
> >>>
> >>> I've been thinking about this (since I started with http://git.ideasonboard.org/media-enum.git),
> >>> but to be honest, I failed to see why I would want to query media devices.
> >>>
> >>> Let's say we want to find a H264 decoder, I don't think the topology is be
> >>> of much use, is it?
> >>
> >> Not for codecs, but this should become a generic utility that you can also use to find
> >> e.g. v4l-subdev device nodes from a complex camera driver.
> > 
> > Ah, that makes sense.
> > 
> > Thanks for the quick review!
> > 
> >>> In any case, I think this is part of a bigger discussion, would you consider merging
> >>> v4l discovery for now?
> >>>  
> >>>>> +
> >>>>> +	vid = NULL;
> >>>>> +	do {
> >>>>> +		struct v4l2_capability cap;
> >>>>> +		char devnode[64];
> >>>>> +		int ret;
> >>>>> +		int fd;
> >>>>> +
> >>>>> +		vid = get_associated_device(md, vid, MEDIA_V4L_VIDEO,
> >>>>> +					    NULL, NONE);
> >>>>> +		if (!vid)
> >>>>> +			break;
> >>>>> +		snprintf(devnode, 64, "/dev/%s", vid);
> >>>>> +		fd = open(devnode, O_RDWR);
> >>>>> +		if (fd < 0)
> >>>>> +			continue;
> >>>>> +
> >>>>> +		memset(&cap, 0, sizeof cap);
> >>>>> +		ret = ioctl(fd, VIDIOC_QUERYCAP, &cap);
> >>>>> +		if (ret) {
> >>>>> +			close(fd);
> >>>>> +			continue;
> >>>>> +		}
> >>>>> +		close(fd);
> >>>>> +
> >>>>> +		if (strncmp(args.driver, (char *)cap.driver, sizeof(cap.driver)))
> >>>>> +			continue;
> >>>>> +		if (args.device_caps && (args.device_caps & cap.device_caps) != args.device_caps)
> >>>>> +			continue;
> >>>>> +		fprintf(stdout, "%s\n", devnode);
> >>>>> +	} while (vid);
> >>>>> +	free_media_devices(md);
> >>>>> +	return 0;
> >>>>> +}
> >>>>> diff --git a/v4l-utils.spec.in b/v4l-utils.spec.in
> >>>>> index 67bdca57ae92..ab15286b039b 100644
> >>>>> --- a/v4l-utils.spec.in
> >>>>> +++ b/v4l-utils.spec.in
> >>>>> @@ -159,6 +159,7 @@ gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
> >>>>>  %{_bindir}/ivtv-ctl
> >>>>>  %{_bindir}/v4l2-ctl
> >>>>>  %{_bindir}/v4l2-sysfs-path
> >>>>> +%{_bindir}/v4l2-get-device
> >>>>>  %{_mandir}/man1/ir-keytable.1*
> >>>>>  %{_mandir}/man1/ir-ctl.1*

-- 
Regards,

Laurent Pinchart
