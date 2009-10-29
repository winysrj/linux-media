Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9T1ctw8023476
	for <video4linux-list@redhat.com>; Wed, 28 Oct 2009 21:38:55 -0400
Received: from mail-bw0-f214.google.com (mail-bw0-f214.google.com
	[209.85.218.214])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n9T1ciMb030027
	for <video4linux-list@redhat.com>; Wed, 28 Oct 2009 21:38:45 -0400
Received: by bwz6 with SMTP id 6so1764429bwz.11
	for <video4linux-list@redhat.com>; Wed, 28 Oct 2009 18:38:43 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 29 Oct 2009 02:38:43 +0100
Message-ID: <9a8b94f30910281838k71fb9443t6ec848bb47a59a87@mail.gmail.com>
From: Petter Granstrom <granis@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Subject: Hauppauge WinTV HVR-900/EyeTV hybrid USB stick (em2882/em2883)
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

Im currently using the EyeTV hybrid USB stick for analog-tv purposes
and its working fine with module "em28xx". However, the EyeTV package
is bundled with an IR remote and I was hoping to get it working, but
so far - no luck.

In dmesg I can see that somekind of IR is detected by the driver ->
input: em28xx IR (em28xx #0) as /class/input/input4

This is the output from "cat /proc/bus/input/devices" ->
I: Bus=0003 Vendor=2040 Product=6502 Version=0001
N: Name="em28xx IR (em28xx #0)"
P: Phys=usb-0000:02:0c.2-1/input0
S: Sysfs=/class/input/input4
U: Uniq=
H: Handlers=kbd event4
B: EV=100003
B: KEY=100fc312 214a802 0 0 0 0 18000 41a8 4801 9e1680 0 0 10000ffc

List of loaded modules ->
tveeprom videobuf_core videobuf_vmalloc ir_common v4l1_compat videodev
em28xx v4l2_common tvp5150 tuner tuner_xc2028 em28xx_alsa

I have been testing with " evtest /dev/input/event4" but I am
receiving no output at all.

Does anyone have any suggestions what to try for getting IR to work? :-)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
