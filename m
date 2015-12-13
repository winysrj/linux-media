Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39115 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbLNBgm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2015 20:36:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] libmediactl.c: add poor man's udev support
Date: Sun, 13 Dec 2015 21:29:32 +0200
Message-ID: <2326047.llhSbUSKD9@avalon>
In-Reply-To: <5669579B.8050706@xs4all.nl>
References: <5669579B.8050706@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday 10 December 2015 11:44:43 Hans Verkuil wrote:
> If libudev is not available (android!),

It's time for Android to grow up and get rid of their LGPL hatred... That 
might actually happen as a result of the Chrome/Android merge that seems to be 
planned, as well as from the Android One project that will require something 
like libudev (although knowing the Android folks they might decide to 
reimplement it).

> then just try to find the device in /dev. It's a poor man's solution, but it
> is better than nothing.

Can't we assume that, on such systems, the device will always be named 
/dev/video* or /dev/v4l-subdev* ? If so we could lower the runtime impact by 
only checking the /sys/class/video4linux/video* and 
/sys/class/video4linux/v4l-subdev* entries to match the device minor and 
major, and use the index from the sysfs entry to create the /dev path.

My enumeration library (which I need to revive) implements that, feel free to 
use the code if it can be useful.

git://git.ideasonboard.org/media-enum.git

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
> index 4a82d24..1577783 100644
> --- a/utils/media-ctl/libmediactl.c
> +++ b/utils/media-ctl/libmediactl.c
> @@ -441,7 +441,10 @@ static int media_get_devname_udev(struct udev *udev,
>  	return ret;
>  }
> 
> -#else	/* HAVE_LIBUDEV */
> +#else
> +
> +#include <dirent.h>
> +#include <sys/stat.h>
> 
>  struct udev;
> 
> @@ -449,10 +452,36 @@ static inline int media_udev_open(struct udev **udev)
> { return 0; }
> 
>  static inline void media_udev_close(struct udev *udev) { }
> 
> -static inline int media_get_devname_udev(struct udev *udev,
> -		struct media_entity *entity)
> +static int media_get_devname_udev(struct udev *udev,
> +				  struct media_entity *entity)
>  {
> -	return -ENOTSUP;
> +	DIR *dp;
> +	struct dirent *ep;
> +	dev_t devnum;
> +
> +	dp = opendir("/dev");
> +	if (dp == NULL) {
> +		media_dbg(entity->media, "couldn't open /dev\n");
> +		return -ENODEV;
> +	}
> +	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
> +	while ((ep = readdir(dp))) {
> +		struct stat st;
> +		char fname[256];
> +
> +		snprintf(fname, sizeof(fname) - 1, "/dev/%s", ep->d_name);
> +		fname[sizeof(fname) - 1] = 0;
> +		stat(fname, &st);
> +		if ((st.st_mode & S_IFMT) != S_IFCHR)
> +			continue;
> +		if (st.st_rdev == devnum) {
> +			strncpy(entity->devname, fname, sizeof(entity->devname));
> +                        entity->devname[sizeof(entity->devname) - 1] =
> '\0';
> +			return 0;
> +		}
> +	}
> +	closedir(dp);
> +	return -ENODEV;
>  }
> 
>  #endif	/* HAVE_LIBUDEV */

-- 
Regards,

Laurent Pinchart

