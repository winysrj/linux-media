Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1PH3Jll011353
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 12:03:19 -0500
Received: from smtp110.biz.mail.re2.yahoo.com (smtp110.biz.mail.re2.yahoo.com
	[206.190.53.9])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n1PH33Ax003645
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 12:03:03 -0500
Message-ID: <49A578B0.2000108@embeddedalley.com>
Date: Wed, 25 Feb 2009 19:58:24 +0300
From: Vitaly Wool <vital@embeddedalley.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <49A3A61F.30509@embeddedalley.com>	<20090224234205.7a5ca4ca@pedra.chehab.org>	<49A53CB9.1040109@embeddedalley.com>	<20090225090728.7f2b0673@caramujo.chehab.org>	<49A567D9.80805@embeddedalley.com>
	<20090225101812.212fabbe@caramujo.chehab.org>
In-Reply-To: <20090225101812.212fabbe@caramujo.chehab.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, em28xx@mcentral.de
Subject: Re: em28xx: Compro VideoMate For You sound problems
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

Mauro Carvalho Chehab wrote:
> The actual value for amux will depend on your mixer chip, if there is any.
> Could you provide your full em28xx log? Let's see if it will detect EM202 or
> another AC97 chip.
>
>   

Well that's what it says:
[12749.748715] em28xx #0: No AC97 audio processor

Thanks,
   Vitaly

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
