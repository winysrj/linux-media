Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8NFwqL5031432
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 12:00:06 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8NFWjSj020818
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 11:33:33 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1841376fga.7
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 08:32:45 -0700 (PDT)
Message-ID: <191cfb4b0809230832t78056174xb16fe45923b07779@mail.gmail.com>
Date: Tue, 23 Sep 2008 21:02:44 +0530
From: "Nirmal Kumar" <nirmal.kumara@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: v4l2 basics
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

Hi,
  I am trying to write a simple v4l2 camera capture driver.

  I am confused on how buffer management happens

  I am consufed about the videobuffer queues.


  can anyone take me through a simple v4l2 camera capture driver

  and explain how things work?



 There is too little documentation. i am trying to understand the flow of
the drivers from the moment the frame is captured
  till it is fed to the app.


please help me.

Regards,
Nirmal
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
