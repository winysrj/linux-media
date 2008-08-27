Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7RGxMdQ024978
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 12:59:23 -0400
Received: from n6.bullet.mail.mud.yahoo.com (n6.bullet.mail.mud.yahoo.com
	[216.252.100.62])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7RGx8j2015774
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 12:59:08 -0400
Date: Wed, 27 Aug 2008 16:59:01 +0000 (GMT)
From: Lars Oliver Hansen <lolh@ymail.com>
To: linux-dvb@linuxtv.org, video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <954706.44416.qm@web28416.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: 
Subject: Information: Ubuntu Linux kernel image update solves v4l2
	alsa-sound troubles
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

Hello everyone!=0A=0A =0Ayesterday the Ubuntu 8.04 auto-updater installed a=
 new kernel image (64-bit desktop). It solved the alsa-sound troubles on my=
 laptop using mrec s v4l-experimental driver for saa7134.=0A =0AHere's the =
dmesg:=0A[    0.000000] Linux video capture interface: v2.00=0A[    0.00000=
0] video_buf: exports duplicate symbol videobuf_mmap_mapper (owned by video=
buf_core)=0A[    0.000000] video_buf: exports duplicate symbol videobuf_mma=
p_mapper (owned by videobuf_core)=0A[    0.000000] saa7130/34: v4l2 driver =
version 0.2.14 loaded=0A[    0.000000] video_buf: exports duplicate symbol =
videobuf_mmap_mapper (owned by videobuf_core)=0A[    0.000000] saa7134 ALSA=
 driver for DMA sound loaded=0A =0AThe only errors are duplicate symbols no=
w. My Sound driver is the current latest Realtek HD audio codec driver. My =
laptop is an Acer 5050.=0A =0AUnfortunately the new kernel image made acpi =
not working again on my laptop instead of solving the wireless not detectin=
g any routers.=0AIs it possible to compile a new Linux kernel without modif=
ying anything else (other dependencies) and telling grub to load this new k=
ernel while having the previous one still around so that one can always cha=
nge to the old kernel in case anything goes wrong? How?=0AThanks!=0ALars=0A=
=0ASend instant messages to your online friends http://uk.messenger.yahoo.c=
om 
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
