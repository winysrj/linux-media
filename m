Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m64Mc138003442
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 18:38:01 -0400
Received: from mrqout2.tiscali.it (mrqout2a.tiscali.it [195.130.225.14])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m64Mbg5O015787
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 18:37:42 -0400
Received: from ps11 (10.39.75.81) by mail-9.mail.tiscali.sys (8.0.016)
	id 4816F145001528D0 for video4linux-list@redhat.com;
	Sat, 5 Jul 2008 00:37:35 +0200
Message-ID: <16342448.1215211055980.JavaMail.root@ps11>
Date: Sat, 5 Jul 2008 00:37:35 +0200 (CEST)
From: "audetto@tiscali.it" <audetto@tiscali.it>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 8bit
Subject: An issue with: pwc, v4l2, VIDIOC_DQBUF and mplayer
Reply-To: "audetto@tiscali.it" <audetto@tiscali.it>
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

Sorry if the message arrives twice, but when sending from gmail I 
always get
"Message has a suspicious header"
=====================================================

Hi,

I have a Logitech QuickCam 4000 Pro USB and I am trying to use mplayer 
to play the video.
This is the command I use

mplayer -tv width=640:height=480:driver=v4l2 -fps 15 tv://

But when I quit mplayer hangs in the following line, while shutting 
down the video

        /* unqueue all remaining buffers */
        memset(&buf,0,sizeof(buf));
        buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        buf.memory = V4L2_MEMORY_MMAP;
        while (!ioctl(priv->video_fd, VIDIOC_DQBUF, &buf));

Which is more or less at line 1111 of stream/tvi_v4l2.c.

The problem is that the ioctl call VIDIOC_DQBUF never returns.
Reading the doc for VIDIOC_DQBUF
http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/r8849.
htm

The function should stop if there is no block to unqueue, unless it 
has been opened with O_NONBLOCK.
mplayer DOES NOT use O_NONBLOCK, so the call is allowed to block.

The problems are 2

1) I've tried to open with O_NONBLOCK and the ioctl blocks anyway.
pwc-v4l.c at line 1120 does not check for O_NONBLOCK.
Is this a bug?

2) should mplayer handle the situation in a different way? is there a 
way to check if there are queued blocks?

Andrea



_________________________________________________________________
Tiscali Family: Adsl e Telefono senza limiti e senza scatto alla risposta. PER TE CON LO SCONTO DEL 25% FINO AL 2010. In più il software parental control Magic Desktop Basic è GRATIS! Attiva entro il 10/07/08. http://abbonati.tiscali.it/promo/tuttoincluso/ 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
