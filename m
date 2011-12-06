Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28619 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1LFRK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 12:10:27 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LVS00DCLL1D3C80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Dec 2011 17:10:25 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVS00F8RL1DOC@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Dec 2011 17:10:25 +0000 (GMT)
Date: Tue, 06 Dec 2011 18:10:24 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC/PATCH 2/5] uvc: Adapt the driver to new type of
 V4L2_CID_FOCUS_AUTO control
In-reply-to: <201112061326.57238.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4EDE4C80.8090106@samsung.com>
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
 <1323011776-15967-3-git-send-email-snjw23@gmail.com>
 <201112061326.57238.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/06/2011 01:26 PM, Laurent Pinchart wrote:
> On Sunday 04 December 2011 16:16:13 Sylwester Nawrocki wrote:
>> From: Heungjun Kim <riverful.kim@samsung.com>
>>
>> The V4L2_CID_FOCUS_AUTO control has been converted from boolean type,
>> where control's value 0 and 1 were corresponding to manual and automatic
>> focus respectively, to menu type with following menu items:
>>   0 - V4L2_FOCUS_MANUAL,
>>   1 - V4L2_FOCUS_AUTO,
>>   2 - V4L2_FOCUS_AUTO_MACRO,
>>   3 - V4L2_FOCUS_AUTO_CONTINUOUS.
>>
>> According to this change the uvc control mappings are modified to retain
>> original sematics, where 0 corresponds to manual and 1 to auto focus.
> 
> UVC auto-focus works in continuous mode, not single-shot mode. As the existing

Hmm, I suspected that.

> V4L2_CID_FOCUS_AUTO uses 0 to mean manual focus and 1 to mean continuous auto-
> focus, shouldn't this patch set define the following values instead ?
> 
>    0 - V4L2_FOCUS_MANUAL
>    1 - V4L2_FOCUS_AUTO
>    2 - V4L2_FOCUS_AUTO_MACRO
>    3 - V4L2_FOCUS_AUTO_SINGLE_SHOT

It's not that bad, at least we would not have changed the existing ABI.

It depends how other focus modes are defined, e.g. V4L2_FOCUS_AUTO_MACRO.
There is also an auto focus driven by face detection module output.

The question would be whether we want to append _SINGLE_SHOT or _CONTINUOUS
to the names. And if most of the focus modes are single-shot we will
probably need a common "do auto-focus" control for them.

What do you think about such assignment:

   0 - V4L2_FOCUS_MANUAL,
   1 - V4L2_FOCUS_AUTO_CONTINUOUS,
   2 - V4L2_FOCUS_AUTO,
   3 - V4L2_FOCUS_AUTO_MACRO,

?

I'm not 100% sure right now, but the macro and "face detection"
are rather "single-shot". Single-shot focus might be more common. Perhaps
someone else can put more light on that :-)

Using a "single-shot notation" we might have something like:

   0 - V4L2_FOCUS_MANUAL,
   1 - V4L2_FOCUS_AUTO,
   2 - V4L2_FOCUS_AUTO_SINGLE_SHOT,
   3 - V4L2_FOCUS_AUTO_MACRO_SINGLE_SHOT,
   3 - V4L2_FOCUS_AUTO_FACE_DETECTION_SINGLE_SHOT,

I'm not sure if this convention is the best one.

Alternatively we could define a "do-focus" control for each mode,
but then these controls have to be properly coordinated, for exclusive
operation.

> 
> V4L2_FOCUS_AUTO_SINGLE_SHOT could also be named V4L2_FOCUS_SINGLE_SHOT.
> 
>> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>
>> ---
>> The V4L2_CID_FOCUS_AUTO control in V4L2_FOCUS_AUTO mode does only
>> a one-shot auto focus, when switched from V4L2_FOCUS_MANUAL.
>> It might be worth to implement also the V4L2_CID_DO_AUTO_FOCUS button
>> control in uvc, however I didn't take time yet to better understand
>> the driver and add this. I also don't have any uvc hardware to test
>> this patch so it's just compile tested.
>> ---
>>  drivers/media/video/uvc/uvc_ctrl.c |    9 ++++++++-
>>  1 files changed, 8 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
>> b/drivers/media/video/uvc/uvc_ctrl.c index 254d326..6860ca1 100644
>> --- a/drivers/media/video/uvc/uvc_ctrl.c
>> +++ b/drivers/media/video/uvc/uvc_ctrl.c
>> @@ -365,6 +365,11 @@ static struct uvc_menu_info exposure_auto_controls[] =
>> { { 8, "Aperture Priority Mode" },
>>  };
>>
>> +static struct uvc_menu_info focus_auto_controls[] = {
>> +	{ 0, "Manual Mode" },
>> +	{ 1, "Auto Mode" },

Do you think it could be better to change this to:

+	{ 0, "Manual Focus" },
+	{ 1, "Continuous Auto Focus" },

?

--

Regards,
Sylwester
