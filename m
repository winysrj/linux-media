Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:57492 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab1BYMY2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 07:24:28 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LH600DHIAGQVE70@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Feb 2011 21:24:26 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LH600EF0AGQJR@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Feb 2011 21:24:26 +0900 (KST)
Date: Fri, 25 Feb 2011 21:24:26 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [RFC PATCH v2 1/3] v4l2-ctrls: change the boolean type of
 V4L2_CID_FOCUS_AUTO to menu type
In-reply-to: <201102251128.32850.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D679F7A.1060605@samsung.com>
Content-transfer-encoding: 8BIT
References: <4D674A67.3000504@samsung.com>
 <201102251021.59847.laurent.pinchart@ideasonboard.com>
 <201102251054.02328.hverkuil@xs4all.nl>
 <201102251128.32850.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011-02-25 오후 7:28, Laurent Pinchart 쓴 글:
> On Friday 25 February 2011 10:54:02 Hans Verkuil wrote:
>> On Friday, February 25, 2011 10:21:59 Laurent Pinchart wrote:
>>> On Friday 25 February 2011 07:21:27 Kim, HeungJun wrote:
>>>> Support more modes of autofocus, it changes the type of
>>>> V4L2_CID_FOCUS_AUTO from boolean to menu. And it includes 4 kinds of
>>>> enumeration types:
>>>>
>>>> V4L2_FOCUS_AUTO, V4L2_FOCUS_MANUAL, V4L2_FOCUS_MACRO,
>>>> V4L2_FOCUS_CONTINUOUS
>>>>
>>>> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>
>>>>  drivers/media/video/v4l2-ctrls.c |   11 ++++++++++-
>>>>  include/linux/videodev2.h        |    6 ++++++
>>>>  2 files changed, 16 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/media/video/v4l2-ctrls.c
>>>> b/drivers/media/video/v4l2-ctrls.c index 2412f08..0b1cce0 100644
>>>> --- a/drivers/media/video/v4l2-ctrls.c
>>>> +++ b/drivers/media/video/v4l2-ctrls.c
>>>> @@ -197,6 +197,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>>>
>>>>  		"Aperture Priority Mode",
>>>>  		NULL
>>>>  	
>>>>  	};
>>>>
>>>> +	static const char * const camera_focus_auto[] = {
>>>> +		"Manual Mode",
>>>> +		"Auto Mode",
>>>> +		"Macro Mode",
>>>> +		"Continuous Mode",
>>>
>>> This might be nit-picking, but maybe the menu entries should be named
>>> "Manual Focus", "Auto Focus", "Macro Focus" and "Continuous Auto Focus".
>>> Hans ?
>>
>> Yes, that's better. Although I believe that it should be 'Macro Auto
>> Focus', right?
> 
> I suppose so. Heungjun could confirm that.
> 
>> But if we change this for 'focus' then we need to do the same for the auto
>> exposure menu which currently also uses the term 'Mode'.
>>
>> Do you agree?
> 
> Auto Mode and Manual Mode could be renamed to Auto Exposure and Manual 
> Exposure, but Shutter Priority Exposure and Aperture Priority Exposure don't 
> sound right.
> 

I guess the reason why "Shutter Priority Exposure" dosen't always imply auto iris
exposure, but the current name "Shutter Prority Mode" can be imagined including
auto iris. The contrary case seems the same.

Although tt's the different story, the exposure be made up 3 factor
(shutter speed/aperture/iso), but there is not the enum name matching iso factor now.
So, it looks better that the name should be changed all later.

But, it looks good for me the focus name is below:
"Manual Focus"
"Normal Auto Focus"
"Macro Auto Focus"
"Continuous Auto Focus"

If any ideas, I'll re-send the patch series.


Regards,
Heungjun Kim



