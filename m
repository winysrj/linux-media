Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59608 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab1CPAOC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 20:14:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: riverful.kim@samsung.com
Subject: Re: the focus terms or sequences
Date: Wed, 16 Mar 2011 01:14:03 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
References: <4D7DBD69.2000507@samsung.com>
In-Reply-To: <4D7DBD69.2000507@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103160114.03677.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi HeungJun,

On Monday 14 March 2011 08:02:01 Kim, HeungJun wrote:
> Hi Laurent,
> 
> I heard of that there was a chance between you and Sylwester telling about
> the menu entries focus, and so after that, probably this menu style of the
> patch I sent, need to be more upgraded. So, can you tell me the kind or
> sequence of the UVC device breifly?
> 
> I guess the word *AUTO* at the UVC device means doing focus continuously,
> not once or one time.

That's correct. In the UVC context, auto focus means CAF and manual focus 
means... well, manual focus :-)

> But, at the sensors I used the *AUTO* focus means doing focus once, on the
> other hand *CONTINUOUS* means doing continuously. So, we need to be clear
> terms about focus.
> 
> At the sensor I used, the focus needs 3 kinds of commands:
> 1) setting mode
> 
>   : it makes the lens initial position for each AF(Normal, Continuous,
>   : Night mode Focus, etc),
> 
>     and set the AF status Idle.
> 2) execute AF
> 
>   : doing the move of the lens
> 
> 3) read AF status
> 
>   : checking the lens status(Focus failed, Focus success, Idle, Busy)
> 
>     and do the proper jobs.
> 
> I don't know uvc case well, so, If you share about this, it can be help.

What bothers me with your auto-focus implementation is that the user might 
want to perform auto-focus several times. Let's imagine this use case:

1. The user points the camera (webcam, cellphone camera, digital camera, it 
doesn't matter) at an object.

2. The user presses a button to perform singleshot auto-focus (it can be a 
physical button or a button on the camera screen, once again it doesn't 
matter).

3. The application sets the focus control to AUTO.

4. The driver and device perform auto-focus once. The lens is moved so that 
the object is in focus.

5. The user points the camera at another object.

6. The user presses a button to perform singleshot auto-focus.

7. The applications sets the focus control to AUTO. As the focus control value 
was already AUTO, nothing is done.

This is clearly broken. That's why we need a V4L2 button control in addition 
to the menu control.

-- 
Regards,

Laurent Pinchart
