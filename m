Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:18309 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab1BYK0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 05:26:53 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LH600L0U50SUGD0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Feb 2011 19:26:52 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LH600BJN50R2L@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Feb 2011 19:26:52 +0900 (KST)
Date: Fri, 25 Feb 2011 19:26:51 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [RFC PATCH v2 1/3] v4l2-ctrls: change the boolean type of
 V4L2_CID_FOCUS_AUTO to menu type
In-reply-to: <201102251054.02328.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D6783EB.5050302@samsung.com>
Content-transfer-encoding: 8BIT
References: <4D674A67.3000504@samsung.com>
 <201102251021.59847.laurent.pinchart@ideasonboard.com>
 <201102251054.02328.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans, and Laurent,

2011-02-25 오후 6:54, Hans Verkuil 쓴 글:
> On Friday, February 25, 2011 10:21:59 Laurent Pinchart wrote:
>> On Friday 25 February 2011 07:21:27 Kim, HeungJun wrote:
>>> Support more modes of autofocus, it changes the type of V4L2_CID_FOCUS_AUTO
>>> from boolean to menu. And it includes 4 kinds of enumeration types:
>>>
>>> V4L2_FOCUS_AUTO, V4L2_FOCUS_MANUAL, V4L2_FOCUS_MACRO, V4L2_FOCUS_CONTINUOUS
>>>
>>> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  drivers/media/video/v4l2-ctrls.c |   11 ++++++++++-
>>>  include/linux/videodev2.h        |    6 ++++++
>>>  2 files changed, 16 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/media/video/v4l2-ctrls.c
>>> b/drivers/media/video/v4l2-ctrls.c index 2412f08..0b1cce0 100644
>>> --- a/drivers/media/video/v4l2-ctrls.c
>>> +++ b/drivers/media/video/v4l2-ctrls.c
>>> @@ -197,6 +197,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>>  		"Aperture Priority Mode",
>>>  		NULL
>>>  	};
>>> +	static const char * const camera_focus_auto[] = {
>>> +		"Manual Mode",
>>> +		"Auto Mode",
>>> +		"Macro Mode",
>>> +		"Continuous Mode",
>>
>> This might be nit-picking, but maybe the menu entries should be named "Manual 
>> Focus", "Auto Focus", "Macro Focus" and "Continuous Auto Focus". Hans ?
> 
> Yes, that's better. Although I believe that it should be 'Macro Auto Focus',
> right?
> 
> But if we change this for 'focus' then we need to do the same for the auto
> exposure menu which currently also uses the term 'Mode'.
> 
> Do you agree?

Although listenning Laurent's opinion first, if my opinion is asked, I agree
using term 'Focus', and agree using term 'Exposure' (is it right??) at the
exposure auto control, too.

If the name is decided, and came to the conclusion, I would modify to maintain
the term 'Focus' in the focus control name.

Regards,
Heungjun Kim
