Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1RFHCud028797
	for <video4linux-list@redhat.com>; Fri, 27 Feb 2009 10:17:12 -0500
Received: from smtp101.biz.mail.re2.yahoo.com (smtp101.biz.mail.re2.yahoo.com
	[68.142.229.215])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n1RFGsmf024655
	for <video4linux-list@redhat.com>; Fri, 27 Feb 2009 10:16:55 -0500
Message-ID: <49A802ED.2060200@embeddedalley.com>
Date: Fri, 27 Feb 2009 18:12:45 +0300
From: Vitaly Wool <vital@embeddedalley.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <49A3A61F.30509@embeddedalley.com>	<20090224234205.7a5ca4ca@pedra.chehab.org>	<49A53CB9.1040109@embeddedalley.com>	<20090225090728.7f2b0673@caramujo.chehab.org>	<49A567D9.80805@embeddedalley.com>	<20090225101812.212fabbe@caramujo.chehab.org>	<49A57BD4.6040209@embeddedalley.com>	<20090225153323.66778ad2@caramujo.chehab.org>	<49A59B31.9080407@embeddedalley.com>
	<20090225204023.16b96fe5@pedra.chehab.org>
In-Reply-To: <20090225204023.16b96fe5@pedra.chehab.org>
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

Hi Mauro,

Mauro Carvalho Chehab wrote:
> On Wed, 25 Feb 2009 22:25:37 +0300
> Vitaly Wool <vital@embeddedalley.com> wrote: 
>   
>> I'm not quite sure I understood. Do I need to add another field to the 
>> board structure and use it where appropriate?
>>     
>
> Yes, that's what I'm meaning.
>   
Ok, I'm working on that. The problem as of now is that it works fine on 
2.6.26 and doesn't work with 2.6.29-rc5.
I'll get back to you when I find out the reason.

Thanks,
   Vitaly

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
