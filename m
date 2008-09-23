Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8NJSqvb001605
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 15:28:58 -0400
Received: from web63004.mail.re1.yahoo.com (web63004.mail.re1.yahoo.com
	[69.147.96.215])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8NJ1Xnn013519
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 15:01:33 -0400
Date: Tue, 23 Sep 2008 12:01:32 -0700 (PDT)
From: Fritz Katz <frtzkatz@yahoo.com>
To: video4linux-list@redhat.com, nirmal.kumara@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <244017.6633.qm@web63004.mail.re1.yahoo.com>
Cc: 
Subject: Re: v4l2 basics
Reply-To: frtzkatz@yahoo.com
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

On Tuesday, September 23, 2008 8:32 AM, "Nirmal Kumar" wrote:
>
>  I am trying to write a simple v4l2 camera capture driver.
>  I am confused on how buffer management happens
>  I am confused about the videobuffer queues.
>   can anyone take me through a simple v4l2 camera capture driver
>   and explain how things work?
>
> There is too little documentation. i am trying to understand the 
> flow of the drivers from the moment the frame is captured till it 
> is fed to the app.

Hello Nirmal,

  Hope this helps... 
--------------

Video4Linux2: an introduction 
http://lwn.net/Articles/203924/

V4L2 Device Driver series:
http://www.linux-mag.com/id/381
http://www.linux-mag.com/id/406
http://www.linux-mag.com/id/429
http://www.linux-mag.com/id/6206


Video4Linux2 API Specification
http://v4l2spec.bytesex.org/spec/book1.htm

Video4linux-list Archives
https://www.redhat.com/mailman/private/video4linux-list/

V4LWiki - 
http://www.linuxtv.org/v4lwiki/index.php/Main_Page
http://www.linuxtv.org/v4lwiki/index.php/V4l_Links

--------------

Anyone else got good links on creating V4L2 device drivers?

Regards,
-- Fritz Katz.




      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
