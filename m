Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1O7rq2a000475
	for <video4linux-list@redhat.com>; Tue, 24 Feb 2009 02:53:52 -0500
Received: from smtp109.biz.mail.re2.yahoo.com (smtp109.biz.mail.re2.yahoo.com
	[206.190.53.8])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n1O7rbiS008892
	for <video4linux-list@redhat.com>; Tue, 24 Feb 2009 02:53:38 -0500
Message-ID: <49A3A61F.30509@embeddedalley.com>
Date: Tue, 24 Feb 2009 10:47:43 +0300
From: Vitaly Wool <vital@embeddedalley.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: em28xx@mcentral.de
Subject: em28xx: Compro VideoMate For You sound problems
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

about half a year ago I posted the patch that basically enabled Compro 
VideoMate For You USB TV box support.
The main problem is I couldn't get the sound working. I was poking 
around that for some time then but gave up soon. Now I spent some time 
debugging the problem without any real success, tried the new 
(alternative) version of the em28xx driver suite from Markus and had no 
luck with it either.

So I kind of decomposed the box and found out the audio decoder chip 
used there was Philips TDA9874A. As far as I can see, it's not supported 
within the em28xx suite although it is for other TV tuner drivers. Could 
anyone please give me some guidance on how to add that to em28xx to 
shorten my way to getting the sound working on that good ol' box?

Thanks,
   Vitaly

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
