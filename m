Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3FNNtNO027543
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 19:23:55 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.238])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3FNNg0L012698
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 19:23:42 -0400
Received: by rv-out-0506.google.com with SMTP id f6so3251626rvb.3
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 16:23:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <682222.63251.qm@web65503.mail.ac4.yahoo.com>
References: <548493.31113.qm@web57903.mail.re3.yahoo.com>
	<682222.63251.qm@web65503.mail.ac4.yahoo.com>
Date: Thu, 16 Apr 2009 08:23:41 +0900
Message-ID: <5e9665e10904151623g4c5fba5fq4417b7f3519fda7c@mail.gmail.com>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: michael_h_williamson@yahoo.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: stream rate question
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

Hi Mike,

As I understand, what you asking about is frame rate control. Am I right?
I think that could be handle by VIDIOC_S_PARM, with handling v4l2_fract.
I have never been using usb camera in linux, but in other camera
drivers it can be handled like that.
Cheers,

Nate



On Thu, Apr 16, 2009 at 3:21 AM, Michael Williamson
<michael_h_williamson@yahoo.com> wrote:
>
> Hi,
>
> I have a question. Is there any way to slow down the
> stream rate so that I can use many USB cameras simultaneously?
> Currently, I must turn on and off streaming sequentially
> for each camera, because attempting to turn on streaming
> for all the cameras at once fails saying that the USB bus
> can not handle the bandwidth.
>
> Thanks,
> -Mike
>
>
>
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>



-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
