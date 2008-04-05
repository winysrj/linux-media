Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n10.bullet.re3.yahoo.com ([68.142.237.123])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <aldebx@yahoo.fr>) id 1Ji9mp-0007Z5-Cb
	for linux-dvb@linuxtv.org; Sat, 05 Apr 2008 16:54:34 +0200
Message-ID: <47F79267.7060307@yahoo.fr>
Date: Sat, 05 Apr 2008 16:53:27 +0200
From: aldebaran <aldebx@yahoo.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] cx23885 and Xc3028 frontend type (ATSC) is not
 compatible with requested tuning type (OFDM)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0017455915=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0017455915==
Content-Type: multipart/alternative;
 boundary="------------060901000308060002030807"

This is a multi-part message in MIME format.
--------------060901000308060002030807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear linux-dvb developers,
I own an HP rebranded Hauppauge Express Card shipped with several HP 
laptops.
I know you recently added support for this device, however I cannot 
manage to make it work.
Specifically I cannot use the 'scan' utility to generate a channels.conf 
file usable with me-tv, thus I cannot use the tuner.
I had the same outcomes either with v4l-dvb and patched cx23885 drivers.
Thank you for your support!

here is the output of this tool:

    scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/fr-Paris
    using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
    initial transponder 810000000 0 2 1 3 1 0 0
    initial transponder 730000000 0 2 1 3 1 0 0
    initial transponder 626000000 0 2 1 3 1 0 0
    WARNING: frontend type (ATSC) is not compatible with requested
    tuning type (OFDM)
    WARNING: frontend type (ATSC) is not compatible with requested
    tuning type (OFDM)
    WARNING: frontend type (ATSC) is not compatible with requested
    tuning type (OFDM)
    ERROR: initial tuning failed
    dumping lists (0 services)
    Done.

here are my card specs:
HP Hauppauge WinTv 885
model 77001 rev d4c0 (Model 77xxx Analog/ATSC Hybrid, Xc3028)
tuner: Xceive xc3028 http://www.xceive.com/technology_XC3028.htm
audio tuner: stereo cx23885
decoder: cx23885 http://www.conexant.com/products/entry.jsp?id=393

The card seems correctly recognised, here is my dmesg output:

    [   34.715408] cx23885 driver version 0.0.1 loaded
    [   34.715478] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level,
    low) -> IRQ 17
    [   34.715495] CORE cx23885[0]: subsystem: 0070:7717, board:
    Hauppauge WinTV-HVR1500 [card=6,autodetected]
    [   34.717889] uvcvideo: disagrees about version of symbol video_devdata
    [   34.717891] uvcvideo: Unknown symbol video_devdata
    [   34.718209] uvcvideo: disagrees about version of symbol
    video_unregister_device
    [   34.718211] uvcvideo: Unknown symbol video_unregister_device
    [   34.718311] uvcvideo: disagrees about version of symbol
    video_device_alloc
    [   34.718313] uvcvideo: Unknown symbol video_device_alloc
    [   34.718380] uvcvideo: disagrees about version of symbol
    video_register_device
    [   34.718382] uvcvideo: Unknown symbol video_register_device
    [   34.718581] uvcvideo: disagrees about version of symbol
    video_device_release
    [   34.718582] uvcvideo: Unknown symbol video_device_release
    [   34.814851] iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver
    for Linux, 1.2.25
    [   34.814854] iwl4965: Copyright(c) 2003-2007 Intel Corporation
    [   34.826010] cx23885[0]: i2c bus 0 registered
    [   34.826027] cx23885[0]: i2c bus 1 registered
    [   34.826041] cx23885[0]: i2c bus 2 registered
    [   34.853553] tveeprom 0-0050: Hauppauge model 77001, rev D4C0,
    serial #68766589
    [   34.853556] tveeprom 0-0050: MAC address is 00-0D-FE-23-A3-DB
    [   34.853558] tveeprom 0-0050: tuner model is Xceive XC3028 (idx
    120, type 71)
    [   34.853561] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB
    Digital (eeprom 0x88)
    [   34.853563] tveeprom 0-0050: audio processor is CX23885 (idx 39)
    [   34.853565] tveeprom 0-0050: decoder processor is CX23885 (idx 33)
    [   34.853567] tveeprom 0-0050: has no radio, has no IR receiver,
    has no IR transmitter
    [   34.853569] cx23885[0]: hauppauge eeprom: model=77001
    [   34.853571] cx23885[0]: cx23885 based dvb card
    [   34.980916] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
    [   34.980921] DVB: registering new adapter (cx23885[0])
    [   34.980924] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB
    Frontend)...
    [   34.981111] cx23885_dev_checkrevision() Hardware revision = 0xb0
    [   34.981120] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 17,
    latency: 0, mmio: 0xbc000000
    [   34.981128] PCI: Setting latency timer of device 0000:04:00.0 to 64


--------------060901000308060002030807
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ccccff" text="#000000">
Dear linux-dvb developers, <br>
I own an HP rebranded Hauppauge Express Card shipped with several HP
laptops.<br>
I know you recently added support for this device, however I cannot
manage to make it work.<br>
Specifically I cannot use the 'scan' utility to generate a
channels.conf file usable with me-tv, thus I cannot use the tuner.<br>
I had the same outcomes either with v4l-dvb and patched cx23885 drivers.<br>
Thank you for your support!<br>
<br>
here is the output of this tool:<br>
<blockquote>scanning
/usr/share/doc/dvb-utils/examples/scan/dvb-t/fr-Paris<br>
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'<br>
initial transponder 810000000 0 2 1 3 1 0 0<br>
initial transponder 730000000 0 2 1 3 1 0 0<br>
initial transponder 626000000 0 2 1 3 1 0 0<br>
WARNING: frontend type (ATSC) is not compatible with requested tuning
type (OFDM)<br>
WARNING: frontend type (ATSC) is not compatible with requested tuning
type (OFDM)<br>
WARNING: frontend type (ATSC) is not compatible with requested tuning
type (OFDM)<br>
ERROR: initial tuning failed<br>
dumping lists (0 services)<br>
Done.<br>
</blockquote>
here are my card specs: <br>
HP Hauppauge WinTv 885<br>
model 77001 rev d4c0 (Model 77xxx Analog/ATSC Hybrid, Xc3028)<br>
tuner: Xceive xc3028 <a class="moz-txt-link-freetext" href="http://www.xceive.com/technology_XC3028.htm">http://www.xceive.com/technology_XC3028.htm</a><br>
audio tuner: stereo cx23885<br>
decoder: cx23885 <a class="moz-txt-link-freetext" href="http://www.conexant.com/products/entry.jsp?id=393">http://www.conexant.com/products/entry.jsp?id=393</a><br>
<br>
The card seems correctly recognised, here is my dmesg output:<br>
<blockquote>[&nbsp;&nbsp; 34.715408] cx23885 driver version 0.0.1 loaded<br>
[&nbsp;&nbsp; 34.715478] ACPI: PCI Interrupt 0000:04:00.0[A] -&gt; GSI 17 (level,
low) -&gt; IRQ 17<br>
[&nbsp;&nbsp; 34.715495] CORE cx23885[0]: subsystem: 0070:7717, board: Hauppauge
WinTV-HVR1500 [card=6,autodetected]<br>
[&nbsp;&nbsp; 34.717889] uvcvideo: disagrees about version of symbol video_devdata<br>
[&nbsp;&nbsp; 34.717891] uvcvideo: Unknown symbol video_devdata<br>
[&nbsp;&nbsp; 34.718209] uvcvideo: disagrees about version of symbol
video_unregister_device<br>
[&nbsp;&nbsp; 34.718211] uvcvideo: Unknown symbol video_unregister_device<br>
[&nbsp;&nbsp; 34.718311] uvcvideo: disagrees about version of symbol
video_device_alloc<br>
[&nbsp;&nbsp; 34.718313] uvcvideo: Unknown symbol video_device_alloc<br>
[&nbsp;&nbsp; 34.718380] uvcvideo: disagrees about version of symbol
video_register_device<br>
[&nbsp;&nbsp; 34.718382] uvcvideo: Unknown symbol video_register_device<br>
[&nbsp;&nbsp; 34.718581] uvcvideo: disagrees about version of symbol
video_device_release<br>
[&nbsp;&nbsp; 34.718582] uvcvideo: Unknown symbol video_device_release<br>
[&nbsp;&nbsp; 34.814851] iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for
Linux, 1.2.25<br>
[&nbsp;&nbsp; 34.814854] iwl4965: Copyright(c) 2003-2007 Intel Corporation<br>
[&nbsp;&nbsp; 34.826010] cx23885[0]: i2c bus 0 registered<br>
[&nbsp;&nbsp; 34.826027] cx23885[0]: i2c bus 1 registered<br>
[&nbsp;&nbsp; 34.826041] cx23885[0]: i2c bus 2 registered<br>
[&nbsp;&nbsp; 34.853553] tveeprom 0-0050: Hauppauge model 77001, rev D4C0, serial
#68766589<br>
[&nbsp;&nbsp; 34.853556] tveeprom 0-0050: MAC address is 00-0D-FE-23-A3-DB<br>
[&nbsp;&nbsp; 34.853558] tveeprom 0-0050: tuner model is Xceive XC3028 (idx 120,
type 71)<br>
[&nbsp;&nbsp; 34.853561] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)<br>
[&nbsp;&nbsp; 34.853563] tveeprom 0-0050: audio processor is CX23885 (idx 39)<br>
[&nbsp;&nbsp; 34.853565] tveeprom 0-0050: decoder processor is CX23885 (idx 33)<br>
[&nbsp;&nbsp; 34.853567] tveeprom 0-0050: has no radio, has no IR receiver, has
no IR transmitter<br>
[&nbsp;&nbsp; 34.853569] cx23885[0]: hauppauge eeprom: model=77001<br>
[&nbsp;&nbsp; 34.853571] cx23885[0]: cx23885 based dvb card<br>
[&nbsp;&nbsp; 34.980916] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner<br>
[&nbsp;&nbsp; 34.980921] DVB: registering new adapter (cx23885[0])<br>
[&nbsp;&nbsp; 34.980924] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB
Frontend)...<br>
[&nbsp;&nbsp; 34.981111] cx23885_dev_checkrevision() Hardware revision = 0xb0<br>
[&nbsp;&nbsp; 34.981120] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 17,
latency: 0, mmio: 0xbc000000<br>
[&nbsp;&nbsp; 34.981128] PCI: Setting latency timer of device 0000:04:00.0 to 64<br>
  <br>
</blockquote>
</body>
</html>

--------------060901000308060002030807--



--===============0017455915==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0017455915==--
