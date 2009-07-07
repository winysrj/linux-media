Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n676itgg021108
	for <video4linux-list@redhat.com>; Tue, 7 Jul 2009 02:44:55 -0400
Received: from mail-pz0-f200.google.com (mail-pz0-f200.google.com
	[209.85.222.200])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n676ifYU029090
	for <video4linux-list@redhat.com>; Tue, 7 Jul 2009 02:44:42 -0400
Received: by pzk38 with SMTP id 38so1450174pzk.23
	for <video4linux-list@redhat.com>; Mon, 06 Jul 2009 23:44:41 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 Jul 2009 15:44:41 +0900
Message-ID: <3a9b62b20907062344p56d1ecafsbbb936c74eadfd43@mail.gmail.com>
From: =?EUC-KR?B?vK3BpLnO?= <sirseo@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: how to make qbuf
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

Hi.

I'm making V4l2 device driver for mplayer.
But
It's too difficult to understand V4l2 driver internal structure.

I can't understand how to use VIDIOC_QBUF, VIDIOC_DQBUF ioctl and 'struct
videobuf_queue'

Why does v4l2 driver need to use 'videobuf_queue'?

Please. tell me v4l2 driver internal operation.

Thanks.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
