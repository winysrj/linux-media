Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8B7L0SN006800
	for <video4linux-list@redhat.com>; Fri, 11 Sep 2009 03:21:00 -0400
Received: from mail-px0-f135.google.com (mail-px0-f135.google.com
	[209.85.216.135])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8B7Kojm003244
	for <video4linux-list@redhat.com>; Fri, 11 Sep 2009 03:20:50 -0400
Received: by pxi41 with SMTP id 41so65352pxi.30
	for <video4linux-list@redhat.com>; Fri, 11 Sep 2009 00:20:50 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 11 Sep 2009 12:50:50 +0530
Message-ID: <25f5fcff0909110020m56f881d0q383aae1f5226476@mail.gmail.com>
From: Niamathullah sharief <newbiesha@gmail.com>
To: kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Cc: video4linux-list@redhat.com
Subject: About Webcam module
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

Hi friends,
   I have some doubts in video device driver. I have an Creative webcam with
me. After inserting the webcam i have seen the following modules installed

Module              Size       Used by
>
gspca_zc3xx   55936      0
>
gspca_main    29312       1   gspca_zc3xx
>
videodev        41344       1   gspca_main
>
v4l1_compat  22404       1   videodev


I dont know which module is exactly for my webcam? i am seeing 5 extra
module installed after inserting my webcam. I am confused. Can anyone help
me?
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
