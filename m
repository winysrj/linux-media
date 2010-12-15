Return-path: <mchehab@gaivota>
Received: from mailout1.samsung.com ([203.254.224.24]:47460 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0LOIOS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 03:14:18 -0500
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
Received: from epmmp2 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LDG0076VMVS6UD0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Dec 2010 17:14:17 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LDG00GMCMVTOV@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Dec 2010 17:14:17 +0900 (KST)
Date: Wed, 15 Dec 2010 17:14:16 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: What if add enumerations at the V4L2_FOCUS_MODE_AUTO?
In-reply-to: <201012150857.29099.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org
Reply-to: riverful.kim@samsung.com
Message-id: <4D0878D8.9010803@samsung.com>
Content-transfer-encoding: 8BIT
References: <201012150119.43918.laurent.pinchart@ideasonboard.com>
 <201012150857.29099.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

2010-12-15 오후 4:57, Hans Verkuil 쓴 글:
> On Wednesday, December 15, 2010 01:19:43 Laurent Pinchart wrote:
>> Hi,
>>
>> (CC'ing linux-media this time, please discard the previous mail)
>>
>> On Tuesday 14 December 2010 12:27:32 Kim, HeungJun wrote:
>>> Hi Laurent and Hans,
>>>
>>> I am working on V4L2 subdev for M5MOLS by Fujitsu.
>>> and I wanna listen your comments about Auto Focus mode of my ideas.
>>> the details is in the following link discussed at the past.
>>> Although the situation(adding the more various functions at the M5MOLS
>>> or any other MEGA camera sensor, I worked.)is changed,
>>> so I wanna continue this threads for now.
>>>
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg03543.html
>>>
>>> First of all, the at least two more mode of auto-focus exists in the
>>> M5MOLS camera sensor. So, considering defined V4L2 controls and the
>>> controls in the M5MOLS, I suggest like this:
>>>
>>> +enum  v4l2_focus_auto_type {
>>> +	V4L2_FOCUS_AUTO_NORMAL = 0,
>>> +	V4L2_FOCUS_AUTO_MACRO = 1,
>>> +	V4L2_FOCUS_AUTO_POSITION = 2,
>>> +};
>>> +#define V4L2_CID_FOCUS_POSITION			(V4L2_CID_CAMERA_CLASS_BASE+13)
>>>
>>> -#define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+13)
>>> -#define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+14)
>>> +#define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+14)
>>> +#define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+15)
>>>
>>>
>>> The M5MOLS(or other recent camera sensor) can have at least 2 mode although
>>> in any cases : *MACRO* and *NORMAL* mode. plus, M5MOLS supports
>>> positioning focus mode, AKA. POSITION AF mode.
>>>
>>> The MACRO mode scan short range, and this mode can be used at the
>>> circumstance in the short distance with object and camera lens. So, It has
>>> fast lens movement, but the command FOCUSING dosen't works well at the
>>> long distance object.
>>>
>>> On the other hand, NORMAL mode can this. As the words, It's general and
>>> normal focus mode. The M5MOLS scan fully in the mode.
>>>
>>> In the Position AF mode, the position(expressed x,y) is given at the
>>> M5MOLS, and then the M5MOLS focus this area. But, the time given the
>>> position, is normally touch the lcd screen at the mobile device, in my
>>> case. If the time is given from button, it's no big problem *when*. But,
>>> in touch-lcd screen case, the position is read at the touch screen driver,
>>> before command FOCUS to camera sensor. It's the why I add another
>>> CID(V4L2_CID_FOCUS_POSITION).
>>
>> I'm pretty sure that some devices would require a rectangle instead of 
>> coordinates to define the focus point. Even a rectangle might not be enough. 
>> It would help if we could get feedback from camera designers here.
>>
>> Hans, should we add a new control type to pass coordinates/rectangles ? :-)
> 
> It's a bit tricky actually since QUERYCTRL can return only one set of min/max
> values. For coordinates/rectangles we need two sets (horizontal and vertical).
> 
> And I think it is important to know the min/max values.
> 
> Regards,
> 
> 	Hans
> 

I agree with that.

So, IMHO, my real ideas is that:

1. It aparts two cid for focus POSITIONING.
   (e.g., V4L2_CID_FOCUS_POSX, V4L2_CID_FOCUS_POSY. )
2. The min/max is changed, responsible for current camera sensor operating mode & size.

The rectangle case is possible for focus mode. But, It can be dealt with this in
the subdev driver, although the camera sensor support rectangle focus.

Thanks.

Regards,
HeungJun Kim
