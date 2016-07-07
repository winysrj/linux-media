Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx8.det.wa.edu.au ([203.14.52.24]:65231 "EHLO mx8.det.wa.edu.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219AbcGGIZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 04:25:18 -0400
From: "DE GROOT Peter [Eastern Goldfields College]"
	<peter.de.groot@education.wa.edu.au>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: DigitalNow TinyTwin DVB-T Receiver V2 -  problems
Date: Thu, 7 Jul 2016 08:21:20 +0000
Message-ID: <b2384ad99ab94d2a8e462be720b62f18@E7359SVIN1361.resources.internal>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi,

Newb linux dvb here.  I have been battling with this for days, and hoping for some pointers...

Brand new fresh install of Mythbuntu   16.06

DigitalNow TinyTwin DVB-T Receiver V2  which used to work  on a windows box.



checking this page .. should be supported  https://www.linuxtv.org/wiki/index.php/DigitalNow_TinyTwin_DVB-T_Receiver

Was missing the firmware file..   downloaded as per the link. 

FWIW... had to power off the machine and restart to get it to load the firmware..  A straight reboot did not seem to work.

Anyway... it seems to be connecting.

BUT... when I do a w_scan it  appears that it cannot detect some of channels....  205625  (ABC Australia) for a good example..  says it get a good signal,.. but no joy.
Should be at least 4 channels..

In previous efforts... I managed to get some sort of picture using me.tv which seemed to have better luck in detecting some channels... but the frequency
appeared to be wrong..  and the picture was all blocky ..

Some stuff below...

I do get the /dev/dvb files.  Reference to  9013 ??  The lsusb does not seem to be the same id as the doc....

Please help.

Regards
Peter

dmesg


[   16.721560] usb 1-5: dvb_usb_v2: found a 'Afatech AF9015 reference design' in cold state
[   16.902088] usb 1-5: dvb_usb_v2: downloading firmware from file 'dvb-usb-af9015.fw'
[   16.968052] usb 1-5: dvb_usb_v2: found a 'Afatech AF9015 reference design' in warm state
[   17.117093] Adding 3930108k swap on /dev/sda5.  Priority:-1 extents:1 across:3930108k FS
[   17.368573] usb 1-5: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[   17.368615] DVB: registering new adapter (Afatech AF9015 reference design)
[   18.896033] i2c i2c-7: af9013: firmware version 4.95.0.0
[   18.898031] usb 1-5: DVB: registering adapter 0 frontend 0 (Afatech AF9013)...
[   18.926663] MXL5005S: Attached at address 0xc6
[   18.926673] usb 1-5: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[   18.926710] DVB: registering new adapter (Afatech AF9015 reference design)
[   19.641888] i2c i2c-7: af9013: found a 'Afatech AF9013' in warm state
[   19.645353] i2c i2c-7: af9013: firmware version 4.95.0.0
[   19.651762] usb 1-5: DVB: registering adapter 1 frontend 0 (Afatech AF9013)...
[   19.651913] MXL5005S: Attached at address 0xc6
[   19.659352] Registered IR keymap rc-empty
[   19.659456] input: Afatech AF9015 reference design as /devices/pci0000:00/0000:00:12.2/usb1/1-5/rc/rc0/input16
[   19.660245] rc0: Afatech AF9015 reference design as /devices/pci0000:00/0000:00:12.2/usb1/1-5/rc/rc0
[   19.660251] usb 1-5: dvb_usb_v2: schedule remote query interval to 500 msecs
[   19.660257] usb 1-5: dvb_usb_v2: 'Afatech AF9015 reference design' successfully initialized and connected
[   19.660295] usbcore: registered new interface driver dvb_usb_af9015
[   19.903283] IPv6: ADDRCONF(NETDEV_UP): enp2s0: link is not ready
[   19.914357] r8169 0000:02:00.0 enp2s0: link down
[   19.914368] r8169 0000:02:00.0 enp2s0: link down
[   19.914420] IPv6: ADDRCONF(NETDEV_UP): enp2s0: link is not ready
[   21.825119] r8169 0000:02:00.0 enp2s0: link up
[   21.825133] IPv6: ADDRCONF(NETDEV_CHANGE): enp2s0: link becomes ready

lsusb  ...................................

root@egc-tv3:/dev/dvb/adapter0# lsusb
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 003: ID 15a4:9015 Afatech Technologies, Inc. AF9015 DVB-T USB2.0 stick
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 003: ID 0461:4e04 Primax Electronics, Ltd
Bus 004 Device 002: ID 17ef:6019 Lenovo
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub


lsmod  .............................

dvb_core              122880  1 dvb_usb_v2
dvb_usb_af9015         32768  0
dvb_usb_v2             36864  1 dvb_usb_af9015



 w_scan -c au
w_scan -c au
w_scan version 20141122 (compiled for DVB API 5.10)
using settings for AUSTRALIA
DVB aerial
DVB-T AU
scan type TERRESTRIAL, channellist 3
output format vdr-2.0
WARNING: could not guess your codepage. Falling back to 'UTF-8'
output charset 'UTF-8', use -C <charset> to override
Info: using DVB adapter auto detection.
        /dev/dvb/adapter0/frontend0 -> TERRESTRIAL "Afatech AF9013": good :-)
        /dev/dvb/adapter1/frontend0 -> TERRESTRIAL "Afatech AF9013": good :-)
Using TERRESTRIAL frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.10
frontend 'Afatech AF9013' supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
FREQ (174.00MHz ... 860.00MHz)
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
Scanning DVB-T...
Scanning 7MHz frequencies...
177500: (time: 00:00.476)
177625: (time: 00:02.524)
184500: (time: 00:04.540)         signal ok:    QAM_AUTO f = 184500 kHz I999B7C999D999T999G999Y999 (0:0:0)
        QAM_AUTO f = 184500 kHz I999B7C999D999T999G999Y999 (0:0:0) : updating transport_stream_id: -> (0:0:928)
        QAM_AUTO f = 184500 kHz I999B7C999D999T999G999Y999 (0:0:928) : updating network_id -> (0:12802:928)
        QAM_AUTO f = 184500 kHz I999B7C999D999T999G999Y999 (0:12802:928) : updating original_network_id -> (12802:12802:928)
        updating transponder:
           (QAM_AUTO f = 184500 kHz I999B7C999D999T999G999Y999 (12802:12802:928)) 0x0000
        to (QAM_64   f = 184500 kHz I999B7C34D0T8G16Y0 (12802:12802:928)) 0x405A
184625: skipped (already known transponder)
191500: (time: 00:09.548)
191625: (time: 00:11.560)
198500: (time: 00:13.576)         signal ok:    QAM_AUTO f = 198500 kHz I999B7C999D999T999G999Y999 (0:0:0)
        QAM_AUTO f = 198500 kHz I999B7C999D999T999G999Y999 (0:0:0) : updating transport_stream_id: -> (0:0:2560)
        QAM_AUTO f = 198500 kHz I999B7C999D999T999G999Y999 (0:0:2560) : updating network_id -> (0:12813:2560)
        QAM_AUTO f = 198500 kHz I999B7C999D999T999G999Y999 (0:12813:2560) : updating original_network_id -> (4123:12813:2560)
        updating transponder:
           (QAM_AUTO f = 198500 kHz I999B7C999D999T999G999Y999 (4123:12813:2560)) 0x0000
        to (QAM_64   f = 592500 kHz I999B7C34D0T8G16Y0 (4123:12813:2560)) 0x405A
198625: (time: 00:14.664)         signal ok:    QAM_AUTO f = 198625 kHz I999B7C999D999T999G999Y999 (0:0:0)
        QAM_AUTO f = 198625 kHz I999B7C999D999T999G999Y999 (0:0:0) : updating transport_stream_id: -> (0:0:2560)
        QAM_AUTO f = 198625 kHz I999B7C999D999T999G999Y999 (0:0:2560) : updating network_id -> (0:12813:2560)
205500: (time: 00:16.676)         signal ok:    QAM_AUTO f = 205500 kHz I999B7C999D999T999G999Y999 (0:0:0)
        QAM_AUTO f = 205500 kHz I999B7C999D999T999G999Y999 (0:0:0) : updating transport_stream_id: -> (0:0:611)
        QAM_AUTO f = 205500 kHz I999B7C999D999T999G999Y999 (0:0:611) : updating network_id -> (0:12886:611)
        QAM_AUTO f = 205500 kHz I999B7C999D999T999G999Y999 (0:12886:611) : updating original_network_id -> (4112:12886:611)
        updating transponder:
           (QAM_AUTO f = 205500 kHz I999B7C999D999T999G999Y999 (4112:12886:611)) 0x0000
        to (QAM_64   f = 226500 kHz I999B7C34D0T8G16Y0 (4112:12886:611)) 0x405A
205625: (time: 00:18.012)         signal ok:    QAM_AUTO f = 205625 kHz I999B7C999D999T999G999Y999 (0:0:0)
        QAM_AUTO f = 205625 kHz I999B7C999D999T999G999Y999 (0:0:0) : updating transport_stream_id: -> (0:0:611)
        QAM_AUTO f = 205625 kHz I999B7C999D999T999G999Y999 (0:0:611) : updating network_id -> (0:12886:611)
212500: (time: 00:27.508)         signal ok:    QAM_AUTO f = 212500 kHz I999B7C999D999T999G999Y999 (0:0:0)
        QAM_AUTO f = 212500 kHz I999B7C999D999T999G999Y999 (0:0:0) : updating transport_stream_id: -> (0:0:12923)
        QAM_AUTO f = 212500 kHz I999B7C999D999T999G999Y999 (0:0:12923) : updating network_id -> (0:12810:12923)
        QAM_AUTO f = 212500 kHz I999B7C999D999T999G999Y999 (0:12810:12923) : updating original_network_id -> (4117:12810:12923)
        updating transponder:
           (QAM_AUTO f = 212500 kHz I999B7C999D999T999G999Y999 (4117:12810:12923)) 0x0000
        to (QAM_64   f = 606500 kHz I999B7C34D0T8G16Y0 (4117:12810:12923)) 0x405A
212625: (time: 00:37.900)         signal ok:    QAM_AUTO f = 212625 kHz I999B7C999D999T999G999Y999 (0:0:0)
        QAM_AUTO f = 212625 kHz I999B7C999D999T999G999Y999 (0:0:0) : updating transport_stream_id: -> (0:0:12923)
        QAM_AUTO f = 212625 kHz I999B7C999D999T999G999Y999 (0:0:12923) : updating network_id -> (0:12810:12923)
219500: (time: 00:47.876)
219625: (time: 00:49.888)
226500: skipped (already known transponder)
226625: skipped (already known transponder)
480500: (time: 00:51.916)


tune to: QAM_64   f = 184500 kHz I999B7C34D0T8G16Y0 (12802:12802:928) (time: 04:01.592)
        service = SBS ONE (SBS)
        service = SBS HD (SBS)
        service = SBS TWO (SBS)
        service = Food Network (SBS)
        service = NITV (SBS)
        service = SBS Radio 1 (SBS)
        service = SBS Radio 2 (SBS)
        service = SBS Radio 3 (SBS)
        Info: no data from NIT(actual )after 13 seconds
tune to: QAM_64   f = 592500 kHz I999B7C34D0T8G16Y0 (4123:12813:2560) (time: 04:16.116)

----------no signal----------
tune to: QAM_AUTO f = 592500 kHz I999B7C999D0T999G999Y0 (4123:12813:2560) (time: 04:22.140)  (no signal)
----------no signal----------
tune to: QAM_64   f = 226500 kHz I999B7C34D0T8G16Y0 (4112:12886:611) (time: 04:28.164)
        QAM_64   f = 226500 kHz I999B7C34D0T8G16Y0 (4112:12886:611) : updating transport_stream_id: -> (4112:12886:2462)
        service = GWN7 (GWN7)
        service = 7TWO (GWN7)
        service = 7mate (GWN7)
        service = ishoptv (GWN7)
        service = RACING.COM (GWN)
        QAM_64   f = 226500 kHz I999B7C34D0T8G16Y0 (4112:12886:2462) : updating network_id -> (4112:12934:2462)
        QAM_64   f = 226500 kHz I999B7C34D0T8G16Y0 (4112:12934:2462) : updating original_network_id -> (12934:12934:2462)
tune to: QAM_64   f = 606500 kHz I999B7C34D0T8G16Y0 (4117:12810:12923) (time: 04:43.072)
----------no signal----------
tune to: QAM_AUTO f = 606500 kHz I999B7C999D0T999G999Y0 (4117:12810:12923) (time: 04:49.096)  (no signal)
----------no signal----------
(time: 04:55.124) dumping lists (13 services)
..
SBS ONE;SBS:184500:B7C34D0G16M64T8Y0:T:27500:161=2:81=eng@4:41:0:929:12802:928:0
SBS HD;SBS:184500:B7C34D0G16M64T8Y0:T:27500:102=2:103=eng@4:43:0:933:12802:928:0
SBS TWO;SBS:184500:B7C34D0G16M64T8Y0:T:27500:162=2:83=eng@4:42:0:930:12802:928:0
Food Network;SBS:184500:B7C34D0G16M64T8Y0:T:27500:163=2:85=eng@4:44:0:931:12802:928:0
NITV;SBS:184500:B7C34D0G16M64T8Y0:T:27500:164=2:87=eng@4:45:0:932:12802:928:0
SBS Radio 1;SBS:184500:B7C34D0G16M64T8Y0:T:27500:0:201=eng@4:0:0:942:12802:928:0
SBS Radio 2;SBS:184500:B7C34D0G16M64T8Y0:T:27500:0:202=eng@4:0:0:943:12802:928:0
SBS Radio 3;SBS:184500:B7C34D0G16M64T8Y0:T:27500:0:203=eng@4:0:0:944:12802:928:0
GWN7;GWN7:226500:B7C34D0G16M64T8Y0:T:27500:2910=2:2911=eng@4:2915:0:2391:12934:2462:0
7TWO;GWN7:226500:B7C34D0G16M64T8Y0:T:27500:4620=2:4621=eng@4:4625:0:2402:12934:2462:0
7mate;GWN7:226500:B7C34D0G16M64T8Y0:T:27500:4630=2:0;4632:4635:0:2403:12934:2462:0
RACING.COM;GWN:226500:B7C34D0G16M64T8Y0:T:27500:4680=2:4681=eng@3:0:0:2408:12934:2462:0
ishoptv;GWN7:226500:B7C34D0G16M64T8Y0:T:27500:4650=2:4651=eng@3:0:0:2405:12934:2462:0

Peter de Groot | SBNA |Eastern Goldfields College | Ph : 90801800  Mob: 0418915312


