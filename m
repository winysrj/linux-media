Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4F7C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 16:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2CE7222DA
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 16:33:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="v6BnDbF9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405459AbfBNQdJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 11:33:09 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:46014 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405161AbfBNQdJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 11:33:09 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 860142DF;
        Thu, 14 Feb 2019 17:33:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550161986;
        bh=7gIgNoNwbunRWzieYoHsaY+/8TUK/5HMVORjtYXkTfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v6BnDbF9EsvhbUhHbG/p5NvC+e3ZU2CXIyRkSM5o8okGmryj21xf2loubMqlRkia2
         BqQlPdF4AsSh1DFl1OyjhG05qdXNsdrlszljeuCmUilGQH0Zn38i5Qr2qMf+R8k0AI
         n3g4xaQWOs0ofHYL9B+M/OwQ8XqprO/ZWd16wL+s=
Date:   Thu, 14 Feb 2019 18:33:02 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH] media-ctl: add --bus-info
Message-ID: <20190214163302.GL3682@pendragon.ideasonboard.com>
References: <cee8c085-785f-f793-715d-c4c4d09a5f36@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cee8c085-785f-f793-715d-c4c4d09a5f36@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Thu, Feb 14, 2019 at 04:43:17PM +0100, Hans Verkuil wrote:
> Add a --bus-info option to media-ctl which opens the media device
> that has this bus info string. That makes it possible to open a specific
> media device without having to know the name of the media device.
> 
> Similar functionality has been implemented for v4l2-ctl and v4l2-compliance,
> and for the cec utilities.
> 
> This allows scripts that no longer need to care about the name of a device
> node, instead they can find it based on a unique string.
> 
> Also extend the -d option to support -d0 as a shorthand for /dev/media0 to
> make it consistent with the other utils.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
> index 16367857..0430b8bc 100644
> --- a/utils/media-ctl/options.c
> +++ b/utils/media-ctl/options.c
> @@ -19,13 +19,18 @@
>   * along with this program. If not, see <http://www.gnu.org/licenses/>.
>   */
> 
> +#include <ctype.h>
> +#include <dirent.h>
> +#include <fcntl.h>
>  #include <getopt.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <sys/ioctl.h>
>  #include <unistd.h>
>  #include <v4l2subdev.h>
> 
> +#include <linux/media.h>
>  #include <linux/videodev2.h>
> 
>  #include "options.h"
> @@ -42,7 +47,9 @@ static void usage(const char *argv0)
>  	unsigned int i;
> 
>  	printf("%s [options]\n", argv0);
> +	printf("-b, --bus-info name	Use the media device with bus info equal to name\n");

When seeing --bus-info I initially thought it was meant to print bus
information. I wonder if we could find a name a bit more straightforward
to guess. Would it be an option to reuse the -d option, first trying to
open the specified device node, and considering it as a bus-info string
if the file doesn't exist ?

>  	printf("-d, --device dev	Media device name (default: %s)\n", MEDIA_DEVNAME_DEFAULT);
> +	printf("			If <dev> starts with a digit, then /dev/media<dev> is used.\n");
>  	printf("-e, --entity name	Print the device name associated with the given entity\n");
>  	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
>  	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
> @@ -121,6 +128,7 @@ static void usage(const char *argv0)
>  #define OPT_GET_DV			260
> 
>  static struct option opts[] = {
> +	{"bus-info", 1, 0, 'b'},
>  	{"device", 1, 0, 'd'},
>  	{"entity", 1, 0, 'e'},
>  	{"set-format", 1, 0, 'f'},
> @@ -161,6 +169,51 @@ static void list_known_mbus_formats(void)
>  	}
>  }
> 
> +static const char *find_bus_info(const char *bus_info)
> +{
> +	static char newdev[300];
> +	struct dirent *ep;
> +	DIR *dp;
> +
> +	dp = opendir("/dev");
> +	if (dp == NULL)
> +		return NULL;
> +
> +	while ((ep = readdir(dp))) {
> +		const char *name = ep->d_name;
> +
> +		if (!memcmp(name, "media", 5) && isdigit(name[5])) {
> +			struct media_device_info mdi;
> +			int ret;
> +			int fd;
> +
> +			snprintf(newdev, sizeof(newdev), "/dev/%s", name);
> +			fd = open(newdev, O_RDWR);

You can use openat() instead of open() to avoid the snprintf.

> +			if (fd < 0)
> +				continue;
> +			ret = ioctl(fd, MEDIA_IOC_DEVICE_INFO, &mdi);
> +			close(fd);
> +			if (!ret && !strcmp(bus_info, mdi.bus_info)) {
> +				closedir(dp);
> +				return newdev;
> +			}
> +		}
> +	}
> +	closedir(dp);
> +	return NULL;

Should we try to enumerate media devices using libudev, to support
systems with custom udev rules ?

> +}
> +
> +static const char *make_devname(const char *device)
> +{
> +	static char newdev[300];

Seems a bit long for concatenating /dev/media and a 3 characters string.

> +
> +	if (device[0] >= '0' && device[0] <= '9' && strlen(device) <= 3) {

	if (isdigit(device[0]) && strlen(device) <= 3)

Shouldn't you however check that the whole string parses as a number ?

> +		snprintf(newdev, sizeof(newdev), "/dev/media%s", device);
> +		return newdev;
> +	}
> +	return device;
> +}
> +
>  int parse_cmdline(int argc, char **argv)
>  {
>  	int opt;
> @@ -171,11 +224,20 @@ int parse_cmdline(int argc, char **argv)
>  	}
> 
>  	/* parse options */
> -	while ((opt = getopt_long(argc, argv, "d:e:f:hil:prvV:",
> +	while ((opt = getopt_long(argc, argv, "b:d:e:f:hil:prvV:",
>  				  opts, NULL)) != -1) {
>  		switch (opt) {
> +		case 'b':
> +			media_opts.devname = find_bus_info(optarg);
> +			if (!media_opts.devname) {
> +				fprintf(stderr, "Error: no media device with bus info '%s' found\n",
> +					optarg);
> +				return 1;
> +			}
> +			break;
> +
>  		case 'd':
> -			media_opts.devname = optarg;
> +			media_opts.devname = make_devname(optarg);
>  			break;
> 
>  		case 'e':

-- 
Regards,

Laurent Pinchart
