Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9VIjuVY006096
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 14:45:56 -0400
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9VIjeaq012741
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 14:45:40 -0400
To: fpantaleao@mobisensesystems.com
References: <20081031160520.2cc7whghs0gs8osk@webmail.hebergement.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 31 Oct 2008 19:45:38 +0100
In-Reply-To: <20081031160520.2cc7whghs0gs8osk@webmail.hebergement.com>
	(fpantaleao@mobisensesystems.com's message of "Fri\,
	31 Oct 2008 16\:05\:20 +0100")
Message-ID: <87vdv8mwml.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: About CITOR register value for pxa_camera
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

fpantaleao@mobisensesystems.com writes:

> Hi all,
>
> While testing, I think I have found one reason why overruns occur with
> pxa_camera.
> I propose to set CITOR to a non-null value.
Yes, seconded.

> I would appreciate any comment about this.
Well, at first sight I would advice to test some corner case to see if DMA
trailing bytes are handled well. I know this can be a pain, but you seem to be
testing thouroughly ..

So, if your configuration/sensor is able to, try some funny resolution like
"1619 x 1", and then "67 x 1", and see what happens. If you don't have any
capture issue, you're done, and post a patch (only CITOR or CITOR + trailling
bytes handling).

Have fun.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
