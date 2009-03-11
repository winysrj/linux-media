Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2B8ON88011469
	for <video4linux-list@redhat.com>; Wed, 11 Mar 2009 04:24:23 -0400
Received: from cluster-d.mailcontrol.com (cluster-d.mailcontrol.com
	[85.115.60.190])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2B8O3Fw006033
	for <video4linux-list@redhat.com>; Wed, 11 Mar 2009 04:24:04 -0400
Received: from mailserver.mta.int (mail.mta.it [89.96.171.250])
	by rly12d.srv.mailcontrol.com (MailControl) with ESMTP id
	n2B8O2XW015864
	for <video4linux-list@redhat.com>; Wed, 11 Mar 2009 08:24:02 GMT
From: Matteo Canella <matteo.canella@mta.it>
To: <video4linux-list@redhat.com>
Date: Wed, 11 Mar 2009 09:24:01 +0100
Message-ID: <006401c9a222$bb5d2000$32176000$@canella@mta.it>
MIME-Version: 1.0
Content-Language: it
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Subject: Init sequence
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

I'm adding some video4linux capabilities to my fujitsu Carmine video driver,
but I'm having some initialization problems.

I've added the v4l device registration (video_register_device) in the probe
routine of the video driver.

My problem is that, during the boot sequence, the v4l2  videodev_init is
done after the video card probing, so the video_register_device fails,
causing a kernel oops.

My workaround is to postpone the video_register_device in a later stage, but
I don't like it so much.

Is there a way to launch the v4l init from my video card driver probe as a
separate task and make it do the video_register_device asynchronously when
the video4linux is loaded?

Thank you

 

Matteo Canella

 

 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
