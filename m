Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2ONDSkW014982
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 19:13:28 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2OND6lV024107
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 19:13:06 -0400
Received: from e177036182.adsl.alicedsl.de ([85.177.36.182]
	helo=[192.168.0.124]) by mail.uni-paderborn.de with esmtpsa
	(TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.63 hoth)
	id 1LmFns-0002ma-SP
	for video4linux-list@redhat.com; Wed, 25 Mar 2009 00:13:05 +0100
Message-ID: <49C9698C.10607@campus.upb.de>
Date: Wed, 25 Mar 2009 00:15:24 +0100
From: David Woitkowski <jarrn@campus.upb.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Cinergy Hybrid T USB XS (0ccd:0042) not working
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

I'm currently fiddling around with my Terratec Cinergy Hybrid T USB XS

$ lsusb
Bus 008 Device 007: ID 0ccd:0042 TerraTec Electronic GmbH Cinergy Hybrid
T XS

$ uname -r
2.6.27-11-generic
(it's a ubuntu 8.10 machine)

I have installed the latest em28xx-new drivers provided by Markus
Rechberger and get

$ modprobe em28xx device_mode=1
$ modprobe em28xx-dvb
(attaching the device)
$ dmesg
[ 5155.748881] em28xx v4l2 driver version 0.0.1 loaded
[ 5155.750479] usbcore: registered new interface driver em28xx
[ 5169.348074] usb 8-2: new high speed USB device using ehci_hcd and
address 7
[ 5169.494648] usb 8-2: configuration #1 chosen from 1 choice
[ 5169.496087] em28xx: new video device (0ccd:0042): interface 0, class 255
[ 5169.496099] em28xx: device is attached to a USB 2.0 bus
[ 5169.496105] em28xx #0: Alternate settings: 8
[ 5169.496110] em28xx #0: Alternate setting 0, max size= 0
[ 5169.496114] em28xx #0: Alternate setting 1, max size= 0
[ 5169.496119] em28xx #0: Alternate setting 2, max size= 1448
[ 5169.496123] em28xx #0: Alternate setting 3, max size= 2048
[ 5169.496128] em28xx #0: Alternate setting 4, max size= 2304
[ 5169.496132] em28xx #0: Alternate setting 5, max size= 2580
[ 5169.496136] em28xx #0: Alternate setting 6, max size= 2892
[ 5169.496140] em28xx #0: Alternate setting 7, max size= 3072
[ 5169.743938] attach_inform: tvp5150 detected.
[ 5169.808565] tvp5150 0-005c: tvp5150am1 detected.
[ 5171.360938] successfully attached tuner
[ 5171.367995] em28xx #0: V4L2 VBI device registered as /dev/vbi0
[ 5171.386199] em28xx #0: V4L2 device registered as /dev/video1
[ 5171.386657] em2880-dvb.c: DVB Init
[ 5171.687691] DVB: registering new adapter (em2880 DVB-T)
[ 5171.687943] DVB: registering frontend 0 (Zarlink MT352 DVB-T)...
[ 5171.691406] input: em2880/em2870 remote control as
/devices/virtual/input/input11
[ 5171.737150] em28xx-input.c: remote control handler attached
[ 5171.737157] em28xx #0: Found Terratec Hybrid XS

everything seems to be all right but actually nothing I've tested so far
works.

My current attempts cover dvb-t:

$ scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/de-Bielefeld >
channels.conf
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/de-Bielefeld
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 514000000 0 2 9 1 1 3 0
initial transponder 554000000 0 1 9 3 1 3 0
initial transponder 570000000 0 2 9 1 1 3 0
>>> tune to: 
514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 

(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 
554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 

(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 
570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 

(tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

and after that attempt I got
$ dmesg
... as before ...
[ 5171.691406] input: em2880/em2870 remote control as
/devices/virtual/input/input11
[ 5171.737150] em28xx-input.c: remote control handler attached
[ 5171.737157] em28xx #0: Found Terratec Hybrid XS
[ 5191.914643] em28xx_dvb_init
[ 5205.996064] powered down zl10353
[ 5308.636444] tvp5150 0-005c: tvp5150am1 detected.
[ 5712.944647] em28xx_dvb_init
[ 5727.073036] powered down zl10353

Any hints? Is there any possibility this is a variant of the 0042 not
covered by the em28xx-new? (BTW: I tried analogue TV too just recieving
white noise with no signal on every channel)

I am willing to debug this but have no clue where to start.

Thanks for your help,

David

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
