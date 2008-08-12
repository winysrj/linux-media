Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7CGRhAq022243
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 12:27:43 -0400
Received: from mu-out-0910.google.com (mu-out-0910.google.com [209.85.134.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7CGRfkk017834
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 12:27:41 -0400
Received: by mu-out-0910.google.com with SMTP id w8so4496380mue.1
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 09:27:41 -0700 (PDT)
Message-ID: <48A1B9F4.3070506@gmail.com>
Date: Tue, 12 Aug 2008 17:27:32 +0100
From: zePh7r <zeph7r@gmail.com>
MIME-Version: 1.0
To: Albert Comerma <albert.comerma@gmail.com>, video4linux-list@redhat.com,
	linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: Support for Asus My-Cinema U3000Hybrid?
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

This is looking good. It seems to load the firmware well. I even ran
kaffeine and it detected my card instantly. However, as there's no dvb-t
service where I live (there's still no dvb-t in Portugal) I can't test
it in full. However I tried to do a channel scan and the signal bar
showed high strength signals multiple times during scan -- which I
interpret as a) the tuner is working, and b) the card is being able to
find signal but unable to decode it since it's not a digital signal. I'm
getting this output in dmesg just for plugging the device into the usb port:

Aug 12 14:29:29 zeph7r-laptop kernel: usb 4-1: new high speed USB device
using ehci_hcd and address 12
Aug 12 14:29:29 zeph7r-laptop kernel: usb 4-1: configuration #1 chosen
from 1 choice
Aug 12 14:29:29 zeph7r-laptop kernel: dvb-usb: found a 'Asus My
Cinema-U3000Hybrid' in cold state, will try to load a firmware
Aug 12 14:29:29 zeph7r-laptop kernel: dvb-usb: downloading firmware from
file 'dvb-usb-dib0700-1.10.fw'
Aug 12 14:29:29 zeph7r-laptop kernel: dib0700: firmware started
successfully.
Aug 12 14:29:30 zeph7r-laptop kernel: dvb-usb: found a 'Asus My
Cinema-U3000Hybrid' in warm state.
Aug 12 14:29:30 zeph7r-laptop kernel: dvb-usb: will pass the complete
MPEG2 transport stream to the software demuxer.
Aug 12 14:29:30 zeph7r-laptop kernel: DVB: registering new adapter (Asus
My Cinema-U3000Hybrid)
Aug 12 14:29:30 zeph7r-laptop kernel: DVB: registering frontend 0
(DiBcom 7000PC)...
Aug 12 14:29:30 zeph7r-laptop kernel: xc2028 2-0061: creating new instance
Aug 12 14:29:30 zeph7r-laptop kernel: xc2028 2-0061: type set to XCeive
xc2028/xc3028 tuner
Aug 12 14:29:30 zeph7r-laptop kernel: input: IR-receiver inside an USB
DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb4/4-1/input/input13
Aug 12 14:29:30 zeph7r-laptop kernel: dvb-usb: schedule remote query
interval to 150 msecs.
Aug 12 14:29:30 zeph7r-laptop kernel: dvb-usb: Asus My
Cinema-U3000Hybrid successfully initialized and connected.
Aug 12 14:29:30 zeph7r-laptop kernel: usb 4-1: New USB device found,
idVendor=0b05, idProduct=1736
Aug 12 14:29:30 zeph7r-laptop kernel: usb 4-1: New USB device strings:
Mfr=1, Product=2, SerialNumber=3
Aug 12 14:29:30 zeph7r-laptop kernel: usb 4-1: Product: U3000 Hybrid
Aug 12 14:29:30 zeph7r-laptop kernel: usb 4-1: Manufacturer: ASUSTeK
Aug 12 14:29:30 zeph7r-laptop kernel: usb 4-1: SerialNumber: 8110400333
Aug 12 14:29:36 zeph7r-laptop syslog-ng[1724]: STATS: dropped 0


and after starting kaffeine there's still this more:

Aug 12 14:41:31 zeph7r-laptop kernel: xc2028 2-0061: Loading 80 firmware
images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Aug 12 14:41:31 zeph7r-laptop kernel: xc2028 2-0061: Loading firmware
for type=BASE F8MHZ (3), id 0000000000000000.
Aug 12 14:41:38 zeph7r-laptop kernel: xc2028 2-0061: Loading firmware
for type=D2620 DTV7 (88), id 0000000000000000.
Aug 12 14:41:38 zeph7r-laptop kernel: xc2028 2-0061: Loading SCODE for
type=DTV8 SCODE HAS_IF_5400 (60000200), id 0000000000000000.
Aug 12 14:42:04 zeph7r-laptop kernel: xc2028 2-0061: Loading firmware
for type=D2620 DTV78 (108), id 0000000000000000.
Aug 12 14:42:04 zeph7r-laptop kernel: xc2028 2-0061: Loading SCODE for
type=DTV8 SCODE HAS_IF_5400 (60000200), id 0000000000000000.


However I also tried kdetv and the card didn't seem to be recognized
here. In the device list there is still only my webcam to choose from.
If I try to run it from a terminal no significant output is shown. How
can go further in testing and getting the analog tv part to work?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
