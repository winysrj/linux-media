Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m49FcXDQ010009
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 11:38:33 -0400
Received: from smtp-out3.libero.it (smtp-out3.libero.it [212.52.84.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m49Fc0tk014970
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 11:38:00 -0400
Received: from MailRelay09.libero.it (192.168.32.116) by smtp-out3.libero.it
	(7.3.120) id 4628C87A0B991798 for video4linux-list@redhat.com;
	Fri, 9 May 2008 17:37:54 +0200
From: Roberto Mantovani - A&L <rmantovani@libero.it>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain
Date: Fri, 09 May 2008 17:37:54 +0200
Message-Id: <1210347474.15033.10.camel@mandoch.ael.it>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: How to view camera output with xine
Reply-To: rmantovani@libero.it
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

I'm working on a em28xx based usb camera.

How can I view the camera output with xine ?

With mplayer I run the command : mplayer tv://

With xine I've tried : xine v4l2:// but xine give me a message : "there
is no input plugin available to handle v4l2://", but if I try xine
--list-pugins there is :
-Input:
   ...,v4l_tv, ...

I have to write a program in fltk to handle the video out of the cam.
Do you know other methods to use the video out of the camera in a
program ? 

Best Regards,
--
Roberto

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
