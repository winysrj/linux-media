Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:48892 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab2AOTaY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 14:30:24 -0500
Message-ID: <4F13294B.9080201@maxwell.research.nokia.com>
Date: Sun, 15 Jan 2012 21:30:19 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dacohen@gmail.com
Subject: Re: [RFC 08/17] v4l: Image source control class
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-8-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201201051723.41247.laurent.pinchart@ideasonboard.com> <4F11EAD3.9070004@maxwell.research.nokia.com> <4F12FBDB.3050500@gmail.com>
In-Reply-To: <4F12FBDB.3050500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> On 01/14/2012 09:51 PM, Sakari Ailus wrote:
>>>> diff --git a/drivers/media/video/v4l2-ctrls.c
>>>> b/drivers/media/video/v4l2-ctrls.c index 083bb79..da1ec52 100644
>>>> --- a/drivers/media/video/v4l2-ctrls.c
>>>> +++ b/drivers/media/video/v4l2-ctrls.c
>>>> @@ -606,6 +606,12 @@ const char *v4l2_ctrl_get_name(u32 id)
>>>>   	case V4L2_CID_FLASH_CHARGE:		return "Charge";
>>>>   	case V4L2_CID_FLASH_READY:		return "Ready to strobe";
>>>>
>>>> +	case V4L2_CID_IMAGE_SOURCE_CLASS:	return "Image source controls";
>>>> +	case V4L2_CID_IMAGE_SOURCE_VBLANK:	return "Vertical blanking";
>>>> +	case V4L2_CID_IMAGE_SOURCE_HBLANK:	return "Horizontal blanking";
>>>> +	case V4L2_CID_IMAGE_SOURCE_LINK_FREQ:	return "Link frequency";
>>>> +	case V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN: return "Analogue gain";
>>>
>>> Please capitalize each word, as done for the other controls.
>>
>> This isn't done for the flash controls either, have you noticed that?
>>
>> Well, I guess I have to admit that they were added by myself. ;-)
>>
>> I can fix this for the next patchset.
>  
> I don't want to be annoying (too much ;)) but the FLASH controls documentation
> is missing some <constant> tags in the text.  Other classes use them for
> standard identifiers.

Thanks for letting me know --- that could be fixed with the flash timing
control API, or unrelated to that. We should btw. continue discussion on
that one. :-)

Speaking of things to do... The colour of the object to point and press
V4L2_CID_DO_WHITE_BALANCE (or what was it called) to fix the white
balance --- is that white, gray, something else or implementation
dependent? I vaguely remember having seen some grayish plates being used
for that but I'm definitely not sure. :-) Any idea?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
