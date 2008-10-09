Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m99CWika031235
	for <video4linux-list@redhat.com>; Thu, 9 Oct 2008 08:32:44 -0400
Received: from mu-out-0910.google.com (mu-out-0910.google.com [209.85.134.184])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m99CWVZ6002492
	for <video4linux-list@redhat.com>; Thu, 9 Oct 2008 08:32:31 -0400
Received: by mu-out-0910.google.com with SMTP id g7so3651441muf.1
	for <video4linux-list@redhat.com>; Thu, 09 Oct 2008 05:32:30 -0700 (PDT)
Message-ID: <d3f26e0b0810090532y1bd6595ay1ffdd40cc801ac15@mail.gmail.com>
Date: Thu, 9 Oct 2008 18:02:28 +0530
From: "vinothkumar raman" <vinocit@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: My azure wave camera has got some issue
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

I am using a VGA camera from azure wave . I am trying to use Java Media
Framework to access it. It uses v4l(not v4l2).
Its unable to recognize it. The same program works in Windows XP. Its able
to detect it but not recognize it. When i use xawtv. Its saying that
v4l-conf has got some trouble. when i run v4l-conf its showing up that the
device doesnt have a overlay support. luvc vies says that the format is not
support and v4l_init failed. In the same system i used a logitech Quick Cam
go it worked pretty fine with everything. But tha azure wave's camera doesnt
work. Could anyone help me out. I want it to get it working urgently.

Thanks,
R.Vinoth Kumar
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
