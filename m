Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:20370 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab1CPEuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 00:50:13 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp1 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LI4000C8W3NSZ90@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Mar 2011 13:50:11 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LI400ABQW3NVD@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Mar 2011 13:50:11 +0900 (KST)
Date: Wed, 16 Mar 2011 13:50:11 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: the focus terms or sequences
In-reply-to: <201103160114.03677.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D804183.8020505@samsung.com>
Content-transfer-encoding: 8BIT
References: <4D7DBD69.2000507@samsung.com>
 <201103160114.03677.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

First, I hope to be good at the warsaw meeting. :)

2011-03-16 오전 9:14, Laurent Pinchart 쓴 글:
> Hi HeungJun,
> 
> On Monday 14 March 2011 08:02:01 Kim, HeungJun wrote:
>> Hi Laurent,
>>
>> I heard of that there was a chance between you and Sylwester telling about
>> the menu entries focus, and so after that, probably this menu style of the
>> patch I sent, need to be more upgraded. So, can you tell me the kind or
>> sequence of the UVC device breifly?
>>
>> I guess the word *AUTO* at the UVC device means doing focus continuously,
>> not once or one time.
> 
> That's correct. In the UVC context, auto focus means CAF and manual focus 
> means... well, manual focus :-)
> 
>> But, at the sensors I used the *AUTO* focus means doing focus once, on the
>> other hand *CONTINUOUS* means doing continuously. So, we need to be clear
>> terms about focus.
>>
>> At the sensor I used, the focus needs 3 kinds of commands:
>> 1) setting mode
>>
>>   : it makes the lens initial position for each AF(Normal, Continuous,
>>   : Night mode Focus, etc),
>>
>>     and set the AF status Idle.
>> 2) execute AF
>>
>>   : doing the move of the lens
>>
>> 3) read AF status
>>
>>   : checking the lens status(Focus failed, Focus success, Idle, Busy)
>>
>>     and do the proper jobs.
>>
>> I don't know uvc case well, so, If you share about this, it can be help.
> 
> What bothers me with your auto-focus implementation is that the user might 
> want to perform auto-focus several times. Let's imagine this use case:
> 
> 1. The user points the camera (webcam, cellphone camera, digital camera, it 
> doesn't matter) at an object.
> 
> 2. The user presses a button to perform singleshot auto-focus (it can be a 
> physical button or a button on the camera screen, once again it doesn't 
> matter).
> 
> 3. The application sets the focus control to AUTO.
> 
> 4. The driver and device perform auto-focus once. The lens is moved so that 
> the object is in focus.
> 
> 5. The user points the camera at another object.
> 
> 6. The user presses a button to perform singleshot auto-focus.
> 
> 7. The applications sets the focus control to AUTO. As the focus control value 
> was already AUTO, nothing is done.
> 
> This is clearly broken. That's why we need a V4L2 button control in addition 
> to the menu control.
> 
Yes. Youre'rignt. The menu control dosen't called one more with the same value.
It's now worked I know. But, the reason why I choose menu type for focus,
is because the menu type can let the user-application know how many kinds of
focus this sensor have & support, using querymenu. The only way letting know,
is currently the menu type.

On the other hand, not-working twice or more executions is handled by user-application.
The user-application want twice auto focus, it calls AUTO-Manual-(or any other control
value)-and AUTO once again. It's wierd, but It can satisfy application and drivers.

And, but it might be irrelevant, the user-application(or upper layer platform) can
determine how to draw & arrange the UI objects after it knows the kinds of focus
method at last.

It may be a time to need another type of control. And such control should satisfy these:
1. letting the user-application know how many kinds in the controls(like a querymenu)
2. being available to be called one more.

How about your opinion?

Regards,
Heungjun Kim
