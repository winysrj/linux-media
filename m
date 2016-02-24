Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57286 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbcBXPnO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 10:43:14 -0500
Subject: Re: [v4l-utils PATCH 4/4] media-ctl: List supported media bus formats
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
References: <1456090187-1191-1-git-send-email-sakari.ailus@linux.intel.com>
 <3174978.uNIbAnUxCz@avalon>
 <20160223202400.GA11084@valkosipuli.retiisi.org.uk>
 <5560544.fDzogjZUfJ@avalon> <56CDCE92.1060200@xs4all.nl>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <56CDCF42.4010809@linux.intel.com>
Date: Wed, 24 Feb 2016 17:41:54 +0200
MIME-Version: 1.0
In-Reply-To: <56CDCE92.1060200@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On 02/23/16 21:30, Laurent Pinchart wrote:
>> Hi Sakari,
>>
>> On Tuesday 23 February 2016 22:24:00 Sakari Ailus wrote:
>>> On Tue, Feb 23, 2016 at 10:15:46PM +0200, Laurent Pinchart wrote:
>>>> On Tuesday 23 February 2016 17:15:15 Hans Verkuil wrote:
>>>>> On 02/23/2016 05:11 PM, Sakari Ailus wrote:
>>>>>> On Tue, Feb 23, 2016 at 01:18:53PM +0100, Hans Verkuil wrote:
>>>>>>> On 02/21/16 22:29, Sakari Ailus wrote:
>>>>>>>> Add a new topic option for -h to allow listing supported media bus
>>>>>>>> codes in conversion functions. This is useful in figuring out which
>>>>>>>> media bus codes are actually supported by the library. The numeric
>>>>>>>> values of the codes are listed as well.
>>>>>>>>
>>>>>>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>>>>>> ---
>>>>>>>>
>>>>>>>>  utils/media-ctl/options.c | 42 ++++++++++++++++++++++++++++++++----
>>>>>>>>  1 file changed, 38 insertions(+), 4 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
>>>>>>>> index 0afc9c2..55cdd29 100644
>>>>>>>> --- a/utils/media-ctl/options.c
>>>>>>>> +++ b/utils/media-ctl/options.c
>>
>> [snip]
>>
>>>>>>>> @@ -45,7 +47,8 @@ static void usage(const char *argv0)
>>>>>>>>
>>>>>>>>  	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to
>>>>>>>>  	setup\n");
>>>>>>>>  	printf("    --get-v4l2 pad	Print the active format on a given
>>>>>>>> pad\n");
>>>>>>>>  	printf("    --set-dv pad	Configure DV timings on a given pad\n");
>>>>>>>>
>>>>>>>> -	printf("-h, --help		Show verbose help and exit\n");
>>>>>>>> +	printf("-h, --help[=topic]	Show verbose help and exit\n");
>>>>>>>> +	printf("			topics:	mbus-fmt: List supported media bus pixel
>>>>>>>> codes\n");
>>>>>>>
>>>>>>> OK, this is ugly. It has nothing to do with usage help.
>>>>>>>
>>>>>>> Just make a new option --list-mbus-fmts to list supported media bus
>>>>>>> pixel codes.
>>>>>>>
>>>>>>> That would make much more sense.
>>>>>>
>>>>>> I added it as a --help option argument in order to imply it's a part
>>>>>> of the program's usage instructions, which is what it indeed is. It's
>>>>>> not a list of media bus formats supported by a device.
>>>>>>
>>>>>> A separate option is fine, but it should be clear that it's about just
>>>>>> listing supported formats. E.g. --list-supported-mbus-fmts. But that's
>>>>>> a long one. Long options are loooong.
>>>>>
>>>>> --list-known-mbus-fmts will do the trick.
>>>>
>>>> That doesn't feel right. Isn't it a help option, really, given that it
>>>> lists the formats you can use as command line arguments ?
> 
> The help arguments don't have 'options'. You could provide a --help-list-mbus-fmts,
> though.
> 
>>>> Another option would actually be to always print the formats when the -h
>>>> switch is given. We could print them in a comma-separated list with
>>>> multiple formats per line, possibly dropping the numerical value, it
>>>> should hopefully not be horrible.
> 
> Just always printing the list when -h is given works for me too.
> 
> Regards,
> 
> 	Hans
> 
>>>
>>> I'd prefer to keep the numerical value as well; the link validation code in
>>> drivers may print the media bus code at each end in case they do not match.
>>> To debug that, it's easy to grep that from the list media-ctl prints.
>>
>> Grepping media-bus-formats.h shouldn't be difficult ;-)
>>
>> To shorten the output, how about printing the numerical values as 0x%04x or 
>> %04x ?
>>


-- 
Sakari Ailus
sakari.ailus@linux.intel.com
