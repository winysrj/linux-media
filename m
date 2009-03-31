Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2VCMx3f004723
	for <video4linux-list@redhat.com>; Tue, 31 Mar 2009 08:22:59 -0400
Received: from smtp.ozonline.com.au (pilbara.ozonline.com.au [203.23.159.213])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2VCMbZA012761
	for <video4linux-list@redhat.com>; Tue, 31 Mar 2009 08:22:38 -0400
Received: from [192.168.1.100] (adsl-syd-4-214.ozonline.com.au [210.4.231.214])
	by smtp.ozonline.com.au (8.13.7/8.13.7) with ESMTP id n2VCMZJN028766
	for <video4linux-list@redhat.com>; Tue, 31 Mar 2009 23:22:36 +1100
Message-ID: <49D20B0B.1030701@australiaonline.net.au>
Date: Tue, 31 Mar 2009 23:22:35 +1100
From: john knops <jknops@australiaonline.net.au>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: No scan with DViCo FusionHDTV DVB-T Dual Express
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

I'm using the DViCo card with  Ubuntu 8.10amd64. I've followed the 
various instructions for installing drivers and firmware viz:-
 loaded the drivers(v4l-dvb-b44a3aed3d1.tar.gz) as suggested on 
www.linuxtv.org/wiki/index.php/DViCo_FusionHDTV_DVB-T_Dual_Express 
<http://www.linuxtv.org/wiki/index.php/DViCo_FusionHDTV_DVB-T_Dual_Express> 
from linuxtv.org/hg/~stoth/v4l-dvb. I also had to load gspca_m5602.ko in 
/lib/modules/2.6.27-11-generic/kernel/drivers/media/video/gspca.

The card wasn't auto-loaded until I added "options cx23885 card=11" to 
/etc/modprobe.d/options.
I obtained xc3028-v27.fw.tar.bz2 via ubuntuforums.org then copied the 
untarred file xc3028-v27.fw to /lib/firmware.

 
Dmesg on startup shows that the card is recognised:-
11.290571] cx23885 driver version 0.0.1 loaded
[   11.290620] cx23885 0000:01:00.0: PCI INT A -> GSI 28 (level, low) -> 
IRQ 28
[   11.291316] CORE cx23885[0]: subsystem: 0000:0000, board: DViCO 
FusionHDTV DVB-T Dual Express [card=11,insmod option]
[   11.569588] input: i2c IR (FusionHDTV) as /devices/virtual/input/input6
[   11.628464] ir-kbd-i2c: i2c IR (FusionHDTV) detected at 
i2c-0/0-006b/ir0 [cx23885[0]]
[   11.629459] cx23885_dvb_register() allocating 1 frontend(s)
[   11.629461] cx23885[0]: cx23885 based dvb card
[   11.724553] xc2028 0-0061: creating new instance
[   11.724555] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[   11.724559] DVB: registering new adapter (cx23885[0])
[   11.724561] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 
DVB-T)...
[   11.724818] cx23885_dvb_register() allocating 1 frontend(s)
[   11.724820] cx23885[0]: cx23885 based dvb card
[   11.725365] xc2028 1-0061: creating new instance
[   11.725366] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   11.725368] DVB: registering new adapter (cx23885[0])
[   11.725370] DVB: registering adapter 1 frontend 0 (Zarlink ZL10353 
DVB-T)...
[   11.725612] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   11.725617] cx23885[0]/0: found at 0000:01:00.0, rev: 2, irq: 28, 
latency: 0, mmio: 0xf7e00000
[   11.725622] cx23885 0000:01:00.0: setting latency timer to 64

Results of Dmesg after scanning with Mythtv:-
[34883.840269] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3), 
id 0000000000000000.
[34884.981848] xc2028 0-0061: Loading firmware for type=D2633 DTV78 
(110), id 0000000000000000.
[34884.995517] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[34885.025353] xc2028 0-0061: Incorrect readback of firmware version.
[34885.278433] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3), 
id 0000000000000000.
[34886.418714] xc2028 0-0061: Loading firmware for type=D2633 DTV78 
(110), id 0000000000000000.
[34886.432409] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[34886.465353] xc2028 0-0061: Incorrect readback of firmware version.
[34887.319906] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3), 
id 0000000000000000.
[34888.462715] xc2028 0-0061: Loading firmware for type=D2633 DTV78 
(110), id 0000000000000000.
[34888.476385] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[34888.509359] xc2028 0-0061: Incorrect readback of firmware version.
[34888.762430] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3), 
id 0000000000000000.
[34889.901843] xc2028 0-0061: Loading firmware for type=D2633 DTV78 
(110), id 0000000000000000.
[34889.915511] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[34889.949353] xc2028 0-0061: Incorrect readback of firmware version.

Any ideas why I'm getting " Incorrect readback of firmware version" What 
have I missed/done wrong?

Thanks.........

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
