Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:38139 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbZC3U6p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 16:58:45 -0400
Received: by ewy9 with SMTP id 9so2270326ewy.37
        for <linux-media@vger.kernel.org>; Mon, 30 Mar 2009 13:58:42 -0700 (PDT)
Message-ID: <49D13272.7050906@laposte.net>
Date: Mon, 30 Mar 2009 22:58:26 +0200
From: Thomas RENARD <threnard@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Olivier MENUEL <omenuel@laposte.net>,
	Laurent Haond <lhaond@bearstech.com>,
	linux-media@vger.kernel.org, Thomas RENARD <threnard@gmail.com>,
	Karsten Blumenau <info@blume-online.de>,
	pHilipp Zabel <philipp.zabel@gmail.com>,
	=?ISO-8859-1?Q?Martin_M=FClle?= =?ISO-8859-1?Q?r?=
	<mueller1977@web.de>
Subject: Re: AverMedia Volar Black HD (A850)
References: <200903291334.00879.olivier.menuel@free.fr> <200903292015.49152.omenuel@laposte.net> <49D11189.1010705@iki.fi> <200903302139.09809.omenuel@laposte.net> <49D1287C.5010803@iki.fi>
In-Reply-To: <49D1287C.5010803@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I try http://linuxtv.org/hg/~anttip/af9015_aver_a850/.

Here is my /var/log/messages :
Mar 30 22:27:57 trubuntu kernel: [ 5020.136029] usb 3-6: new high speed 
USB device using ehci_hcd and address 3
Mar 30 22:27:57 trubuntu kernel: [ 5020.277506] usb 3-6: configuration 
#1 chosen from 1 choice
Mar 30 22:27:58 trubuntu kernel: [ 5020.693808] af9015_usb_probe: 
interface:0
Mar 30 22:27:58 trubuntu kernel: [ 5020.695742] af9015_read_config: IR 
mode:0
Mar 30 22:27:58 trubuntu kernel: [ 5020.697752] af9015_read_config: TS 
mode:1
Mar 30 22:27:58 trubuntu kernel: [ 5020.701256] af9015_read_config: [0] 
xtal:2 set adc_clock:28000
Mar 30 22:27:58 trubuntu kernel: [ 5020.704341] af9015_read_config: [0] 
IF1:36125
Mar 30 22:27:58 trubuntu kernel: [ 5020.707708] af9015_read_config: [0] 
MT2060 IF1:0
Mar 30 22:27:58 trubuntu kernel: [ 5020.709583] af9015_read_config: [0] 
tuner id:13
Mar 30 22:27:58 trubuntu kernel: [ 5020.711459] af9015_read_config: [1] 
xtal:2 set adc_clock:28000
Mar 30 22:27:58 trubuntu kernel: [ 5020.714830] af9015_read_config: [1] 
IF1:36125
Mar 30 22:27:58 trubuntu kernel: [ 5020.718084] af9015_read_config: [1] 
MT2060 IF1:1220
Mar 30 22:27:58 trubuntu kernel: [ 5020.719957] af9015_read_config: [1] 
tuner id:130
Mar 30 22:27:58 trubuntu kernel: [ 5020.719962] af9015_read_config: ugly 
and broken AverMedia A850 device detected, will hack configuration...
Mar 30 22:27:58 trubuntu kernel: [ 5020.721706] af9015_identify_state: 
reply:01
Mar 30 22:27:58 trubuntu kernel: [ 5020.721711] dvb-usb: found a 
'AVerMedia A850' in cold state, will try to load a firmware
Mar 30 22:27:58 trubuntu kernel: [ 5020.721715] firmware: requesting 
dvb-usb-af9015.fw
Mar 30 22:27:58 trubuntu kernel: [ 5020.777040] dvb-usb: downloading 
firmware from file 'dvb-usb-af9015.fw'
Mar 30 22:27:58 trubuntu kernel: [ 5020.777051] af9015_download_firmware:
Mar 30 22:27:58 trubuntu kernel: [ 5020.847585] dvb-usb: found a 
'AVerMedia A850' in warm state.
Mar 30 22:27:58 trubuntu kernel: [ 5020.849750] dvb-usb: will pass the 
complete MPEG2 transport stream to the software demuxer.
Mar 30 22:27:58 trubuntu kernel: [ 5020.852368] DVB: registering new 
adapter (AVerMedia A850)
Mar 30 22:27:58 trubuntu kernel: [ 5020.853615] 
af9015_af9013_frontend_attach: init I2C
Mar 30 22:27:58 trubuntu kernel: [ 5020.853626] af9015_i2c_init:
Mar 30 22:27:58 trubuntu kernel: [ 5020.889200] 00: 2c 83 a3 0b 00 00 00 
00 ca 07 0a 85 01 01 01 02
Mar 30 22:27:58 trubuntu kernel: [ 5020.913427] 10: 03 80 00 fa fa 10 40 
ef 00 30 31 30 31 30 37 30
Mar 30 22:27:58 trubuntu kernel: [ 5020.959135] 20: 33 30 37 30 30 30 30 
31 ff ff ff ff ff ff ff ff
Mar 30 22:27:58 trubuntu kernel: [ 5020.987860] 30: 01 01 38 01 00 08 02 
01 1d 8d 00 00 0d ff ff ff
Mar 30 22:27:58 trubuntu kernel: [ 5021.051391] 40: ff ff ff ff ff 08 02 
00 1d 8d c4 04 82 ff ff ff
Mar 30 22:27:58 trubuntu kernel: [ 5021.092053] 50: ff ff ff ff ff 26 00 
00 04 03 09 04 14 03 41 00
Mar 30 22:27:58 trubuntu kernel: [ 5021.125472] 60: 56 00 65 00 72 00 4d 
00 65 00 64 00 69 00 61 00
Mar 30 22:27:58 trubuntu kernel: [ 5021.169028] 70: 14 03 41 00 38 00 35 
00 30 00 20 00 44 00 56 00
Mar 30 22:27:58 trubuntu kernel: [ 5021.235275] 80: 42 00 54 00 20 03 33 
00 30 00 31 00 34 00 37 00
Mar 30 22:27:58 trubuntu kernel: [ 5021.260035] 90: 35 00 32 00 30 00 31 
00 30 00 33 00 32 00 30 00
Mar 30 22:27:58 trubuntu kernel: [ 5021.284759] a0: 30 00 30 00 00 ff ff 
ff ff ff ff ff ff ff ff ff
Mar 30 22:27:58 trubuntu kernel: [ 5021.316493] b0: ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff ff
Mar 30 22:27:58 trubuntu kernel: [ 5021.339978] c0: ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff ff
Mar 30 22:27:58 trubuntu kernel: [ 5021.362849] d0: ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff ff
Mar 30 22:27:58 trubuntu kernel: [ 5021.385971] e0: ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff ff
Mar 30 22:27:58 trubuntu kernel: [ 5021.408985] f0: ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff ff
Mar 30 22:27:58 trubuntu kernel: [ 5021.441584] af9013: firmware 
version:4.95.0
Mar 30 22:27:58 trubuntu kernel: [ 5021.446464] DVB: registering adapter 
0 frontend 0 (Afatech AF9013 DVB-T)...
Mar 30 22:27:58 trubuntu kernel: [ 5021.447354] af9015_tuner_attach:
Mar 30 22:27:58 trubuntu kernel: [ 5021.527526] MXL5005S: Attached at 
address 0xc6
Mar 30 22:27:58 trubuntu kernel: [ 5021.527536] dvb-usb: AVerMedia A850 
successfully initialized and connected.
Mar 30 22:27:58 trubuntu kernel: [ 5021.527540] af9015_init:
Mar 30 22:27:58 trubuntu kernel: [ 5021.527542] af9015_init_endpoint: 
USB speed:3
Mar 30 22:27:58 trubuntu kernel: [ 5021.537693] af9015_download_ir_table:
Mar 30 22:27:58 trubuntu kernel: [ 5021.538262] usbcore: registered new 
interface driver dvb_usb_af9015
Mar 30 22:36:09 trubuntu kernel: [ 5512.208930] af9015_pid_filter_ctrl: 
onoff:0
Mar 30 22:36:09 trubuntu kernel: [ 5512.363024] af9015_pid_filter_ctrl: 
onoff:0
Mar 30 22:36:09 trubuntu kernel: [ 5512.472992] af9015_pid_filter_ctrl: 
onoff:0
Mar 30 22:36:10 trubuntu kernel: [ 5512.660525] af9015_pid_filter_ctrl: 
onoff:0
Mar 30 22:36:10 trubuntu kernel: [ 5512.763080] af9015_pid_filter_ctrl: 
onoff:0
Mar 30 22:36:10 trubuntu kernel: [ 5512.977671] af9015_pid_filter_ctrl: 
onoff:0
...
I think I have "af9015_pid_filter_ctrl: onoff:0" when I run Kaffeine.

Here are some messages when I run then scan with Kaffeine :
..................................................

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "Afatech AF9013 DVB-T"
tuning DVB-T to 522000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...... LOCKED.
Transponders: 15/57
scanMode=0
it's dvb 2!
Reading SDT: pid=17
CANAL+: sid=769
CANAL+ CINEMA: sid=770
CANAL+ SPORT: sid=771
PLANETE: sid=772
CANAL J: sid=773
TPS STAR: sid=774
Unknown: sid=1008
Unknown: sid=1009
Reading PAT: pid=0
Reading PMT: pid=1280

DVB SUB on CANAL+ page_id: 1 anc_id: 2 lang: fra

Reading PMT: pid=1281

DVB SUB on CANAL+ CINEMA page_id: 1 anc_id: 2 lang: fra

Reading PMT: pid=1282

DVB SUB on CANAL+ SPORT page_id: 1 anc_id: 2 lang: fra

Reading PMT: pid=1283
Reading PMT: pid=1284
Reading PMT: pid=1285

DVB SUB on TPS STAR page_id: 1 anc_id: 2 lang: fra

Reading PMT: pid=1290
Reading PMT: pid=1291
Frontend closed
Using DVB device 0:0 "Afatech AF9013 DVB-T"
tuning DVB-T to 530000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
..................................................

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "Afatech AF9013 DVB-T"
tuning DVB-T to 538000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
..................................................

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "Afatech AF9013 DVB-T"
tuning DVB-T to 562000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
...... LOCKED.
Transponders: 20/57
scanMode=0
it's dvb 2!
Reading SDT: pid=17
TF1: sid=1537
NRJ12: sid=1538
Eurosport: sid=1540
LCI: sid=1539
TMC: sid=1542
TF6: sid=1541
Reading PAT: pid=0
Reading PMT: pid=100

DVB SUB on TF1 page_id: 1 anc_id: 0 lang: fra


DVB SUB on TF1 page_id: 1 anc_id: 0 lang: eng

Reading PMT: pid=200

DVB SUB on NRJ12 page_id: 1 anc_id: 1 lang: fra

Reading PMT: pid=400
Reading PMT: pid=300
Reading PMT: pid=600

DVB SUB on TMC page_id: 1 anc_id: 0 lang: fra


DVB SUB on TMC page_id: 1 anc_id: 0 lang: fra

Reading PMT: pid=500

DVB SUB on TF6 page_id: 1 anc_id: 0 lang: fra

Reading PMT: pid=8000
Frontend closed
Using DVB device 0:0 "Afatech AF9013 DVB-T"
tuning DVB-T to 570000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
..................................................

Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Transponders: 57
dvbsi: The end :)
|ARTE HD|498000|v|0
|PARIS PREMIERE|498000|v|0
|CANAL+|522000|v|0
|CANAL+ CINEMA|522000|v|0
|CANAL+ SPORT|522000|v|0
|PLANETE|522000|v|0
|CANAL J|522000|v|0
|TPS STAR|522000|v|0
|Eurosport|562000|v|0
|LCI|562000|v|0
|TF6|562000|v|0
Channels found: 11
Saved epg data : 0 events (0 msecs)
DCOP Cleaning up dead connections.

I hope this could help.

This work for me ! I can use my Volar Black ! Thank you for your 
wonderful work !

I'll try http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/ tomorrow and 
tell you...

Regards,

Thomas


Antti Palosaari a écrit :
>
> Olivier MENUEL wrote:
>> Sorry,
>> I was at work today.
>>
>> I just downloaded the latest version.
>> It works a lot better than the previous one (the device_nums are 
>> correct in the af9015.c and it seems the frontend is correctly 
>> initialized now). Here is the /var/log/messages :
>
> Looks just correct!
>
>> I tried a scan with kaffeine : the blue light is on when scanning 
>> (which is a pretty good news), but I can't find any channels : the 
>> signal goes up to 85% but SNR stays at 0% and no channel is found ...
>
> hmm, not AverMedia A850 issue. I should look this later...
>
>> But I tried a scan with the scan command line and everything worked 
>> fine !!!!!!!!!
>> I found all channels and it seems to work really fine with vlc !!!
>
> :)
>
> Now I need some more tests. I can see from logs GPIO0 and GPIO1 are 
> set differently.
>
> 1) reference design GPIOs:
> If that works you don't need to test more.
> http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/
>
> 2) GPIO1 tuner
> looks like tuner is connected to this GPIO
> If that works no need to test more.
> http://linuxtv.org/hg/~anttip/af9015_aver_a850_GPIO1/
>
> 3) GPIO0 tuner
> last test if nothing before works
> http://linuxtv.org/hg/~anttip/af9015_aver_a850_GPIO0/
>
> regards
> Antti
