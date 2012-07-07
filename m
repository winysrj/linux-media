Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41795 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab2GGXIT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jul 2012 19:08:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Sne6r-0005at-He
	for linux-media@vger.kernel.org; Sun, 08 Jul 2012 01:08:17 +0200
Received: from bwp16.neoplus.adsl.tpnet.pl ([83.29.239.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 08 Jul 2012 01:08:17 +0200
Received: from acc.for.news by bwp16.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 08 Jul 2012 01:08:17 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: Re: pctv452e
Date: Sun, 08 Jul 2012 01:07:30 +0200
Message-ID: <l2smc9-pj4.ln1@wuwek.kopernik.gliwice.pl>
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl> <4FF6B121.6010105@iki.fi> <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl> <835kc9-7p4.ln1@wuwek.kopernik.gliwice.pl> <4FF77C1B.50406@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4FF77C1B.50406@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 2012-07-07 02:00, Antti Palosaari pisze:
>> I don't know what can i do next.
>
> Get the rid of vdr and use only szap/vlc/mplayer only to see if it works.
This computer is remote headless without any GUI, but ok - I'll do my 
best (that's why I use VDR - I can using streamdev play it on local PC).

> And install latest patch from here:
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/pctv452e
>
> it just ignores the I2C error coming from wrong I2C address used which
> could have some effect for STB6100 driver.
Patch works as expected - no more I2C errors in error log. Very nice.

Lacking GUI I tried to save stream on HDD.

wuwek:~# szap -n 51 -r
reading channels from file '/root/.szap/channels.conf'
zapping to 51 'Mango 24;TVN':
sat 0, frequency = 11393 MHz V, symbolrate 27500000, vpid = 0x0205, apid 
= 0x02bc sid = 0x0245
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0095 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal 01ce | snr 0094 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal 01ce | snr 0094 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:~# ls /dev/dvb/adapter0/
demux0     dvr0       frontend0  net0
wuwek:~# cat /dev/dvb/adapter0/dvr0 > /mnt/video/test.ts
^C
wuwek:~# ls -l /mnt/video/test.ts
-rw-r--r-- 1 root root 0 lip  8 00:37 /mnt/video/test.ts
wuwek:~# dvbdate
dvbdate: Unable to get time from multiplex.
wuwek:~# dvbtraffic
dvbdemux_set_pid_filter: Invalid argument

I've tried to tune many different channels (log at the end), it works 
for many of them, some (all HD) doesn't work. I've used szap-s2 because 
szap doesn't work with DVB-S2 channels. For DVB-S channels szap produces 
results the same as szap-s2.
I've tried to save some different channels (as above) but none saved 
anything, so there is still something wrong with this driver.
Marx

kern.log:
Jul  8 00:16:29 wuwek kernel: [    6.001815] input: HD-Audio Generic 
HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/sound/card0/input3
Jul  8 00:16:29 wuwek kernel: [    6.066989] usb 1-4: dvb_usbv2: found a 
'PCTV HDTV USB' in warm state
Jul  8 00:16:29 wuwek kernel: [    6.067002] pctv452e_power_ctrl: 1
Jul  8 00:16:29 wuwek kernel: [    6.067007] pctv452e_power_ctrl: step 1
Jul  8 00:16:29 wuwek kernel: [    6.067012] pctv452e_power_ctrl: step 2
Jul  8 00:16:29 wuwek kernel: [    6.067559] pctv452e_power_ctrl: step 3
Jul  8 00:16:29 wuwek kernel: [    6.067684] usbcore: registered new 
interface driver dvb_usb_pctv452e
Jul  8 00:16:29 wuwek kernel: [    6.067745] pctv452e_power_ctrl: step 4
Jul  8 00:16:29 wuwek kernel: [    6.067996] pctv452e_power_ctrl: step 5
Jul  8 00:16:29 wuwek kernel: [    6.068113] usb 1-4: dvb_usbv2: will 
pass the complete MPEG2 transport stream to the software demuxer
Jul  8 00:16:29 wuwek kernel: [    6.068175] DVB: registering new 
adapter (PCTV HDTV USB)
Jul  8 00:16:29 wuwek kernel: [    6.117522] input: HDA ATI SB Line as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input4
Jul  8 00:16:29 wuwek kernel: [    6.117730] input: HDA ATI SB Rear Mic 
as /devices/pci0000:00/0000:00:14.2/sound/card1/input5
Jul  8 00:16:29 wuwek kernel: [    6.118330] input: HDA ATI SB Line Out 
CLFE as /devices/pci0000:00/0000:00:14.2/sound/card1/input6
Jul  8 00:16:29 wuwek kernel: [    6.118482] input: HDA ATI SB Line Out 
Surround as /devices/pci0000:00/0000:00:14.2/sound/card1/input7
Jul  8 00:16:29 wuwek kernel: [    6.121096] input: HDA ATI SB Line Out 
Front as /devices/pci0000:00/0000:00:14.2/sound/card1/input8
Jul  8 00:16:29 wuwek kernel: [    6.157236] stb0899_attach: Attaching 
STB0899
Jul  8 00:16:29 wuwek kernel: [    6.182361] DVB: registering adapter 0 
frontend 0 (STB0899 Multistandard)...
Jul  8 00:16:29 wuwek kernel: [    6.209194] stb6100_attach: Attaching 
STB6100
Jul  8 00:16:29 wuwek kernel: [    6.209208] pctv452e_power_ctrl: 0
Jul  8 00:16:29 wuwek kernel: [    6.209224] usb 1-4: dvb_usbv2: 'PCTV 
HDTV USB' successfully initialized and connected
Jul  8 00:16:29 wuwek kernel: [    7.998317] Adding 2097148k swap on 
/dev/sda2.  Priority:-1 extents:1 across:2097148k
(...)
Jul  8 00:16:49 wuwek kernel: [   58.654218] pctv452e_power_ctrl: 1
Jul  8 00:16:49 wuwek kernel: [   58.654229] pctv452e_power_ctrl: step 1
Jul  8 00:27:05 wuwek kernel: [  674.833814] pctv452e_power_ctrl: 0
Jul  8 00:27:30 wuwek kernel: [  699.336350] pctv452e_power_ctrl: 1
Jul  8 00:27:30 wuwek kernel: [  699.336363] pctv452e_power_ctrl: step 1
Jul  8 00:28:08 wuwek kernel: [  737.552961] pctv452e_power_ctrl: 0


wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 2 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 2 'TVN Turbo;TVN':
delivery DVB-S, modulation QPSK
sat 0, frequency 11393 MHz V, symbolrate 27500000, coderate 5/6, rolloff 
0.35
vpid 0x0208, apid 0x02da, sid 0x0247
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 008b | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 3 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 3 'TTV;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 11393 MHz V, symbolrate 27500000, coderate 5/6, rolloff 
0.35
vpid 0x0206, apid 0x02c6, sid 0x0246
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 008c | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 4 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 4 'NATIONAL GEO HD;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 11278 MHz V, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x016a, apid 0x0185, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 5 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 5 'NATIONAL GEO;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 10796 MHz V, symbolrate 27500000, coderate 5/6, rolloff 
0.35
vpid 0x00a9, apid 0x0074, sid 0x01fe
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0093 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 6 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 6 'EUROSPORT HD ;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 11278 MHz V, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x0bb8, apid 0x0c81, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 7 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 7 'TVN 7 HD;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 11278 MHz V, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x016e, apid 0x0194, sid 0x020f
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 8 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 8 'Nat Geo Wild HD PL;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 11258 MHz H, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x021c, apid 0x02e4, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 9 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 9 'Nat Geo Wild HD;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 11258 MHz H, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x021c, apid 0x02e4, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 10 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 10 'TVP HD;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 11258 MHz H, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x0219, apid 0x027d, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 11 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 11 'Wojna i Pokoj;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 11258 MHz H, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x0200, apid 0x02c8, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 12 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 12 'Romance TV;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 11449 MHz H, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x0217, apid 0x027b, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 13 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 13 'TVP 1 HD;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 11449 MHz H, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x0216, apid 0x027a, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 14 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 14 'MGM HD;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 11449 MHz H, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x0210, apid 0x02d8, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 15 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 15 'AXN HD;Cyfrowy Polsat SA':
delivery DVB-S, modulation QPSK
sat 0, frequency 12265 MHz V, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x02bd, apid 0x02c8, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 16 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 16 'TVP 2 HD;Cyfrowy Polsat S.A':
delivery DVB-S, modulation QPSK
sat 0, frequency 12265 MHz V, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x0606, apid 0x0604, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 17 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 17 'BBC HD;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 10834 MHz V, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x0231, apid 0x02f9, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 18 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 18 'Disney XD;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 10834 MHz V, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x0210, apid 0x0274, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 19 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 19 'Disney Channel;TP':
delivery DVB-S, modulation QPSK
sat 0, frequency 10911 MHz V, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x01f7, apid 0x014e, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 20 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 20 'Kino Polska;TP':
delivery DVB-S, modulation QPSK
sat 0, frequency 10911 MHz V, symbolrate 27500000, coderate 3/4, rolloff 
0.35
vpid 0x0201, apid 0x02c9, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
^C
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 21 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 21 'Nickelodeon Europe;MTV Networks Europe':
delivery DVB-S, modulation QPSK
sat 0, frequency 11075 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x03e8, apid 0x03e9, sid 0x03f1
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ae | snr 007e | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 22 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 22 'BBC CBeebies Poland;Globecast UK':
delivery DVB-S, modulation QPSK
sat 0, frequency 11116 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x1901, apid 0x190b, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01be | snr 007b | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 23 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 23 'Filmbox;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 10796 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00ac, apid 0x0080, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0089 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 24 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 24 'TVP Seriale;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 11508 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0205, apid 0x02bc, sid 0x0240
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0088 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 25 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 25 'Comedy Central Polska;MTV Networks Europe':
delivery DVB-S, modulation QPSK
sat 0, frequency 11075 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a9, apid 0x0074, sid 0x03f6
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01b6 | snr 007f | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 26 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 26 'BBC Entertainment Poland;Globecast UK':
delivery DVB-S, modulation QPSK
sat 0, frequency 11116 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x17d5, apid 0x17df, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01be | snr 0087 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 27 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 27 'TVP 1;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 10892 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a6, apid 0x0068, sid 0x01f7
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0083 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 28 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 28 'TVP 2;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 10892 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a7, apid 0x006c, sid 0x01fc
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 008e | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 29 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 29 'Polsat;Cyfrowy Polsat S.A.':
delivery DVB-S, modulation QPSK
sat 0, frequency 11158 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0101, apid 0x0102, sid 0x0108
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ae | snr 0082 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 30 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 30 'TVN;TVN':
delivery DVB-S, modulation QPSK
sat 0, frequency 11393 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0200, apid 0x028a, sid 0x0240
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0097 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 31 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 31 'TVN HD;TVN':
delivery DVB-S, modulation QPSK
sat 0, frequency 11508 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0214, apid 0x0334, sid 0x024f
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0089 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 32 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 32 'TVN Siedem;TVN':
delivery DVB-S, modulation QPSK
sat 0, frequency 11393 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0202, apid 0x029e, sid 0x0242
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 008b | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 33 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 33 'TV4;Cyfrowy Polsat S.A.':
delivery DVB-S, modulation QPSK
sat 0, frequency 11158 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0121, apid 0x0122, sid 0x0128
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ae | snr 0088 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 34 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 34 'TELE5;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 10796 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a4, apid 0x0060, sid 0x01f9
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 008c | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 35 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 35 'PULS;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 11487 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00ab, apid 0x007c, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01e5 | snr 0095 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 37 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 37 'TVN Style;TVN':
delivery DVB-S, modulation QPSK
sat 0, frequency 11393 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0209, apid 0x02e4, sid 0x0248
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0096 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 38 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 38 'TVN STYLE HD;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 11508 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0215, apid 0x033e, sid 0x0250
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0089 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 39 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 39 'Fashion TV;RRSat':
delivery DVB-S, modulation QPSK
sat 0, frequency 10815 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x07df, apid 0x0bc7, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01d6 | snr 007b | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 40 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 40 'BBC Lifestyle Poland;Globecast UK':
delivery DVB-S, modulation QPSK
sat 0, frequency 11116 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x189d, apid 0x18a7, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01be | snr 007d | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 41 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 41 'BBC Knowledge Poland;Globecast UK':
delivery DVB-S, modulation QPSK
sat 0, frequency 11116 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x1839, apid 0x1843, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01be | snr 0088 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 42 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 42 'Orange Sport;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 10796 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00aa, apid 0x0078, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01c6 | snr 0091 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 43 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 43 'nSport;TVN':
delivery DVB-S, modulation QPSK
sat 0, frequency 11393 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0203, apid 0x02a8, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0097 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 44 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 44 'TVP Sport;TVN':
delivery DVB-S, modulation QPSK
sat 0, frequency 11508 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0204, apid 0x02b2, sid 0x023f
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0089 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 45 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 45 'EDUSAT;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 10796 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a6, apid 0x0068, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 008d | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 46 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 46 'TVS;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 11487 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a1, apid 0x0054, sid 0x01fc
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01e5 | snr 008d | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 47 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 47 'TVP Kultura;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 11487 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00ac, apid 0x0080, sid 0x0201
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01e5 | snr 008b | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 48 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 48 'VIVA Polska;MTV Networks Europe':
delivery DVB-S, modulation QPSK
sat 0, frequency 11075 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a4, apid 0x0060, sid 0x040a
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01b6 | snr 007d | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 49 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 49 'ReligiaTV;TVN':
delivery DVB-S, modulation QPSK
sat 0, frequency 11508 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0202, apid 0x029e, sid 0x023d
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0093 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 50 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 50 '4fun.TV;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 10719 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a3, apid 0x005c, sid 0x0204
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0088 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 51 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 51 'Mango 24;TVN':
delivery DVB-S, modulation QPSK
sat 0, frequency 11393 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0205, apid 0x02bc, sid 0x0245
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0095 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 52 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 52 'Eska TV;ITI':
delivery DVB-S, modulation QPSK
sat 0, frequency 11508 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x020a, apid 0x02d6, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 0089 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 53 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 53 'Rebel TV;GlobeCast':
delivery DVB-S, modulation QPSK
sat 0, frequency 11585 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0583, apid 0x05e7, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01c6 | snr 0083 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 54 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 54 'TVR;RRSat':
delivery DVB-S, modulation QPSK
sat 0, frequency 11200 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0806, apid 0x0bee, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01c6 | snr 0085 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 55 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 55 'ITV;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 11487 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a8, apid 0x0070, sid 0x01f6
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01e5 | snr 008d | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 56 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 56 'TV POLONIA;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 11487 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a0, apid 0x0050, sid 0x01f4
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01e5 | snr 008c | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 57 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 57 'POLONIA1;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 10796 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a5, apid 0x0064, sid 0x01fa
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 008c | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 58 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 58 'TVN 24;TVN':
delivery DVB-S, modulation QPSK
sat 0, frequency 11393 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0201, apid 0x0294, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 008d | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 59 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 59 'TVN CNBC;TVN':
delivery DVB-S, modulation QPSK
sat 0, frequency 11393 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x020b, apid 0x02f8, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ce | snr 008c | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 60 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 60 'TVP INFO;CYFRA +':
delivery DVB-S, modulation QPSK
sat 0, frequency 11487 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00a9, apid 0x0074, sid 0x020a
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01e5 | snr 008a | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
wuwek:/var/lib/vdr/kanaly# ./szap-s2 -n 61 -x -r
reading channels from file '/root/.szap/channels.conf'
zapping to 61 'TV Biznes;Cyfrowy Polsat S.A.':
delivery DVB-S, modulation QPSK
sat 0, frequency 11158 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0161, apid 0x0162, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01ae | snr 007f | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK

