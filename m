Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58694 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2AOQQd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 11:16:33 -0500
Received: by eekd4 with SMTP id d4so1626057eek.19
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 08:16:32 -0800 (PST)
Message-ID: <4F12FBDB.3050500@gmail.com>
Date: Sun, 15 Jan 2012 17:16:27 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dacohen@gmail.com
Subject: Re: [RFC 08/17] v4l: Image source control class
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-8-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201201051723.41247.laurent.pinchart@ideasonboard.com> <4F11EAD3.9070004@maxwell.research.nokia.com>
In-Reply-To: <4F11EAD3.9070004@maxwell.research.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/14/2012 09:51 PM, Sakari Ailus wrote:
>>> diff --git a/drivers/media/video/v4l2-ctrls.c
>>> b/drivers/media/video/v4l2-ctrls.c index 083bb79..da1ec52 100644
>>> --- a/drivers/media/video/v4l2-ctrls.c
>>> +++ b/drivers/media/video/v4l2-ctrls.c
>>> @@ -606,6 +606,12 @@ const char *v4l2_ctrl_get_name(u32 id)
>>>   	case V4L2_CID_FLASH_CHARGE:		return "Charge";
>>>   	case V4L2_CID_FLASH_READY:		return "Ready to strobe";
>>>
>>> +	case V4L2_CID_IMAGE_SOURCE_CLASS:	return "Image source controls";
>>> +	case V4L2_CID_IMAGE_SOURCE_VBLANK:	return "Vertical blanking";
>>> +	case V4L2_CID_IMAGE_SOURCE_HBLANK:	return "Horizontal blanking";
>>> +	case V4L2_CID_IMAGE_SOURCE_LINK_FREQ:	return "Link frequency";
>>> +	case V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN: return "Analogue gain";
>>
>> Please capitalize each word, as done for the other controls.
> 
> This isn't done for the flash controls either, have you noticed that?
> 
> Well, I guess I have to admit that they were added by myself. ;-)
> 
> I can fix this for the next patchset.
 
I don't want to be annoying (too much ;)) but the FLASH controls documentation
is missing some <constant> tags in the text.  Other classes use them for
standard identifiers.

Regards, 
Sylwester
