Return-path: <mchehab@pedra>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42076 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab1CPPRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 11:17:41 -0400
Received: by gwaa18 with SMTP id a18so693036gwa.19
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 08:17:40 -0700 (PDT)
Subject: Re: the focus terms or sequences
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=euc-kr
From: Kim HeungJun <riverful@gmail.com>
In-Reply-To: <201103161515.39134.laurent.pinchart@ideasonboard.com>
Date: Thu, 17 Mar 2011 00:17:30 +0900
Cc: Kim HeungJun <riverful@gmail.com>, riverful.kim@samsung.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <8C6FF5D6-7DC2-44D5-8A5C-E9F5EBB530F7@gmail.com>
References: <4D7DBD69.2000507@samsung.com> <201103160114.03677.laurent.pinchart@ideasonboard.com> <4D804183.8020505@samsung.com> <201103161515.39134.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


2011. 3. 16., 오후 11:15, Laurent Pinchart 작성:

> Hi,
> 
> On Wednesday 16 March 2011 05:50:11 Kim, HeungJun wrote:
>> 2011-03-16 오전 9:14, Laurent Pinchart 쓴 글:
> 
> [snip]
> 
>>> What bothers me with your auto-focus implementation is that the user
>>> might want to perform auto-focus several times. Let's imagine this use
>>> case:
>>> 
>>> 1. The user points the camera (webcam, cellphone camera, digital camera,
>>> it doesn't matter) at an object.
>>> 
>>> 2. The user presses a button to perform singleshot auto-focus (it can be
>>> a physical button or a button on the camera screen, once again it
>>> doesn't matter).
>>> 
>>> 3. The application sets the focus control to AUTO.
>>> 
>>> 4. The driver and device perform auto-focus once. The lens is moved so
>>> that the object is in focus.
>>> 
>>> 5. The user points the camera at another object.
>>> 
>>> 6. The user presses a button to perform singleshot auto-focus.
>>> 
>>> 7. The applications sets the focus control to AUTO. As the focus control
>>> value was already AUTO, nothing is done.
>>> 
>>> This is clearly broken. That's why we need a V4L2 button control in
>>> addition to the menu control.
>> 
>> Yes. Youre'rignt. The menu control dosen't called one more with the same
>> value. It's now worked I know. But, the reason why I choose menu type for
>> focus, is because the menu type can let the user-application know how many
>> kinds of focus this sensor have & support, using querymenu. The only way
>> letting know, is currently the menu type.
>> 
>> On the other hand, not-working twice or more executions is handled by
>> user-application. The user-application want twice auto focus, it calls
>> AUTO-Manual-(or any other control value)-and AUTO once again. It's wierd,
>> but It can satisfy application and drivers.
>> 
>> And, but it might be irrelevant, the user-application(or upper layer
>> platform) can determine how to draw & arrange the UI objects after it
>> knows the kinds of focus method at last.
>> 
>> It may be a time to need another type of control. And such control should
>> satisfy these: 1. letting the user-application know how many kinds in the
>> controls(like a querymenu) 2. being available to be called one more.
>> 
>> How about your opinion?
> 
> I think we need a menu control (to select the focus type) and a button control 
> (to run singleshot auto-focus). When the menu control is in auto-focus mode, 
> setting the button control will run the auto-focus algorithm once.
Ah. it's very reasonable. When the focus mode keeps the menu type, and doing
focus is button type, even if another new mode is needed to insert, we can add
easily. I agree with this. 

But, the drivers using focus like uvc, should be changed. And we should probably
consider the cluster between focus mode and execution. is it right? 
 
> 
> Is the macro focus mode a singleshot focus or a continuous auto-focus ?
Of course. yes.

I'll make another patch about this, and could you look around this?  

Thanks,
Heungjun Kim