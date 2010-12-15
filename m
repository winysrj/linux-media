Return-path: <mchehab@gaivota>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1716 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab0LOIgE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 03:36:04 -0500
Message-ID: <e64ecf573d54c2876d8a414703b3772a.squirrel@webmail.xs4all.nl>
In-Reply-To: <4D0874F6.1080004@samsung.com>
References: <201012150119.43918.laurent.pinchart@ideasonboard.com>
    <4D0874F6.1080004@samsung.com>
Date: Wed, 15 Dec 2010 09:36:00 +0100
Subject: Re: What if add enumerations at the V4L2_FOCUS_MODE_AUTO?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: riverful.kim@samsung.com
Cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"Sylwester Nawrocki" <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

> Hi Laurent,
>
> 2010-12-15 오전 9:19, Laurent Pinchart 쓴 글:
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

Something I forgot to mention before: new controls should be added at the
end of the control class. These IDs can be used directly in applications,
so if you shift them, then apps will start to fail.

>>>
>>> -#define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+13)
>>> -#define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+14)
>>> +#define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+14)
>>> +#define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+15)
>>>
>>>
>>> The M5MOLS(or other recent camera sensor) can have at least 2 mode
>>> although
>>> in any cases : *MACRO* and *NORMAL* mode. plus, M5MOLS supports
>>> positioning focus mode, AKA. POSITION AF mode.
>>>
>>> The MACRO mode scan short range, and this mode can be used at the
>>> circumstance in the short distance with object and camera lens. So, It
>>> has
>>> fast lens movement, but the command FOCUSING dosen't works well at the
>>> long distance object.
>>>
>>> On the other hand, NORMAL mode can this. As the words, It's general and
>>> normal focus mode. The M5MOLS scan fully in the mode.
>>>
>>> In the Position AF mode, the position(expressed x,y) is given at the
>>> M5MOLS, and then the M5MOLS focus this area. But, the time given the
>>> position, is normally touch the lcd screen at the mobile device, in my
>>> case. If the time is given from button, it's no big problem *when*.
>>> But,
>>> in touch-lcd screen case, the position is read at the touch screen
>>> driver,
>>> before command FOCUS to camera sensor. It's the why I add another
>>> CID(V4L2_CID_FOCUS_POSITION).
>>
>> I'm pretty sure that some devices would require a rectangle instead of
>> coordinates to define the focus point. Even a rectangle might not be
>> enough.
>> It would help if we could get feedback from camera designers here.
>>
>> Hans, should we add a new control type to pass coordinates/rectangles ?
>> :-)
>>
>
> Very glad to be sure that.
>
> As you know, the recent camera sensor embedded in mobile devices has
> evoluted
> rapidly in a decade. It's not digital camera, but it operates like digital
> camera. Actually, the camera sensor module with ISP in the recent mobile
> device
> use the same one in the digital camera. And I can let you know this newer
> control types, like in a uppper FOCUS case.(e.g.,iso, exposure, wb,
> wdr(wide
> dynamic range), effects, the method to get jpeg bulk streams with sync,
> even
> face detections.)
>
> So, I'll make general patch or RFC patch about new control types which is
> needed at
> the the mobile device, based on M5MOLS and some sensors else, for
> generality.
> (considering another ISP like a NEC, Samsung sensor modules. It is
> available for me.)

Good plan.

> After that, I'm glad with being reviewed it to Hans and Laurent.
> (Actually, I don't know who is the maintainer of CID of camera. Let me
> know, plz. :-) )

You have the right people :-)

> If Laurent and Hans agree with that, I'll prepare patch works.
>
> Thanks for reading.
>
> ps. I wanna know where the recent v4l2 control is described, as already
> told
> at the previous my mail.

The latest spec build from the git tree is always available here:

www.xs4all.nl/~hverkuil/spec/media.html

And of course in the media_tree git repository itself.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

