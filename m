Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n42LL9jd023609
	for <video4linux-list@redhat.com>; Sat, 2 May 2009 17:21:09 -0400
Received: from mail-gx0-f158.google.com (mail-gx0-f158.google.com
	[209.85.217.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n42LKuwF017850
	for <video4linux-list@redhat.com>; Sat, 2 May 2009 17:20:56 -0400
Received: by gxk2 with SMTP id 2so6292983gxk.3
	for <video4linux-list@redhat.com>; Sat, 02 May 2009 14:20:56 -0700 (PDT)
MIME-Version: 1.0
From: Pablitt <pablo.fabregat@gmail.com>
Date: Sat, 2 May 2009 18:20:41 -0300
Message-ID: <ff65116b0905021420v747dba03ib998177575ba10ef@mail.gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Phillips Semiconductors based card not working
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

Hi all
i have this tv card
(sudo lspci -vnn)
00:0e.0 Multimedia controller [0480]: Philips Semiconductors
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
    Subsystem: Philips Semiconductors Device [1131:0000]
    Flags: bus master, medium devsel, latency 64, IRQ 19
    Memory at fac00000 (32-bit, non-prefetchable) [size=2K]
    Capabilities: [40] Power Management version 2
    Kernel driver in use: saa7134
    Kernel modules: saa7134

it stopped working after upgrade from hardy to intrepid, i think it has
something to do with the new kernels...
i used to use the options card and tuner but i cant remember which
parameters and i'm tryng different parms with no luck

does anyone got this card working in ubuntu jaunty? if so, wich parameters?

thanks in advance


More info:
dmesg | grep saa
[   17.097515] saa7130/34: v4l2 driver version 0.2.14 loaded
[   17.097687] saa7134 0000:00:0e.0: PCI INT A -> GSI 19 (level, low) -> IRQ
19
[   17.097698] saa7133[0]: found at 0000:00:0e.0, rev: 209, irq: 19,
latency: 64, mmio: 0xfac00000
[   17.097705] saa7133[0]: subsystem: 1131:0000, board: UNKNOWN/GENERIC
[card=0,autodetected]
[   17.097802] saa7133[0]: board init: gpio is 40
[   17.200225] saa7133[0]: Huh, no eeprom present (err=-5)?
[   17.200681] saa7133[0]: registered device video0 [v4l2]
[   17.200728] saa7133[0]: registered device vbi0
[   17.213091] saa7134 ALSA driver for DMA sound loaded
[   17.213127] saa7133[0]/alsa: saa7133[0] at 0xfac00000 irq 19 registered
as card -2


Kernel version 2.6.28-11-generic
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
