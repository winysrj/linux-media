Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5C4C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 17:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6501222DA
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 17:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbfBNRR0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 12:17:26 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:59168 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726160AbfBNRR0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 12:17:26 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id uKdTggyvzI8AWuKdWg0K5r; Thu, 14 Feb 2019 18:17:23 +0100
Subject: Re: [PATCH] media-ctl: add --bus-info
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <cee8c085-785f-f793-715d-c4c4d09a5f36@xs4all.nl>
 <20190214163302.GL3682@pendragon.ideasonboard.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cc4f966c-b2fa-3e5d-01d1-9bc26c8fdcf1@xs4all.nl>
Date:   Thu, 14 Feb 2019 18:17:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190214163302.GL3682@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfP8r4Hl43vwpGAfnayDdU5p+QZfwOWfOZcCqQCDezEmj0+dZor30nakhXhLL7VuWXtD22HtAVx9xcFzy6ZQYDe855QHAFFrENPXGTytkgoHitd0/XnP+
 KX2fzAAq/+p6FUp46n/6fvKJcWwU/j1Ac3UpVhdMSsNvrpZoLC7qIDF2ehs76ZU/qT9pGm9q0VYSbCj+Y8RQXasunFwowUaoW3z0tygqjb6ER53WskT3MmMR
 LCzrMHmArR5yiOba2h0MSFWWgReO7CC5iPVle9bqxJ0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/14/19 5:33 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Thu, Feb 14, 2019 at 04:43:17PM +0100, Hans Verkuil wrote:
>> Add a --bus-info option to media-ctl which opens the media device
>> that has this bus info string. That makes it possible to open a specific
>> media device without having to know the name of the media device.
>>
>> Similar functionality has been implemented for v4l2-ctl and v4l2-compliance,
>> and for the cec utilities.
>>
>> This allows scripts that no longer need to care about the name of a device
>> node, instead they can find it based on a unique string.
>>
>> Also extend the -d option to support -d0 as a shorthand for /dev/media0 to
>> make it consistent with the other utils.
>>
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> ---
>> diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
>> index 16367857..0430b8bc 100644
>> --- a/utils/media-ctl/options.c
>> +++ b/utils/media-ctl/options.c
>> @@ -19,13 +19,18 @@
>>   * along with this program. If not, see <http://www.gnu.org/licenses/>.
>>   */
>>
>> +#include <ctype.h>
>> +#include <dirent.h>
>> +#include <fcntl.h>
>>  #include <getopt.h>
>>  #include <stdio.h>
>>  #include <stdlib.h>
>>  #include <string.h>
>> +#include <sys/ioctl.h>
>>  #include <unistd.h>
>>  #include <v4l2subdev.h>
>>
>> +#include <linux/media.h>
>>  #include <linux/videodev2.h>
>>
>>  #include "options.h"
>> @@ -42,7 +47,9 @@ static void usage(const char *argv0)
>>  	unsigned int i;
>>
>>  	printf("%s [options]\n", argv0);
>> +	printf("-b, --bus-info name	Use the media device with bus info equal to name\n");
> 
> When seeing --bus-info I initially thought it was meant to print bus
> information. I wonder if we could find a name a bit more straightforward
> to guess. Would it be an option to reuse the -d option, first trying to
> open the specified device node, and considering it as a bus-info string
> if the file doesn't exist ?

That was actually my first approach. I'll change this in a v2.

> 
>>  	printf("-d, --device dev	Media device name (default: %s)\n", MEDIA_DEVNAME_DEFAULT);
>> +	printf("			If <dev> starts with a digit, then /dev/media<dev> is used.\n");
>>  	printf("-e, --entity name	Print the device name associated with the given entity\n");
>>  	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
>>  	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
>> @@ -121,6 +128,7 @@ static void usage(const char *argv0)
>>  #define OPT_GET_DV			260
>>
>>  static struct option opts[] = {
>> +	{"bus-info", 1, 0, 'b'},
>>  	{"device", 1, 0, 'd'},
>>  	{"entity", 1, 0, 'e'},
>>  	{"set-format", 1, 0, 'f'},
>> @@ -161,6 +169,51 @@ static void list_known_mbus_formats(void)
>>  	}
>>  }
>>
>> +static const char *find_bus_info(const char *bus_info)
>> +{
>> +	static char newdev[300];
>> +	struct dirent *ep;
>> +	DIR *dp;
>> +
>> +	dp = opendir("/dev");
>> +	if (dp == NULL)
>> +		return NULL;
>> +
>> +	while ((ep = readdir(dp))) {
>> +		const char *name = ep->d_name;
>> +
>> +		if (!memcmp(name, "media", 5) && isdigit(name[5])) {
>> +			struct media_device_info mdi;
>> +			int ret;
>> +			int fd;
>> +
>> +			snprintf(newdev, sizeof(newdev), "/dev/%s", name);
>> +			fd = open(newdev, O_RDWR);
> 
> You can use openat() instead of open() to avoid the snprintf.

Thanks for the tip!

> 
>> +			if (fd < 0)
>> +				continue;
>> +			ret = ioctl(fd, MEDIA_IOC_DEVICE_INFO, &mdi);
>> +			close(fd);
>> +			if (!ret && !strcmp(bus_info, mdi.bus_info)) {
>> +				closedir(dp);
>> +				return newdev;
>> +			}
>> +		}
>> +	}
>> +	closedir(dp);
>> +	return NULL;
> 
> Should we try to enumerate media devices using libudev, to support
> systems with custom udev rules ?

I think that's overkill. Might be something for the future, though.

> 
>> +}
>> +
>> +static const char *make_devname(const char *device)
>> +{
>> +	static char newdev[300];
> 
> Seems a bit long for concatenating /dev/media and a 3 characters string.
> 
>> +
>> +	if (device[0] >= '0' && device[0] <= '9' && strlen(device) <= 3) {
> 
> 	if (isdigit(device[0]) && strlen(device) <= 3)
> 
> Shouldn't you however check that the whole string parses as a number ?

It's code copied from the other utilities. You can do this, but it's overkill.

I.e. '-d 0p' won't be a valid device node regardless.

> 
>> +		snprintf(newdev, sizeof(newdev), "/dev/media%s", device);
>> +		return newdev;
>> +	}
>> +	return device;
>> +}
>> +
>>  int parse_cmdline(int argc, char **argv)
>>  {
>>  	int opt;
>> @@ -171,11 +224,20 @@ int parse_cmdline(int argc, char **argv)
>>  	}
>>
>>  	/* parse options */
>> -	while ((opt = getopt_long(argc, argv, "d:e:f:hil:prvV:",
>> +	while ((opt = getopt_long(argc, argv, "b:d:e:f:hil:prvV:",
>>  				  opts, NULL)) != -1) {
>>  		switch (opt) {
>> +		case 'b':
>> +			media_opts.devname = find_bus_info(optarg);
>> +			if (!media_opts.devname) {
>> +				fprintf(stderr, "Error: no media device with bus info '%s' found\n",
>> +					optarg);
>> +				return 1;
>> +			}
>> +			break;
>> +
>>  		case 'd':
>> -			media_opts.devname = optarg;
>> +			media_opts.devname = make_devname(optarg);
>>  			break;
>>
>>  		case 'e':
> 

Regards,

	Hans
