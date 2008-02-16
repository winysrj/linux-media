Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from neuf-infra-smtp-out-sp604003av.neufgp.fr ([84.96.92.124])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <guillaume.gardet@free.fr>) id 1JQSSp-0007bF-Hr
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 20:12:43 +0100
Message-ID: <47B7358C.6080702@free.fr>
Date: Sat, 16 Feb 2008 20:12:12 +0100
From: Guillaume Gardet <guillaume.gardet@free.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem with DVB-T T328B4 (af9016)
Reply-To: guillaume.gardet@free.fr
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1459344295=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1459344295==
Content-Type: multipart/alternative;
 boundary="------------040003080109070404010702"

This is a multi-part message in MIME format.
--------------040003080109070404010702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I followed the wiki and install all correctly but the scan (scan 
/usr/share/dvb/dvb-t/fr-Lyon-Pilat) output is :

scanning /usr/share/dvb/dvb-t/fr-Lyon-Pilat

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

initial transponder 666000000 0 2 9 3 1 0 0

initial transponder 594000000 0 2 9 3 1 0 0

initial transponder 618000000 0 2 9 3 1 0 0

initial transponder 738000000 0 2 9 3 1 0 0

initial transponder 642000000 0 2 9 3 1 0 0

initial transponder 682000000 0 2 9 3 1 0 0

 >>> tune to: 
666000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE

WARNING: filter timeout pid 0x0011

WARNING: filter timeout pid 0x0000

WARNING: filter timeout pid 0x0010

 >>> tune to: 
594000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE

WARNING: filter timeout pid 0x0011

WARNING: filter timeout pid 0x0000

WARNING: filter timeout pid 0x0010

 >>> tune to: 
618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE

WARNING: filter timeout pid 0x0011

WARNING: filter timeout pid 0x0000

WARNING: filter timeout pid 0x0010

 >>> tune to: 
738000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE

WARNING: filter timeout pid 0x0011

WARNING: filter timeout pid 0x0000

WARNING: filter timeout pid 0x0010

 >>> tune to: 
642000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE

WARNING: filter timeout pid 0x0011

WARNING: filter timeout pid 0x0000

WARNING: filter timeout pid 0x0010

 >>> tune to: 
682000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE

WARNING: filter timeout pid 0x0011

WARNING: filter timeout pid 0x0000

WARNING: filter timeout pid 0x0010

dumping lists (0 services)

Done.




dmesg output :
    usb 3-1: new high speed USB device using ehci_hcd and address 6

    usb 3-1: new device found, idVendor=15a4, idProduct=9016

    usb 3-1: new device strings: Mfr=1, Product=2, SerialNumber=3

    usb 3-1: Product: DVB-T 2

    usb 3-1: Manufacturer: Geniatech

    usb 3-1: SerialNumber: 010101010600001

    usb 3-1: configuration #1 chosen from 1 choice

    dvb-usb: found a 'Afatech USB2.0 DVB-T Recevier' in warm state.

    dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.

    DVB: registering new adapter (Afatech USB2.0 DVB-T Recevier)

    DVB: registering frontend 0 (AF901X USB DVB-T)...

    dvb-usb: Afatech USB2.0 DVB-T Recevier successfully initialized and 
connected.

    input: Geniatech DVB-T 2 as /class/input/input9

    input: USB HID v1.01 Keyboard [Geniatech DVB-T 2] on usb-0000:00:10.3-1


lsmod | grep dvb output :

    dvb_usb_af9015         56544  4294967292
    dvb_usb                24716  1 dvb_usb_af9015
    dvb_core               78376  1 dvb_usb
    firmware_class         13568  1 dvb_usb
    i2c_core               27520  3 nvidia,dvb_usb,i2c_viapro
    usbcore               124268  8 
snd_usb_audio,dvb_usb_af9015,dvb_usb,snd_usb_lib,usbhid,ehci_hcd,uhci_hcd

The installed firmware is : 
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/
I am running the opensuse 10.3 with the 2.6.22.17-0.1-default kernel.

Any idea ?

Guillaume


--------------040003080109070404010702
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
I followed the wiki and install all correctly but the scan (scan
/usr/share/dvb/dvb-t/fr-Lyon-Pilat) output is :<br>
<address><br>
scanning /usr/share/dvb/dvb-t/fr-Lyon-Pilat</address>
<address>using '/dev/dvb/adapter0/frontend0' and
'/dev/dvb/adapter0/demux0'</address>
<address>initial transponder 666000000 0 2 9 3 1 0 0</address>
<address>initial transponder 594000000 0 2 9 3 1 0 0</address>
<address>initial transponder 618000000 0 2 9 3 1 0 0</address>
<address>initial transponder 738000000 0 2 9 3 1 0 0</address>
<address>initial transponder 642000000 0 2 9 3 1 0 0</address>
<address>initial transponder 682000000 0 2 9 3 1 0 0</address>
<address>&gt;&gt;&gt;
tune to:
666000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE</address>
<address>WARNING: filter timeout pid 0x0011</address>
<address>WARNING: filter timeout pid 0x0000</address>
<address>WARNING: filter timeout pid 0x0010</address>
<address>&gt;&gt;&gt;
tune to:
594000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE</address>
<address>WARNING: filter timeout pid 0x0011</address>
<address>WARNING: filter timeout pid 0x0000</address>
<address>WARNING: filter timeout pid 0x0010</address>
<address>&gt;&gt;&gt;
tune to:
618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE</address>
<address>WARNING: filter timeout pid 0x0011</address>
<address>WARNING: filter timeout pid 0x0000</address>
<address>WARNING: filter timeout pid 0x0010</address>
<address>&gt;&gt;&gt;
tune to:
738000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE</address>
<address>WARNING: filter timeout pid 0x0011</address>
<address>WARNING: filter timeout pid 0x0000</address>
<address>WARNING: filter timeout pid 0x0010</address>
<address>&gt;&gt;&gt;
tune to:
642000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE</address>
<address>WARNING: filter timeout pid 0x0011</address>
<address>WARNING: filter timeout pid 0x0000</address>
<address>WARNING: filter timeout pid 0x0010</address>
<address>&gt;&gt;&gt;
tune to:
682000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE</address>
<address>WARNING: filter timeout pid 0x0011</address>
<address>WARNING: filter timeout pid 0x0000</address>
<address>WARNING: filter timeout pid 0x0010</address>
<address>dumping lists (0 services)</address>
<address>Done.</address>
<br>
<br>
<br>
dmesg output :<br>
<address>&nbsp;&nbsp;&nbsp; usb 3-1: new high speed USB device using ehci_hcd and
address 6</address>
<address>&nbsp;&nbsp;&nbsp; usb 3-1: new device found, idVendor=15a4, idProduct=9016</address>
<address>&nbsp;&nbsp;&nbsp; usb 3-1: new device strings: Mfr=1, Product=2,
SerialNumber=3</address>
<address>&nbsp;&nbsp;&nbsp; usb 3-1: Product: DVB-T 2</address>
<address>&nbsp;&nbsp;&nbsp; usb 3-1: Manufacturer: Geniatech</address>
<address>&nbsp;&nbsp;&nbsp; usb 3-1: SerialNumber: 010101010600001</address>
<address>&nbsp;&nbsp;&nbsp; usb 3-1: configuration #1 chosen from 1 choice</address>
<address>&nbsp;&nbsp;&nbsp; dvb-usb: found a 'Afatech USB2.0 DVB-T Recevier' in warm
state.</address>
<address>&nbsp;&nbsp;&nbsp; dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.</address>
<address>&nbsp;&nbsp;&nbsp; DVB: registering new adapter (Afatech USB2.0 DVB-T
Recevier)</address>
<address>&nbsp;&nbsp;&nbsp; DVB: registering frontend 0 (AF901X USB DVB-T)...</address>
<address>&nbsp;&nbsp;&nbsp; dvb-usb: Afatech USB2.0 DVB-T Recevier successfully
initialized and connected.</address>
<address>&nbsp;&nbsp;&nbsp; input: Geniatech DVB-T 2 as /class/input/input9</address>
<address>&nbsp;&nbsp;&nbsp; input: USB HID v1.01 Keyboard [Geniatech DVB-T 2] on
usb-0000:00:10.3-1<br>
<br>
<br>
lsmod | grep dvb output :<br>
<br>
&nbsp;&nbsp;&nbsp; dvb_usb_af9015&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 56544&nbsp;&nbsp;4294967292<br>
&nbsp;&nbsp;&nbsp; dvb_usb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;24716&nbsp;&nbsp;1 dvb_usb_af9015<br>
&nbsp;&nbsp;&nbsp; dvb_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 78376&nbsp;&nbsp;1 dvb_usb<br>
&nbsp;&nbsp;&nbsp; firmware_class&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 13568&nbsp;&nbsp;1 dvb_usb<br>
&nbsp;&nbsp;&nbsp; i2c_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 27520&nbsp;&nbsp;3 nvidia,dvb_usb,i2c_viapro<br>
&nbsp;&nbsp;&nbsp; usbcore&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 124268&nbsp;&nbsp;8
snd_usb_audio,dvb_usb_af9015,dvb_usb,snd_usb_lib,usbhid,ehci_hcd,uhci_hcd<br>
<br>
The installed firmware is :
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/<br>
I am running the opensuse 10.3 with the 2.6.22.17-0.1-default kernel.<br>
<br>
Any idea ?<br>
<br>
Guillaume</address>
</body>
</html>

--------------040003080109070404010702--


--===============1459344295==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1459344295==--
