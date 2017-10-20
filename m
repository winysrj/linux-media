Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:41975 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753235AbdJTL4w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 07:56:52 -0400
Subject: Re: [PATCH 1/2] v4l-utils: do not query capabilities of sub-devices.
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Harald Dankworth <hardankw@cisco.com>
References: <1508418555-8870-1-git-send-email-hardankw@cisco.com>
 <20171019145344.iucrcbx2buyu4xaa@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org, hansverk@cisco.com,
        tharvey@gateworks.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ad956f0c-d3e9-2f3b-d3d7-41dcd362183a@xs4all.nl>
Date: Fri, 20 Oct 2017 13:56:48 +0200
MIME-Version: 1.0
In-Reply-To: <20171019145344.iucrcbx2buyu4xaa@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/10/17 16:53, Sakari Ailus wrote:
> Hi Harald and Hans,
> 
> On Thu, Oct 19, 2017 at 03:09:15PM +0200, Harald Dankworth wrote:
>> Find the major and minor numbers of the device. Check if the
>> file /dev/dev/char/major:minor/uevent contains "DEVNAME=v4l-subdev".
>> If so, the device is a sub-device.
>>
>> Signed-off-by: Harald Dankworth <hardankw@cisco.com>
>> Reviewed-by: Hans Verkuil <hansverk@cisco.com>
> 
> I wonder if this is the best way to obtain the information. I thought there
> was an intent to add something to sysfs that wasn't based on device names.
> This also hardcodes the sysfs path.

This is what we discussed on irc some time ago. And if /sys is mounted somewhere
else, then you have bigger problems :-)

The device name in /sys comes from the driver and isn't changed by udev rules.
So we can use it to determine if it is a subdev or not.

> Would udev provide anything useful in this respect?

Not all embedded systems use udev. I'd rather not depend on it, at least not for
this utility.

The alternative to this is to add a QUERYCAP-like ioctl for subdevs, but my
proposal for that has been repeatedly shot down.

In the meantime we need *something* so you can use v4l2-ctl to query/get/set
controls and the EDID for HDMI receivers (Tim Harvey needs this).

I would like to merge this soon. It can always be changed if we switch to another
better method.

Regards,

	Hans

> 
> yavta would likely benefit from something similar.
> 
>> ---
>>  utils/v4l2-ctl/v4l2-ctl.cpp | 56 ++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 55 insertions(+), 1 deletion(-)
>>
>> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
>> index 5c67bf0..e02dc75 100644
>> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
>> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
>> @@ -46,6 +46,7 @@
>>  #include <vector>
>>  #include <map>
>>  #include <algorithm>
>> +#include <fstream>
>>  
>>  char options[OptLast];
>>  
>> @@ -1142,6 +1143,59 @@ __u32 find_pixel_format(int fd, unsigned index, bool output, bool mplane)
>>  	return fmt.pixelformat;
>>  }
>>  
>> +static bool is_subdevice(int fd)
>> +{
>> +	struct stat sb;
>> +	if (fstat(fd, &sb) == -1) {
>> +		fprintf(stderr, "failed to stat file\n");
>> +		exit(1);
>> +	}
>> +
>> +	char uevent_path[100];
>> +	if (snprintf(uevent_path, sizeof(uevent_path), "/sys/dev/char/%d:%d/uevent",
>> +		     major(sb.st_rdev), minor(sb.st_rdev)) == -1) {
>> +		fprintf(stderr, "failed to create uevent file path\n");
>> +		exit(1);
>> +	}
>> +
>> +	std::ifstream uevent_file(uevent_path);
>> +	if (uevent_file.fail()) {
>> +		fprintf(stderr, "failed to open %s\n", uevent_path);
>> +		exit(1);
>> +	}
>> +
>> +	std::string line;
>> +
>> +	while (std::getline(uevent_file, line)) {
>> +		if (line.compare(0, 8, "DEVNAME="))
>> +			continue;
>> +
>> +		static const char * devnames[] = {
>> +			"v4l-subdev",
>> +			"video",
>> +			"vbi",
>> +			"radio",
>> +			"swradio",
>> +			"v4l-touch",
>> +			NULL
>> +		};
>> +
>> +		for (size_t i = 0; devnames[i]; i++) {
>> +			size_t len = strlen(devnames[i]);
>> +
>> +			if (!line.compare(8, len, devnames[i]) && isdigit(line[8+len])) {
>> +				uevent_file.close();
>> +				return i == 0;
>> +			}
>> +		}
>> +	}
>> +
>> +	uevent_file.close();
>> +
>> +	fprintf(stderr, "unknown device name\n");
>> +	exit(1);
>> +}
>> +
>>  int main(int argc, char **argv)
>>  {
>>  	int i;
>> @@ -1310,7 +1364,7 @@ int main(int argc, char **argv)
>>  	}
>>  
>>  	verbose = options[OptVerbose];
>> -	if (doioctl(fd, VIDIOC_QUERYCAP, &vcap)) {
>> +	if (!is_subdevice(fd) && doioctl(fd, VIDIOC_QUERYCAP, &vcap)) {
>>  		fprintf(stderr, "%s: not a v4l2 node\n", device);
>>  		exit(1);
>>  	}
>> -- 
>> 2.7.4
>>
> 
