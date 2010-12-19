Return-path: <mchehab@gaivota>
Received: from honeysuckle.london.02.net ([87.194.255.144]:50592 "EHLO
	honeysuckle.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab0LSXlq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 18:41:46 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: Power frequency detection.
Date: Sun, 19 Dec 2010 23:32:37 +0000
Cc: Andy Walls <awalls@md.metrocast.net>,
	Paulo Assis <pj.assis@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <73wo0g3yy30clob2isac30vm.1292782894810@email.android.com> <alpine.LNX.2.00.1012191423030.23950@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1012191423030.23950@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012192332.38060.linux@baker-net.org.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sunday 19 Dec 2010, Theodore Kilgore wrote:
> Finally, one concern that I have in the back of my mind is the question of 
> control settings for a camera which streams in bulk mode and requires the 
> setup of a workqueue. The owner of the camera says that he has 
> "encountered no problems" with running the two controls mentioned above. 
> Clearly, that is not a complete answer which overcomes all possible 
> objections. Rather, things are OK if and only if we can ensure that these 
> controls can be run only while the workqueue that does the streaming is 
> inactive. Somehow, I suspect that the fact that a sensible user would only 
> run such commands at camera setup is an insufficient guarantee that no 
> problems will ever be encountered.
> 
> So, as I said, the question of interaction of a control and a workqueue is 
> another problem interesting little problem. Your thoughts on this 
> interesting little problem would be appreciated.

I don't think you can assume a user won't try to adjust such controls while 
streaming - if I had one I'd certainly want to try swapping the control while 
streaming to see if I could see any affect on the output. Even though sq905.c 
doesn't have any controls on the camera it still ended up needing the locking 
that would make this safe. See the header comment on sq905_dostream

Adam
