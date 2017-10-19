Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44274 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752548AbdJSOxr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 10:53:47 -0400
Date: Thu, 19 Oct 2017 17:53:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Harald Dankworth <hardankw@cisco.com>
Cc: linux-media@vger.kernel.org, hansverk@cisco.com,
        tharvey@gateworks.com
Subject: Re: [PATCH 1/2] v4l-utils: do not query capabilities of sub-devices.
Message-ID: <20171019145344.iucrcbx2buyu4xaa@valkosipuli.retiisi.org.uk>
References: <1508418555-8870-1-git-send-email-hardankw@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508418555-8870-1-git-send-email-hardankw@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Harald and Hans,

On Thu, Oct 19, 2017 at 03:09:15PM +0200, Harald Dankworth wrote:
> Find the major and minor numbers of the device. Check if the
> file /dev/dev/char/major:minor/uevent contains "DEVNAME=v4l-subdev".
> If so, the device is a sub-device.
> 
> Signed-off-by: Harald Dankworth <hardankw@cisco.com>
> Reviewed-by: Hans Verkuil <hansverk@cisco.com>

I wonder if this is the best way to obtain the information. I thought there
was an intent to add something to sysfs that wasn't based on device names.
This also hardcodes the sysfs path.

Would udev provide anything useful in this respect?

yavta would likely benefit from something similar.

> ---
>  utils/v4l2-ctl/v4l2-ctl.cpp | 56 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index 5c67bf0..e02dc75 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -46,6 +46,7 @@
>  #include <vector>
>  #include <map>
>  #include <algorithm>
> +#include <fstream>
>  
>  char options[OptLast];
>  
> @@ -1142,6 +1143,59 @@ __u32 find_pixel_format(int fd, unsigned index, bool output, bool mplane)
>  	return fmt.pixelformat;
>  }
>  
> +static bool is_subdevice(int fd)
> +{
> +	struct stat sb;
> +	if (fstat(fd, &sb) == -1) {
> +		fprintf(stderr, "failed to stat file\n");
> +		exit(1);
> +	}
> +
> +	char uevent_path[100];
> +	if (snprintf(uevent_path, sizeof(uevent_path), "/sys/dev/char/%d:%d/uevent",
> +		     major(sb.st_rdev), minor(sb.st_rdev)) == -1) {
> +		fprintf(stderr, "failed to create uevent file path\n");
> +		exit(1);
> +	}
> +
> +	std::ifstream uevent_file(uevent_path);
> +	if (uevent_file.fail()) {
> +		fprintf(stderr, "failed to open %s\n", uevent_path);
> +		exit(1);
> +	}
> +
> +	std::string line;
> +
> +	while (std::getline(uevent_file, line)) {
> +		if (line.compare(0, 8, "DEVNAME="))
> +			continue;
> +
> +		static const char * devnames[] = {
> +			"v4l-subdev",
> +			"video",
> +			"vbi",
> +			"radio",
> +			"swradio",
> +			"v4l-touch",
> +			NULL
> +		};
> +
> +		for (size_t i = 0; devnames[i]; i++) {
> +			size_t len = strlen(devnames[i]);
> +
> +			if (!line.compare(8, len, devnames[i]) && isdigit(line[8+len])) {
> +				uevent_file.close();
> +				return i == 0;
> +			}
> +		}
> +	}
> +
> +	uevent_file.close();
> +
> +	fprintf(stderr, "unknown device name\n");
> +	exit(1);
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	int i;
> @@ -1310,7 +1364,7 @@ int main(int argc, char **argv)
>  	}
>  
>  	verbose = options[OptVerbose];
> -	if (doioctl(fd, VIDIOC_QUERYCAP, &vcap)) {
> +	if (!is_subdevice(fd) && doioctl(fd, VIDIOC_QUERYCAP, &vcap)) {
>  		fprintf(stderr, "%s: not a v4l2 node\n", device);
>  		exit(1);
>  	}
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
