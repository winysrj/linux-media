Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2ANwv18014767
	for <video4linux-list@redhat.com>; Mon, 10 Mar 2008 19:58:57 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2ANwOi7012834
	for <video4linux-list@redhat.com>; Mon, 10 Mar 2008 19:58:25 -0400
Received: by ug-out-1314.google.com with SMTP id t39so4444779ugd.6
	for <video4linux-list@redhat.com>; Mon, 10 Mar 2008 16:58:24 -0700 (PDT)
Message-ID: <226dee610803101658r3a94a606sa0969a3605d427f4@mail.gmail.com>
Date: Tue, 11 Mar 2008 05:28:24 +0530
From: "JoJo jojo" <onetwojojo@gmail.com>
To: danflu@uninet.com.br
In-Reply-To: <47d5b4b5.3b9.49c0.1570821612@uninet.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47d5b4b5.3b9.49c0.1570821612@uninet.com.br>
Cc: video4linux-list@redhat.com
Subject: Re: webcam frame grabber - help please!
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

On Tue, Mar 11, 2008 at 3:52 AM,  <danflu@uninet.com.br> wrote:
> Hello Everybody,
>
>  I'm writing a linux app (testing under ubuntu) that should
>  capture frames from webcam and do some processing to it. I
>  have some background in this area because i've written
>  several directshow apps, but i've never used to capture
>  video under linux systems.
>
>  So I'd really want to know from you what's the best way to
>  capture video from webcam using V4L2, some sample code would
>  be pretty usefull to me...
>
>  Thank you!!
>  Daniel


you just listen on the /dev/videox device
identify start of frame/end of frame
and off you go

-JoJo

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
