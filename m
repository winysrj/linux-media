Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m711d21X027550
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 21:39:02 -0400
Received: from mta5.srv.hcvlny.cv.net (mta5.srv.hcvlny.cv.net [167.206.4.200])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m711cQ4S005406
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 21:38:47 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K4W00GHZF7WJ4L0@mta5.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Thu, 31 Jul 2008 21:38:20 -0400 (EDT)
Date: Thu, 31 Jul 2008 21:38:19 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080731221619.GA4599@gauss.marywood.edu>
To: Chaogui Zhang <czhang1974@gmail.com>
Message-id: <4892690B.3050902@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20080731221619.GA4599@gauss.marywood.edu>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Wanted 800i QAM tested - please reivew... Was: Re: [PATCH] xc5000.c
 xc_write_reg() wait time
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

Chaogui Zhang wrote:
> This patch fixes the incorrect wait time in xc_write_reg(). Before the
> patch, my Pinnacle PCTV HD 800i cannot tune to any QAM channels. After
> the patch, it found all the channels without problems.
> 
> This was previously submitted back in January, as part of a much
> bigger patch involving other stuff. The other parts involve hybrid tuner 
> instance handling, and some code clean up. The tuner instance handling
> part is obsolete now since Mike Krufky's tuner refactoring code does
> precisely that and in a more efficient way, even though the xc5000 tuner
> code has not been modified to take advantage of that yet.
> 
> Just for reference, the previous patch in the following thread:
> 
> http://www.linuxtv.org/pipermail/linux-dvb/2008-January/023392.html
> 
> --
> 
> Signed-off-by: Chaogui Zhang <czhang1974@gmail.com>
> 
> diff -r 55e8c99c8aa8 linux/drivers/media/common/tuners/xc5000.c
> --- a/linux/drivers/media/common/tuners/xc5000.c	Wed Jul 30 07:18:13 2008 -0300
> +++ b/linux/drivers/media/common/tuners/xc5000.c	Thu Jul 31 17:43:31 2008 -0400
> @@ -250,7 +250,7 @@
>  						/* busy flag cleared */
>  					break;
>  					} else {
> -						xc_wait(100); /* wait 5 ms */
> +						xc_wait(5); /* wait 5 ms */
>  						WatchDogTimer--;
>  					}
>  				}

During development, using a remote users dev system the 100 value works 
reliably on his 800i for QAM, it also works very reliably on my QAM / 
ATSC systems. I'm not ware of any QAM issues across multiple vendors 
products with the 100 value.

I'm pretty skeptical about this creating QAM issues.

Does anyone else here have an 800i with QAM issues? (I'm changing the 
subject thread to attract other users).

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
