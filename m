Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2QG9XeO002507
	for <video4linux-list@redhat.com>; Thu, 26 Mar 2009 12:09:34 -0400
Received: from bbrack.org (bbrack.org [66.126.51.1])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2QG9Eov013037
	for <video4linux-list@redhat.com>; Thu, 26 Mar 2009 12:09:15 -0400
Message-ID: <a7825f5dc7304c415fde9d87f6d22189.squirrel@delightful.com.hk>
In-Reply-To: <49C909C8.8050107@migmasys.com>
References: <49C909C8.8050107@migmasys.com>
Date: Thu, 26 Mar 2009 09:09:10 -0700 (PDT)
From: "William M. Brack" <wbrack@mmm.com.hk>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Ming Liu <mliu@migmasys.com>
Subject: Re: strange problem with KMC-4400R
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

Hi Ming,

Ming Liu wrote:
> Hi,
>
> I am working on KMC-4400R card. I tried to write a program to use two
> channels from the card by following the example program of V4l2.
> However, I met a very strange problem.
>
> When I kept capturing image, there were several lines following the
> moving objects like a ghost (sometimes more than one ghost) on the
> collected image. I can not figure out what causes this problem and how
> to fix it. The standard xawtv does not have this problem when only one
> channel is displayed.
>
> Any comments will be helpful and many thanks in advance.
>
The 4400R is a rather strange beast.  There are, basically, four
controllers (e.g. /dev/video[0..3]) and 16 inputs; each input can go
to any of the four controllers, and the driver will also allow the
same input to go to more than one controller.  Each controller,
however, can display only one input at a time.

Your description sounds as if you are trying to use only one
controller, and switch it's input back and forth between the two
cameras.  Assuming you have no more than four cameras (and you said,
in this case, two), you should assure that each camera goes to a
separate controller (i.e. instead of using "/dev/video0 channel 1" and
"dev/video0 channel 2", for the second use "/dev/video1 channel 2". 
Hopefully that should give a "clean" image for both.

> Sincerely yours
> Ming
>

Regards,

Bill


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
