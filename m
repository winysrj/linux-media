Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:54813 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab1BYM1E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 07:27:04 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp1 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LH600GV2AL2MWC0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Feb 2011 21:27:02 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LH600E1YAL1QZ@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Feb 2011 21:27:01 +0900 (KST)
Date: Fri, 25 Feb 2011 21:27:01 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [RFC PATCH v2 2/3] v4l2-ctrls: modify uvc driver to use new menu
 type of V4L2_CID_FOCUS_AUTO
In-reply-to: <201102251125.21034.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D67A015.2040408@samsung.com>
Content-transfer-encoding: 8BIT
References: <4D674A6C.8000401@samsung.com>
 <201102251020.59615.laurent.pinchart@ideasonboard.com>
 <4D678203.3080105@samsung.com>
 <201102251125.21034.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011-02-25 오후 7:25, Laurent Pinchart 쓴 글:
> Hi,
> 
> On Friday 25 February 2011 11:18:43 Kim, HeungJun wrote:
>> 2011-02-25 오후 6:20, Laurent Pinchart 쓴 글:
>>> On Friday 25 February 2011 07:21:32 Kim, HeungJun wrote:
>>>> As following to change the boolean type of V4L2_CID_FOCUS_AUTO to menu
>>>> type, this uvc is modified the usage of V4L2_CID_FOCUS_AUTO.
>>>>
>>>> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>
>>>>  drivers/media/video/uvc/uvc_ctrl.c |   13 ++++++++++---
>>>>  1 files changed, 10 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
>>>> b/drivers/media/video/uvc/uvc_ctrl.c index 59f8a9a..795fd3f 100644
>>>> --- a/drivers/media/video/uvc/uvc_ctrl.c
>>>> +++ b/drivers/media/video/uvc/uvc_ctrl.c
>>>> @@ -333,6 +333,11 @@ static struct uvc_menu_info
>>>> exposure_auto_controls[] = { { 8, "Aperture Priority Mode" },
>>>>
>>>>  };
>>>>
>>>> +static struct uvc_menu_info focus_auto_controls[] = {
>>>> +	{ 2, "Auto Mode" },
>>>> +	{ 1, "Manual Mode" },
>>>
>>> According to the UVC spec, this should be 0 for manual mode and 1 for
>>> auto mode.
>>
>> OK, I'll modify this values depends on below my question......
>>
>>>> +};
>>>> +
>>>>
>>>>  static __s32 uvc_ctrl_get_zoom(struct uvc_control_mapping *mapping,
>>>>  
>>>>  	__u8 query, const __u8 *data)
>>>>  
>>>>  {
>>>>
>>>> @@ -558,10 +563,12 @@ static struct uvc_control_mapping
>>>> uvc_ctrl_mappings[] = { .name		= "Focus, Auto",
>>>>
>>>>  		.entity		= UVC_GUID_UVC_CAMERA,
>>>>  		.selector	= UVC_CT_FOCUS_AUTO_CONTROL,
>>>>
>>>> -		.size		= 1,
>>>> +		.size		= 2,
>>>
>>> Why do you change the control size ?
>>>
>>>>  		.offset		= 0,
>>>>
>>>> -		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
>>>> -		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
>>>> +		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
>>>> +		.data_type	= UVC_CTRL_DATA_TYPE_BITMASK,
>>>
>>> The UVC control is still a boolean.
>>
>> You're saying that, the control size should be 1 because it's right to
>> maintain the boolean type, So, then, the uvc driver dosen't needed to be
>> changed. is it right?
> 
> You still need to change v4l2_type from V4L2_CTRL_TYPE_BOOLEAN to 
> V4L2_CTRL_TYPE_MENU, and add the menu entries. I don't see a need to change 
> anything else.
> 

Ah ok. I I confused a little. Thanks for the good catch.

Together focus name patch, I'll re-send patch.

Regards,
Heungjun Kim


