Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:52675 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786AbcBWQPV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 11:15:21 -0500
Subject: Re: [v4l-utils PATCH 4/4] media-ctl: List supported media bus formats
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1456090187-1191-1-git-send-email-sakari.ailus@linux.intel.com>
 <1456090187-1191-5-git-send-email-sakari.ailus@linux.intel.com>
 <56CC4E2D.7010702@xs4all.nl>
 <20160223161150.GA32612@valkosipuli.retiisi.org.uk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56CC8593.6090005@xs4all.nl>
Date: Tue, 23 Feb 2016 17:15:15 +0100
MIME-Version: 1.0
In-Reply-To: <20160223161150.GA32612@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/23/2016 05:11 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Tue, Feb 23, 2016 at 01:18:53PM +0100, Hans Verkuil wrote:
>> On 02/21/16 22:29, Sakari Ailus wrote:
>>> Add a new topic option for -h to allow listing supported media bus codes
>>> in conversion functions. This is useful in figuring out which media bus
>>> codes are actually supported by the library. The numeric values of the
>>> codes are listed as well.
>>>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>> ---
>>>  utils/media-ctl/options.c | 42 ++++++++++++++++++++++++++++++++++++++----
>>>  1 file changed, 38 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
>>> index 0afc9c2..55cdd29 100644
>>> --- a/utils/media-ctl/options.c
>>> +++ b/utils/media-ctl/options.c
>>> @@ -22,7 +22,9 @@
>>>  #include <getopt.h>
>>>  #include <stdio.h>
>>>  #include <stdlib.h>
>>> +#include <string.h>
>>>  #include <unistd.h>
>>> +#include <v4l2subdev.h>
>>>  
>>>  #include <linux/videodev2.h>
>>>  
>>> @@ -45,7 +47,8 @@ static void usage(const char *argv0)
>>>  	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
>>>  	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
>>>  	printf("    --set-dv pad	Configure DV timings on a given pad\n");
>>> -	printf("-h, --help		Show verbose help and exit\n");
>>> +	printf("-h, --help[=topic]	Show verbose help and exit\n");
>>> +	printf("			topics:	mbus-fmt: List supported media bus pixel codes\n");
>>
>> OK, this is ugly. It has nothing to do with usage help.
>>
>> Just make a new option --list-mbus-fmts to list supported media bus pixel
>> codes.
>>
>> That would make much more sense.
> 
> I added it as a --help option argument in order to imply it's a part of the
> program's usage instructions, which is what it indeed is. It's not a list of
> media bus formats supported by a device.
> 
> A separate option is fine, but it should be clear that it's about just
> listing supported formats. E.g. --list-supported-mbus-fmts. But that's a
> long one. Long options are loooong.

--list-known-mbus-fmts will do the trick.

Regards,

	Hans
