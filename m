Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8GJM11h017274
	for <video4linux-list@redhat.com>; Tue, 16 Sep 2008 15:22:05 -0400
Received: from smtp.unisys.com.br (smtp.unisys.com.br [200.220.64.9])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8GJLGgA025921
	for <video4linux-list@redhat.com>; Tue, 16 Sep 2008 15:21:18 -0400
From: danflu@uninet.com.br
To: video4linux-list@redhat.com
Date: Tue, 16 Sep 2008 16:21:11 -0300
Message-id: <48d00727.2fe.4e96.811320937@uninet.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Subject: saa7134 controller
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

I'm Trying to capture from a capture TV card (Zogis Real
Angel 220 with FM) that has a saa7134 controller but I'm not
succeding in make it work.

When I type dmesg the operating system (linux Ubuntu
8.04)says that it cannot automatically detect the device,
and V4L2 lists it as UNKNOWN. The driver listed by
video4linux is saa7134. The device is identified at
/dev/video0.

Please, could you clarify step by step how can I setup linux
to make this device work ? 

Another thing... what is the best application available
today to watch tv on linux ???

Thank you very much!
Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
