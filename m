Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m55Mox2j021880
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 18:50:59 -0400
Received: from web63015.mail.re1.yahoo.com (web63015.mail.re1.yahoo.com
	[69.147.96.242])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m55MniFK020325
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 18:49:45 -0400
Date: Thu, 5 Jun 2008 15:49:39 -0700 (PDT)
From: Fritz Katz <frtzkatz@yahoo.com>
To: video4linux-list@redhat.com
In-Reply-To: <20080605160010.BB443619D1A@hormel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <214178.91761.qm@web63015.mail.re1.yahoo.com>
Subject: Re: Writing first v4l2 driver
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

On Thu, 05 Jun 2008
Jon Dufresne <jon dufresne infinitevideocorporation com> wrote:
> 
> I'm in the process of writing my first v4l2 linux driver. 
> I have written drivers in the past but this is my first time 
> with a video device. I have read as much documentation as I 
> could get my hands on.
> ......
> Is there a good guide on using video-buf for video dma transfer? I did
> quite a few google searches but I didn't find anything.
_________________

For a good overview of "Linux Device Drivers" the O'Reilly book is FREE online:
http://www.xml.com/ldd/chapter/book/

Take a look at chapter 16:
http://www.xml.com/ldd/chapter/book/ch16.html

There are several paragraphs introducing 'drivers/video' and 'drivers/media'

I'm in the process of writing my first v4l2 driver too. However, I'm going to create a driver for a TV-tuner that's not in the list of currently supported cards. ( Wish me luck! ) Or, better, point me in the direction of resources for TV-tuner drivers on Linux.

Regards,
-- Fritz Katz
Los Angeles, CA



      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
