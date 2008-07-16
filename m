Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6GD0QmF004173
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 09:00:26 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6GD0GYx013705
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 09:00:16 -0400
Message-ID: <487DF0D8.5070102@linuxtv.org>
Date: Wed, 16 Jul 2008 09:00:08 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Anthony Edwards <anthony@yoyo.org>
References: <20080716125556.GA9609@yoyo.org>
In-Reply-To: <20080716125556.GA9609@yoyo.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: smscoreapi.c:689: error: 'uintptr_t' undeclared
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

Anthony Edwards wrote:
> This appears to be an issue affecting a number of users, for example:
> 
> http://forum.linuxmce.org/index.php?action=profile;u=41878;sa=showPosts
> 
> I have experienced it too today after attempting to recompile drivers
> for my Hauppauge Nova-T USB TV tuner following an Ubuntu kernel update.
> 
> After obtaining the latest source code using hg clone, I have found
> that it will not successfully compile.  I am seeing the same make
> errors as the poster in the posting referenced above.
> 
> Unfortunately, I lack the necessary programming knowledge to hack the
> source code in order to make it work.
> 
> Is a fix in the pipeline?
> 

The fix is here -- please feel free to test it:

http://linuxtv.org/hg/~mkrufky/sms1xxx

I sent a pull request to Mauro a few days ago -- I don't know why it has not been merged yet.

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
