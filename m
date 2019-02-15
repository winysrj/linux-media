Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D429AC43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 09:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BEC421B68
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 09:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="YVW6ulTG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392493AbfBOJWI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 04:22:08 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:42432 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392484AbfBOJWH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 04:22:07 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 744A82D6;
        Fri, 15 Feb 2019 10:22:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550222525;
        bh=XabWNsDt+cGw8vwKLiM1aKZs+0OLKw9AueX3RiBCPgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YVW6ulTGleuz3r4PME+r7lg6x14cooEW7XQOKgLZwGqkYg057WZtRFWUbCwPNAEw7
         pvSNoZRRaGqk8Z8jNahVbopRi9OV1ccL4pVB+fchXe+Rf09jLiZFMXm21hFgogzdub
         8lBszZxJcweqpyQx9MWOFw/EoVA9v9WAphraJZLA=
Date:   Fri, 15 Feb 2019 11:22:01 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCHv2] media-ctl: support a bus-info string as argument to -d
Message-ID: <20190215092201.GA3504@pendragon.ideasonboard.com>
References: <454f5a3f-e3a9-51b7-6932-5b2bacfa92ff@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <454f5a3f-e3a9-51b7-6932-5b2bacfa92ff@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Fri, Feb 15, 2019 at 09:10:24AM +0100, Hans Verkuil wrote:
> If the device passed to the -d option is not found, then interpret it
> as a bus-info string and try to open all media devices and see which one
> reports a bus-info string equal to the -d argument.
> 
> That makes it possible to open a specific media device without having to know
> the name of the media device.
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
> Changes since v1:
> - fold into the -d option instead of creating a separate option
> ---
> diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
> index 16367857..fb923775 100644
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
> @@ -43,6 +48,9 @@ static void usage(const char *argv0)
> 
>  	printf("%s [options]\n", argv0);
>  	printf("-d, --device dev	Media device name (default: %s)\n", MEDIA_DEVNAME_DEFAULT);
> +	printf("			If <dev> starts with a digit, then /dev/media<dev> is used.\n");
> +	printf("			If <dev> doesn't exist, then find a media device that\n");
> +	printf("			reports a bus info string equal to <dev>.\n");
>  	printf("-e, --entity name	Print the device name associated with the given entity\n");
>  	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
>  	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
> @@ -161,6 +169,48 @@ static void list_known_mbus_formats(void)
>  	}
>  }
> 
> +static const char *make_devname(const char *device)
> +{
> +	static char newdev[300];

300 is still a lot for such a short string.

> +	struct dirent *ep;
> +	DIR *dp;
> +
> +	if (!access(device, F_OK))
> +		return device;
> +
> +	if (device[0] >= '0' && device[0] <= '9' && strlen(device) <= 3) {
> +		snprintf(newdev, sizeof(newdev), "/dev/media%s", device);
> +		return newdev;
> +	}
> +
> +	dp = opendir("/dev");
> +	if (dp == NULL)
> +		return device;
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

Did openat() fail ?

> +			if (fd < 0)
> +				continue;
> +			ret = ioctl(fd, MEDIA_IOC_DEVICE_INFO, &mdi);
> +			close(fd);
> +			if (!ret && !strcmp(device, mdi.bus_info)) {
> +				closedir(dp);
> +				return newdev;
> +			}
> +		}
> +	}
> +	closedir(dp);
> +	return device;
> +}
> +
>  int parse_cmdline(int argc, char **argv)
>  {
>  	int opt;
> @@ -175,7 +225,7 @@ int parse_cmdline(int argc, char **argv)
>  				  opts, NULL)) != -1) {
>  		switch (opt) {
>  		case 'd':
> -			media_opts.devname = optarg;
> +			media_opts.devname = make_devname(optarg);
>  			break;
> 
>  		case 'e':

-- 
Regards,

Laurent Pinchart
