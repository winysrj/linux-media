Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n213UfVu016351
	for <video4linux-list@redhat.com>; Sat, 28 Feb 2009 22:30:41 -0500
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.248])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n213UK4x001469
	for <video4linux-list@redhat.com>; Sat, 28 Feb 2009 22:30:20 -0500
Received: by an-out-0708.google.com with SMTP id b2so1208650ana.36
	for <video4linux-list@redhat.com>; Sat, 28 Feb 2009 19:30:20 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 28 Feb 2009 21:30:20 -0600
Message-ID: <855c2fad0902281930p12943d92wd53bc7637af615cb@mail.gmail.com>
From: Anil Ramachandran <cloud9ine@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: KWorld 340U - need help.
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

Pardon me if I am posting without enough research, but I have scoured the
internet a whole day and done my best.

I have a KWorld 340U which is an em2870 device. I used the patch mentioned
at http://www.mail-archive.com/em28xx@mcentral.de/msg02008.html to install
the driver, but I am still confused on the firmware. em28xx help websites
drive me to xc3028 firmware but my tuner is a TDA18271 as per the driver
patch. I have modprobed both em28xx and em28xx-dvb and when i plug in the
module, the driver seems to be associated.

usb 8-2: new high speed USB device using ehci_hcd and address 8
> usb 8-2: configuration #1 chosen from 1 choice
> em28xx: new video device (1b80:a340): interface 0, class 255
> em28xx: device is attached to a USB 2.0 bus
> em28xx #0: Alternate settings: 8
> em28xx #0: Alternate setting 0, max size= 0
> em28xx #0: Alternate setting 1, max size= 0
> em28xx #0: Alternate setting 2, max size= 1448
> em28xx #0: Alternate setting 3, max size= 2048
> em28xx #0: Alternate setting 4, max size= 2304
> em28xx #0: Alternate setting 5, max size= 2580
> em28xx #0: Alternate setting 6, max size= 2892
> em28xx #0: Alternate setting 7, max size= 3072
> em2880-dvb.c: DVB Init
> tda18271 1-0060: creating new instance
> TDA18271HD/C2 detected @ 1-0060
> DVB: registering new adapter (em2880 DVB-T)
> DVB: registering frontend 0 (LG 3304)...
> em28xx #0: Found KWorld ATSC 340U
> usb 8-2: New USB device found, idVendor=1b80, idProduct=a340
> usb 8-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> usb 8-2: Product: USB 2870 Device
>

But my dmesg does not seem to have the eeprom listing etc that I typically
see on other people's logs. Further, on scanning using Kaffeine or dvbscan
using the US-ATSC-Center-Frequencies-8VSB channel profile, (I live in St.
Louis, MO, US) I end up with

 DvbCam::probe(): /dev/dvb/adapter0/ca0: : No such file or directory
> Using DVB device 0:0 "LG 3304"
> tuning ATSC to 57028000
> inv:2 mod:7
> . LOCKED.
> Transponders: 1/68
> scanMode=1
> parseMGT called for 0x1ffb 0xc7
>
> Invalid section length or timeout: pid=8187
>
> Could not find MGT in stream.  Cannot continue
> Frontend closed
> Using DVB device 0:0 "LG 3304"
> tuning ATSC to 63028000
> inv:2 mod:7
> ..................................................
>
> Not able to lock to the signal on the given frequency
> Frontend closed
> dvbsi: Cant tune DVB
> Using DVB device 0:0 "LG 3304"
> tuning ATSC to 69028000
> inv:2 mod:7
> ..................................................
>
> Not able to lock to the signal on the given frequency
> Frontend closed
> dvbsi: Cant tune DVB
> Using DVB device 0:0 "LG 3304"
> tuning ATSC to 79028000
> inv:2 mod:7
> ..................................................
>
> Not able to lock to the signal on the given frequency
> Frontend closed
> dvbsi: Cant tune DVB
> Using DVB device 0:0 "LG 3304"
> tuning ATSC to 85028000
> inv:2 mod:7
> ..............................................
> Invalid section length or timeout: pid=16
>
> ....
>
> Not able to lock to the signal on the given frequency
> Frontend closed
> dvbsi: Cant tune DVB
>


It seems the first tuning operation succeeds in getting a lock but then
times out and then all the rest fail. I am not sure what is next but I think
this may be related to firmware, or to me not loading all required modules.
If anybody has a helpful clue, I would appreciate it. I am running OpenSuse
11.1 32 bit.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
