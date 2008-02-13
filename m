Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1E1oU3R006512
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 20:50:30 -0500
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1E1o8ff023521
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 20:50:08 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JPTEg-0007kV-6l
	for video4linux-list@redhat.com; Thu, 14 Feb 2008 01:50:02 +0000
Received: from pv107226.reshsg.uci.edu ([128.195.107.226])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 01:50:02 +0000
Received: from rvernica by pv107226.reshsg.uci.edu with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 01:50:02 +0000
To: video4linux-list@redhat.com
From: Rares Vernica <rvernica@gmail.com>
Date: Wed, 13 Feb 2008 17:42:02 +0200
Message-ID: <fp0693$e32$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: v4l-conf fails -- can't open /dev/video0
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

Hello,

Please excuse me if this is not the right place to ask this question. I 
don't really know where to look for answers.

I installed KnoppMyth R5F27 for MythTV. I have problems configuring the 
video capture card. I turned to see if v4l works.

Here is what v4l-conf returns:

can't open /dev/video0: No such file or directory

Here are the relevant lines from /var/log/messages:

Feb 13 13:50:06 newman kernel: EXT3 FS on hda1, internal journal
Feb 13 13:50:06 newman kernel: Linux video capture interface: v2.00
Feb 13 13:50:06 newman kernel: bttv: driver version 0.9.17 loaded
Feb 13 13:50:06 newman kernel: bttv: using 8 buffers with 2080k (520 
pages) each
  for capture
Feb 13 13:50:06 newman kernel: bt878: AUDIO driver version 0.0.0 loaded
Feb 13 13:50:06 newman kernel: Non-volatile memory driver v1.2
Feb 13 13:50:06 newman kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
Feb 13 13:50:06 newman kernel: cx88/2: cx2388x MPEG-TS Driver Manager 
version 0.
0.6 loaded
Feb 13 13:50:06 newman kernel: cx88/2: cx2388x dvb driver version 0.0.6 
loaded
Feb 13 13:50:06 newman kernel: cx88/2: registering cx8802 driver, type: 
dvb acce
ss: shared
Feb 13 13:50:06 newman kernel: Initializing USB Mass Storage driver...

Here are the relevant lines form dmesg:

EXT3 FS on hda1, internal journal
Linux video capture interface: v2.00
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bt878: AUDIO driver version 0.0.0 loaded
Non-volatile memory driver v1.2
saa7130/34: v4l2 driver version 0.2.14 loaded
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
ohci_hcd: 2005 April 22 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
Initializing USB Mass Storage driver...

Here is what I get with lspci -vv:

02:09.0 Multimedia controller: C-Cube Microsystems E4? (rev b1)
         Subsystem: Lumanate, Inc. Unknown device 0001
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (4000ns min, 250ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 18
         Region 0: Memory at 43000000 (32-bit, prefetchable) [size=16M]
         Capabilities: <access denied>

Here is what I get with lsmod | grep btt:

bttv                  174772  2 dvb_bt8xx,bt878
video_buf              23812  6 
cx8802,cx88xx,saa7134_dvb,saa7134,video_buf_dvb,bttv
ir_common              33540  4 cx88xx,saa7134,ir_kbd_i2c,bttv
compat_ioctl32          5120  2 saa7134,bttv
i2c_algo_bit           12296  3 cx88_vp3054_i2c,cx88xx,bttv
btcx_risc               7816  3 cx8802,cx88xx,bttv
tveeprom               17936  2 cx88xx,bttv
videodev               29184  3 cx88xx,saa7134,bttv
v4l2_common            18688  4 cx88xx,saa7134,bttv,videodev
v4l1_compat            17668  3 saa7134,bttv,videodev
firmware_class         11648  5 pcmcia,saa7134_dvb,tda1004x,dvb_bt8xx,bttv
i2c_core               20864  10 
cx88_vp3054_i2c,cx88xx,saa7134_dvb,saa7134,ir_kbd_i2c,tda1004x,dvb_bt8xx,bttv,i2c_algo_bit,tveeprom

Thanks a lot,
Ray

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
