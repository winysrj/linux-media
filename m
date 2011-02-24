Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:27525 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab1BXLE7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 06:04:59 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp2 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LH4005UGC4AMI40@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Feb 2011 20:04:58 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LH40017UC4ATY@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Feb 2011 20:04:58 +0900 (KST)
Date: Thu, 24 Feb 2011 20:04:58 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [RFC PATCH 1/2] v4l2-ctrls: change the boolean type of
 V4L2_CID_FOCUS_AUTO to menu type
In-reply-to: <201102241159.18508.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D663B5A.6080204@samsung.com>
Content-transfer-encoding: 8BIT
References: <4D6636C2.5090600@samsung.com>
 <201102241159.18508.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for reviewing, and I'll send another version including Docbook documents.

Regards,
Heungjun Kim


2011-02-24 오후 7:59, Hans Verkuil 쓴 글:
> On Thursday, February 24, 2011 11:45:22 Kim, HeungJun wrote:
>> For support more modes of autofocus, it changes the type of V4L2_CID_FOCUS_AUTO
>> from boolean to menu. And it includes 4 kinds of enumeration types:
>>
>> V4L2_FOCUS_AUTO, V4L2_FOCUS_MANUAL, V4L2_FOCUS_MACRO, V4L2_FOCUS_CONTINUOUS
>>
>> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/video/v4l2-ctrls.c |   11 ++++++++++-
>>  include/linux/videodev2.h        |    6 ++++++
>>  2 files changed, 16 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
>> index 2412f08..5c48d49 100644
>> --- a/drivers/media/video/v4l2-ctrls.c
>> +++ b/drivers/media/video/v4l2-ctrls.c
>> @@ -197,6 +197,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>  		"Aperture Priority Mode",
>>  		NULL
>>  	};
>> +	static const char * const camera_focus_auto[] = {
>> +		"Auto Mode",
>> +		"Manual Mode",
>> +		"Macro Mode",
>> +		"Continuous Mode",
>> +		NULL
>> +	};
>>  	static const char * const colorfx[] = {
>>  		"None",
>>  		"Black & White",
>> @@ -252,6 +259,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>  		return camera_power_line_frequency;
>>  	case V4L2_CID_EXPOSURE_AUTO:
>>  		return camera_exposure_auto;
>> +	case V4L2_CID_FOCUS_AUTO:
>> +		return camera_focus_auto;
>>  	case V4L2_CID_COLORFX:
>>  		return colorfx;
>>  	case V4L2_CID_TUNE_PREEMPHASIS:
>> @@ -416,7 +425,6 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>>  	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
>>  	case V4L2_CID_MPEG_VIDEO_PULLDOWN:
>>  	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:
>> -	case V4L2_CID_FOCUS_AUTO:
>>  	case V4L2_CID_PRIVACY:
>>  	case V4L2_CID_AUDIO_LIMITER_ENABLED:
>>  	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
>> @@ -450,6 +458,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>>  	case V4L2_CID_MPEG_STREAM_TYPE:
>>  	case V4L2_CID_MPEG_STREAM_VBI_FMT:
>>  	case V4L2_CID_EXPOSURE_AUTO:
>> +	case V4L2_CID_FOCUS_AUTO:
>>  	case V4L2_CID_COLORFX:
>>  	case V4L2_CID_TUNE_PREEMPHASIS:
>>  		*type = V4L2_CTRL_TYPE_MENU;
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index 5122b26..dda3e37 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -1374,6 +1374,12 @@ enum  v4l2_exposure_auto_type {
>>  #define V4L2_CID_FOCUS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+10)
>>  #define V4L2_CID_FOCUS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+11)
>>  #define V4L2_CID_FOCUS_AUTO			(V4L2_CID_CAMERA_CLASS_BASE+12)
>> +enum  v4l2_focus_auto_type {
>> +	V4L2_FOCUS_AUTO = 0,
>> +	V4L2_FOCUS_MANUAL = 1,
> 
> Currently this is a boolean, so 0 means manual and 1 means auto. Let's keep
> that order. So FOCUS_AUTO should be 1 and FOCUS_MANUAL should be 0.
> 
> The documentation of this control must also be updated in the V4L2 DocBook.
> 
> Regards,
> 
> 	Hans
> 
>> +	V4L2_FOCUS_MACRO = 2,
>> +	V4L2_FOCUS_CONTINUOUS = 3
>> +};
>>  
>>  #define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+13)
>>  #define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+14)
>>
> 

