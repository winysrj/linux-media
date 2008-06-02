Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m52NmHf5021808
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 19:48:17 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.224])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m52NlanL026430
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 19:48:14 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1283398rvb.51
	for <video4linux-list@redhat.com>; Mon, 02 Jun 2008 16:48:13 -0700 (PDT)
Message-ID: <78877a450806021648o4eda07aqc342d842d67cd1c0@mail.gmail.com>
Date: Tue, 3 Jun 2008 09:48:13 +1000
From: "Gilles GIGAN" <gilles.gigan@gmail.com>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <200806022239.52094.laurent.pinchart@skynet.be>
MIME-Version: 1.0
References: <78877a450806012349j25cf72acm7aed866c3888ecdd@mail.gmail.com>
	<200806022239.52094.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: Re: Detecting webcam unplugging
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

Hi Laurent,

Your V4L1 driver is probably to blame.


So does this means there is nothing userspace can do to safely detect
unplugging events while capturing ?

I tested other applications (ekiga, amsn, camorama and skype) with these
webcams and got the same results (app freezes), whereas with V4L2 cameras, a
popup warns the user the webcam has been unplugged and the app is still
useable.
If anyone comes up with something, I be glad to hear about it.

Thanks,
Gilles
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
