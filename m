Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:31843 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2ABEiw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jan 2012 23:38:52 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LX5008L0M8EBFE0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Jan 2012 13:38:50 +0900 (KST)
Received: from [165.213.219.119] by mmp2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTPA id <0LX500G4WM8Q3YC0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Jan 2012 13:38:50 +0900 (KST)
Message-id: <4F0134DC.507@samsung.com>
Date: Mon, 02 Jan 2012 13:38:52 +0900
From: "Kim, Heungjun" <riverful.kim@samsung.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, kyungmin.park@samsung.com,
	'Hans de Goede' <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <1325053428-2626-2-git-send-email-riverful.kim@samsung.com>
 <4EFB1B04.6060305@gmail.com>
 <201112281451.39399.laurent.pinchart@ideasonboard.com>
 <001101ccc5e7$d9f48620$8ddd9260$%kim@samsung.com> <4EFD92C9.1030704@gmail.com>
In-reply-to: <4EFD92C9.1030704@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011년 12월 30일 19:30, Sylwester Nawrocki wrote:
> Hi HeungJun,
>
> On 12/29/2011 06:08 AM, HeungJun, Kim wrote:
>>> -----Original Message-----
>>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>>> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
>>> Sent: Wednesday, December 28, 2011 10:52 PM
>>> To: Sylwester Nawrocki
>>> Cc: HeungJun, Kim; linux-media@vger.kernel.org; mchehab@redhat.com;
>>> hverkuil@xs4all.nl; sakari.ailus@iki.fi; kyungmin.park@samsung.com; Hans de
>>> Goede
>>> Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu
>>> control
>>>
>>> Hi,
>>>
>>> On Wednesday 28 December 2011 14:35:00 Sylwester Nawrocki wrote:
>>>> On 12/28/2011 07:23 AM, HeungJun, Kim wrote:
>>>>> It adds the new CID for setting White Balance Preset. This CID is
>>>>> provided as menu type using the following items:
>>>>> 0 - V4L2_WHITE_BALANCE_INCANDESCENT,
>>>>> 1 - V4L2_WHITE_BALANCE_FLUORESCENT,
>>>>> 2 - V4L2_WHITE_BALANCE_DAYLIGHT,
>>>>> 3 - V4L2_WHITE_BALANCE_CLOUDY,
>>>>> 4 - V4L2_WHITE_BALANCE_SHADE,
>>>> I have been also investigating those white balance presets recently and
>>>> noticed they're also needed for the pwc driver. Looking at
>>>> drivers/media/video/pwc/pwc-v4l2.c there is something like:
>>>>
>>>> const char * const pwc_auto_whitebal_qmenu[] = {
>>>> 	"Indoor (Incandescant Lighting) Mode",
>>>> 	"Outdoor (Sunlight) Mode",
>>>> 	"Indoor (Fluorescent Lighting) Mode",
>>>> 	"Manual Mode",
>>>> 	"Auto Mode",
>>>> 	NULL
>>>> };
>>>>
>>>> static const struct v4l2_ctrl_config pwc_auto_white_balance_cfg = {
>>>> 	.ops	=&pwc_ctrl_ops,
>>>> 	.id	= V4L2_CID_AUTO_WHITE_BALANCE,
>>>> 	.type	= V4L2_CTRL_TYPE_MENU,
>>>> 	.max	= awb_auto,
>>>> 	.qmenu	= pwc_auto_whitebal_qmenu,
>>>> };
>>>>
>>>> ...
>>>>
>>>> 	cfg = pwc_auto_white_balance_cfg;
>>>> 	cfg.name = v4l2_ctrl_get_name(cfg.id);
>>>> 	cfg.def = def;
>>>> 	pdev->auto_white_balance = v4l2_ctrl_new_custom(hdl,&cfg, NULL);
>>>>
>>>> So this driver re-defines V4L2_CID_AUTO_WHITE_BALANCE as a menu control
>>>> with custom entries. That's interesting... However it works in practice
>>>> and applications have access to what's provided by hardware.
>>>> Perhaps V4L2_CID_AUTO_WHITE_BALANCE_TEMPERATURE would be a better fit for
>>>> that :)
>>>>
>>>> Nevertheless, redefining standard controls in particular drivers sounds
>>>> a little dubious. I wonder if this is a generally agreed approach ?
>>> No agreed with me at least :-)
>> I guess the WBP menu controls of pwc driver is probably defined in the other
>> headers, for users being well known the PWC hardware. So it should be managed
>> separately to videodev2.h. Is it right? Even if the way might be slightly
>> different, it can't avoid to be "managed separately".
>>
>> It means the users being not well known the specific hardware like PWC,
>> have difficulty to use that driver well.
>> And, at least, It doesn't looks generic API for me.
>> In this case, the unfamiliar user with such unique hardware, can use
>> whatever he wants to use finally, after finding&  looking around the headers.
> Applications can query drivers for supported controls and populate user control
> panels dynamically, based on information from VIDIOC_QUERYCTRL and VIDIOC_QUERYMENU
> ioctls. Not needing to rely on menu items definition in videodev2.h.
> I had a feeling you weren't considering such case. :)
You're right in that meaning. And it might be a good point.
But, I think these 2 ioctl can not handle about this issue.

Before using VIDIOC_QUERYCTRL and VIDIOC_QUERYMENU, the user should know 
which CID name
is used in the videodev2.h, and anyway it can not be avoidable the user 
find out this name in it. :)
At least I've seen nobody makes the application just to open(), 
queryctrl(), querymenu(), and close(),
only for scanning the specific control is existed or not.
Until now, I have known these 2 ioctl is generally used for formating 
the UI componets like button,
menu, and etc, on the screen.
So, it's safe to say that the user who knows that specific control is 
also know the CID name,
the user knows such specific controls don't need even VIDIOC_QUERYCTRL 
and VIDIOC_QUERYMENU.

And IMHO, this is not related about pulling out the hidden(?) controls 
generally used in the camera,
on the videodev2.h. I think it's only generic defined in videodev2.h.

I really had wondered why the controls I thought very general for camera 
is in hidden(?) the specific driver,
not in the videodev2.h. It was just start to consider this issues.

Regards,
Heungjun Kim

> Perhaps it's uncommon in embedded systems though.
>
> --
>
> Regards,
> Sylwester
>

