Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7549C4360F
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 09:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF737222F1
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 09:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404858AbfBOJjS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 04:39:18 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:56039 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391708AbfBOJjR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 04:39:17 -0500
Received: from [IPv6:2001:420:44c1:2579:bca2:3803:89c3:7ff1] ([IPv6:2001:420:44c1:2579:bca2:3803:89c3:7ff1])
        by smtp-cloud8.xs4all.net with ESMTPA
        id uZxfgI88I4HFnuZxjgsNHW; Fri, 15 Feb 2019 10:39:15 +0100
Subject: Re: [PATCHv2] media-ctl: support a bus-info string as argument to -d
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <454f5a3f-e3a9-51b7-6932-5b2bacfa92ff@xs4all.nl>
 <20190215092201.GA3504@pendragon.ideasonboard.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e402352c-44d6-af06-b763-14bfa175fb00@xs4all.nl>
Date:   Fri, 15 Feb 2019 10:39:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190215092201.GA3504@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfBKOiMjDpAk4daZicBcQt2Nt7/QpxyqklsGSFL0zCiik07JRDCWk0TyWSwuRyZtE2CSrlWokFewwm1gG6QOLyQ2U8xkcoPHCekfyojbVs2IlsvAIgQXk
 BmmIN0hYI5AOu7lCfcgBfa0eNOw4YLXbBIYQMupFZ/h2nbQGehhSffNyKKXWlrvWUl68UFVqb2VCHfnhpapH+Ww+1+Ry0mHAnZvFNLfXGCNvq8XwDMofYTRr
 jVtXaAum9ua9N+oIt/D+H6NS3Zf9QOZMaQBxaAdlIaG55W+mTv3uWNViTDnEjn1nHRl05yVQpmDcmwBBiODwz23Rz3rAw/DT664ovQ21o1vDyJzooYL0aQUg
 d8UqJYCfcHVjyae2VzCWRVmxHLuFPg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/15/19 10:22 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Fri, Feb 15, 2019 at 09:10:24AM +0100, Hans Verkuil wrote:
>> If the device passed to the -d option is not found, then interpret it
>> as a bus-info string and try to open all media devices and see which one
>> reports a bus-info string equal to the -d argument.
>>
>> That makes it possible to open a specific media device without having to know
>> the name of the media device.
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
>> Changes since v1:
>> - fold into the -d option instead of creating a separate option
>> ---
>> diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
>> index 16367857..fb923775 100644
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
>> @@ -43,6 +48,9 @@ static void usage(const char *argv0)
>>
>>  	printf("%s [options]\n", argv0);
>>  	printf("-d, --device dev	Media device name (default: %s)\n", MEDIA_DEVNAME_DEFAULT);
>> +	printf("			If <dev> starts with a digit, then /dev/media<dev> is used.\n");
>> +	printf("			If <dev> doesn't exist, then find a media device that\n");
>> +	printf("			reports a bus info string equal to <dev>.\n");
>>  	printf("-e, --entity name	Print the device name associated with the given entity\n");
>>  	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
>>  	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
>> @@ -161,6 +169,48 @@ static void list_known_mbus_formats(void)
>>  	}
>>  }
>>
>> +static const char *make_devname(const char *device)
>> +{
>> +	static char newdev[300];
> 
> 300 is still a lot for such a short string.
> 
>> +	struct dirent *ep;
>> +	DIR *dp;
>> +
>> +	if (!access(device, F_OK))
>> +		return device;
>> +
>> +	if (device[0] >= '0' && device[0] <= '9' && strlen(device) <= 3) {
>> +		snprintf(newdev, sizeof(newdev), "/dev/media%s", device);
>> +		return newdev;

It's short for this,

>> +	}
>> +
>> +	dp = opendir("/dev");
>> +	if (dp == NULL)
>> +		return device;
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

but not for this. ep->d_name can be up to 255 chars.

I can use snprintf, but then gcc complains that the string will be truncated.

>> +			fd = open(newdev, O_RDWR);
> 
> Did openat() fail ?

There is no point, if this is a media device matching the bus_info, then
I need to return newdev anyway.

> 
>> +			if (fd < 0)
>> +				continue;
>> +			ret = ioctl(fd, MEDIA_IOC_DEVICE_INFO, &mdi);
>> +			close(fd);
>> +			if (!ret && !strcmp(device, mdi.bus_info)) {
>> +				closedir(dp);
>> +				return newdev;
>> +			}
>> +		}
>> +	}
>> +	closedir(dp);
>> +	return device;
>> +}
>> +
>>  int parse_cmdline(int argc, char **argv)
>>  {
>>  	int opt;
>> @@ -175,7 +225,7 @@ int parse_cmdline(int argc, char **argv)
>>  				  opts, NULL)) != -1) {
>>  		switch (opt) {
>>  		case 'd':
>> -			media_opts.devname = optarg;
>> +			media_opts.devname = make_devname(optarg);
>>  			break;
>>
>>  		case 'e':
> 

Regards,

	Hans
