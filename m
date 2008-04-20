Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3KB5QLq014939
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 07:05:26 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3KB5EbG018412
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 07:05:14 -0400
Received: by fg-out-1718.google.com with SMTP id e12so1271587fga.7
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 04:05:13 -0700 (PDT)
Message-ID: <68440fc20804200405n2c10485dg56b18e77622b00cd@mail.gmail.com>
Date: Sun, 20 Apr 2008 13:05:13 +0200
From: "Mike Brack" <itsec.listuser@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: ADS Tech Instant Video PCI. set-up failed on Ubuntu
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

Since days I try to install my TV card:
description: Multimedia video controller
product: CX23880/1/2/3 PCI Video and Audio Decoder
vendor: Conexant

By loading the driver I use the following card:
card=57 -> ADS Tech Instant Video PCI

dmesg shows:
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]: subsystem: 12ab:4700, board: ADS Tech Instant Video PCI
[card=57,insmod option]
cx88[0]: TV tuner type 4, Radio tuner type -1
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx88[0]/2: cx2388x 8802 Driver Manager
 ACPI: PCI Interrupt 0000:03:07.0[A] -> GSI 20 (level, low) -> IRQ 20
cx88[0]: subsystem: 12ab:4700, board: ADS Tech Instant Video PCI
[card=57,insmod option]
cx88[0]: TV tuner type 4, Radio tuner type -1
cx88[0]/0: found at 0000:03:07.0, rev: 5, irq: 20, latency: 64, mmio:
0xfb000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0

kdetv shows:
 kdetv
kbuildsycoca running...
ALSA lib control.c:909:(snd_ctl_open_noupdate) Invalid CTL
Creating vbi proxy client, rev.
$Id: proxy-client.c,v 1.16 2007/11/27 18:31:06 mschimek Exp $
proxy_msg: connect: error 2, No such file or directory
kdetv: WARNING: VBIDecoder: vbi_capture_proxy_new error: Connection via
socket failed, server not running.
Try to open V4L2 0.20 VBI device, libzvbi interface rev.
  $Id: io-v4l2.c,v 1.36 2007/11/27 17:55:46 mschimek Exp $
Opened /dev/vbi0
libzvbi:io-v4l2k:vbi_capture_v4l2k_new: Try to open V4L2 2.6 VBI device,
libzvbi interface rev.
  $Id: io-v4l2k.c,v 1.48 2007/11/27 17:55:41 mschimek Exp $.
libzvbi:io-v4l2k:vbi_capture_v4l2k_new: Opened /dev/vbi0.
libzvbi:io-v4l2k:vbi_capture_v4l2k_new: /dev/vbi0 (ADS Tech Instant Video
PCI) is a v4l2 vbi device,
driver cx8800, version 0x00000006.
libzvbi:io-v4l2k:vbi_capture_v4l2k_new: Using streaming interface.
libzvbi:io-v4l2k:v4l2_get_videostd: Current scanning system is 525.
libzvbi:io-v4l2k:v4l2_update_services: Querying current vbi parameters...
libzvbi:io-v4l2k:v4l2_update_services: ...success.
libzvbi:print_vfmt: VBI capture parameters supported:
libzvbi:print_vfmt: VBI capture parameters granted:
...
...libzvbi:io-v4l2k:vbi_capture_v4l2k_new: Successfully opened /dev/vbi0
(ADS Tech Instant Video PCI).
libzvbi:io-v4l2k:v4l2_stream: Failed to enable streaming, errno 22.
kdetv: WARNING: VbiDecoder: VBI capture error: Invalid argument
...
...

uname -r
2.6.24.3 (Ubuntu)

How can I get this card running?
Any help is very much appreciated.
--
Kind regards,
Mike
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
