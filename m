Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59377 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2AOUIV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 15:08:21 -0500
Received: by eekd4 with SMTP id d4so1674806eek.19
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 12:08:20 -0800 (PST)
Message-ID: <4F133227.1030302@gmail.com>
Date: Sun, 15 Jan 2012 21:08:07 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dacohen@gmail.com
Subject: Re: [RFC 08/17] v4l: Image source control class
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-8-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201201051723.41247.laurent.pinchart@ideasonboard.com> <4F11EAD3.9070004@maxwell.research.nokia.com> <4F12FBDB.3050500@gmail.com> <4F13294B.9080201@maxwell.research.nokia.com>
In-Reply-To: <4F13294B.9080201@maxwell.research.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/15/2012 08:30 PM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> Sylwester Nawrocki wrote:
>> On 01/14/2012 09:51 PM, Sakari Ailus wrote:
>>>>> diff --git a/drivers/media/video/v4l2-ctrls.c
>>>>> b/drivers/media/video/v4l2-ctrls.c index 083bb79..da1ec52 100644
>>>>> --- a/drivers/media/video/v4l2-ctrls.c
>>>>> +++ b/drivers/media/video/v4l2-ctrls.c
>>>>> @@ -606,6 +606,12 @@ const char *v4l2_ctrl_get_name(u32 id)
>>>>>    	case V4L2_CID_FLASH_CHARGE:		return "Charge";
>>>>>    	case V4L2_CID_FLASH_READY:		return "Ready to strobe";
>>>>>
>>>>> +	case V4L2_CID_IMAGE_SOURCE_CLASS:	return "Image source controls";
>>>>> +	case V4L2_CID_IMAGE_SOURCE_VBLANK:	return "Vertical blanking";
>>>>> +	case V4L2_CID_IMAGE_SOURCE_HBLANK:	return "Horizontal blanking";
>>>>> +	case V4L2_CID_IMAGE_SOURCE_LINK_FREQ:	return "Link frequency";
>>>>> +	case V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN: return "Analogue gain";
>>>>
>>>> Please capitalize each word, as done for the other controls.
>>>
>>> This isn't done for the flash controls either, have you noticed that?
>>>
>>> Well, I guess I have to admit that they were added by myself. ;-)
>>>
>>> I can fix this for the next patchset.
>>
>> I don't want to be annoying (too much ;)) but the FLASH controls documentation
>> is missing some<constant>  tags in the text.  Other classes use them for
>> standard identifiers.
> 
> Thanks for letting me know --- that could be fixed with the flash timing
> control API, or unrelated to that. We should btw. continue discussion on
> that one. :-)

Sure, I remember having a patch for that style correction somewhere around.

Certainly the Flash topic needs continuation, I'll get back to it shortly.
I just need to do some more research about it and it is not of really high
priority on my side now. Plus I have temporarily been out of order for the
last week..

I have just prepared an auto focus controls draft patch. I'll post it
hopefully tonight to move things forward.

> Speaking of things to do... The colour of the object to point and press
> V4L2_CID_DO_WHITE_BALANCE (or what was it called) to fix the white
> balance --- is that white, gray, something else or implementation
> dependent? I vaguely remember having seen some grayish plates being used
> for that but I'm definitely not sure. :-) Any idea?

As far as I know it should be always an object which is perceived as white.
Something else don't seem to be terribly useful to set up white balance.
Unfortunately I don't have much of experience with that yet.

--
Regards,
Sylwester
