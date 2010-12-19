Return-path: <mchehab@gaivota>
Received: from banach.math.auburn.edu ([131.204.45.3]:42617 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab0LSUPe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 15:15:34 -0500
Date: Sun, 19 Dec 2010 14:51:30 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Andy Walls <awalls@md.metrocast.net>
cc: Paulo Assis <pj.assis@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Power frequency detection.
In-Reply-To: <73wo0g3yy30clob2isac30vm.1292782894810@email.android.com>
Message-ID: <alpine.LNX.2.00.1012191423030.23950@banach.math.auburn.edu>
References: <73wo0g3yy30clob2isac30vm.1292782894810@email.android.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>



On Sun, 19 Dec 2010, Andy Walls wrote:

> Theodore,
> 
> Aside from detect measurment of the power line, isn't a camera the best sort of sensor for this measurment anyway?
> 
> Just compute the average image luminosity over several frames and look for (10 Hz ?) periodic variation (beats), indicating a mismatch.
> 
> Sure you could just ask the user, but where's the challenge in that. ;)
> 
> Regards,
> Andy

Well, if it is "established policy" to go with doing this as a control, I 
guess we can just go ahead instead of doing something fancy.

But it is nice to hear from you. Here is why.

The camera in question is another jeilinj camera. Its OEM software for 
that other OS does present the option to choose line frequency. It also 
asks for the user to specify an image quality index. I can not recall that 
the software I got with my camera did any such thing. As I recall, it 
merely let the camera to start streaming. Bur at the moment I have no idea 
where I put that old CD.

So, while I have you on the line, do you recall whether or not the OEM 
software for the camera you bought for your daughter present any such 
setup options?


The new camera may be different in some particulars from the ones we have. 
It does have a new Product number, so apparently Jeilin might not have 
thought it is identical to the other ones. It does use a slightly 
different initialization sequence. Therefore, the quick-and-dirty way to 
support it would be just to introduce a patch which has switch statements 
or conditionals all over the place, and just to support whatever the 
camera was observed to do. However, that is obviously dirty as well as 
quick.

While playing around with the code a bit, I have managed to make my 
old camera work with essentially the same init sequence that the new 
one is using. If this can be done right, it would clear a lot of crud out 
of the driver code. Unfortunately, doing it right involves testing...

Finally, one concern that I have in the back of my mind is the question of 
control settings for a camera which streams in bulk mode and requires the 
setup of a workqueue. The owner of the camera says that he has 
"encountered no problems" with running the two controls mentioned above. 
Clearly, that is not a complete answer which overcomes all possible 
objections. Rather, things are OK if and only if we can ensure that these 
controls can be run only while the workqueue that does the streaming is 
inactive. Somehow, I suspect that the fact that a sensible user would only 
run such commands at camera setup is an insufficient guarantee that no 
problems will ever be encountered.

So, as I said, the question of interaction of a control and a workqueue is 
another problem interesting little problem. Your thoughts on this 
interesting little problem would be appreciated.

As I said, Merry Christmas :-)

Theodore Kilgore
