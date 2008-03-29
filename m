Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail35.syd.optusnet.com.au ([211.29.133.51])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ausgnome@optusnet.com.au>) id 1JfabP-0007Nv-MK
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 13:56:09 +0100
Received: from [192.168.0.14] (c211-28-205-57.frank1.vic.optusnet.com.au
	[211.28.205.57]) (authenticated sender ausgnome)
	by mail35.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m2TCtxGa013317
	for <linux-dvb@linuxtv.org>; Sat, 29 Mar 2008 23:56:00 +1100
Message-ID: <47EE3C5E.8080001@optusnet.com.au>
Date: Sat, 29 Mar 2008 23:55:58 +1100
From: ausgnome <ausgnome@optusnet.com.au>
MIME-Version: 1.0
To: dvb <linux-dvb@linuxtv.org>
References: <20080329024154.GA23883@localhost>
	<47EDCE27.4050101@optusnet.com.au> <47EE1056.9050804@iki.fi>
In-Reply-To: <47EE1056.9050804@iki.fi>
Subject: Re: [linux-dvb] Afatech 9015
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I used this tree
http://linuxtv.org/hg/~anttip/af9015/

and this firmware
www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw


dmesg
[ 239.333298] dvb-usb: schedule remote query interval to 200 msecs.
[ 239.333301] dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully 
initialized and connected.

Eprom Dump this includes first attempt with a different firmware file 
_ref version
Mar 29 15:28:23 laptop kernel: [ 238.194981] af9015_usb_probe:
Mar 29 15:28:24 laptop kernel: [ 238.699942] af9015_identify_state: reply:02
Mar 29 15:28:24 laptop kernel: [ 238.699948] dvb-usb: found a 'Afatech 
AF9015 DVB-T USB2.0 stick' in warm state.
Mar 29 15:28:24 laptop kernel: [ 238.700018] dvb-usb: will pass the 
complete MPEG2 transport stream to the software demuxer.
Mar 29 15:28:24 laptop kernel: [ 238.700330] DVB: registering new 
adapter (Afatech AF9015 DVB-T USB2.0 stick)
Mar 29 15:28:24 laptop kernel: [ 238.700597] af9015_eeprom_dump:
Mar 29 15:28:24 laptop kernel: [ 238.722782] 00: 2b d3 9b 0b 00 00 00 00 
a4 15 16 90 00 02 01 02
Mar 29 15:28:24 laptop kernel: [ 238.745116] 10: 03 80 00 fa fa 10 40 ef 
01 30 31 30 31 31 30 31
Mar 29 15:28:24 laptop kernel: [ 238.766707] 20: 36 30 37 30 30 30 30 31 
ff ff ff ff ff ff ff ff
Mar 29 15:28:24 laptop kernel: [ 238.788548] 30: 00 00 3a 01 00 08 02 00 
f8 a7 00 00 9c ff ff ff
Mar 29 15:28:24 laptop kernel: [ 238.810765] 40: ff ff ff ff ff 08 02 00 
1d 8d c4 04 82 ff ff ff
Mar 29 15:28:24 laptop kernel: [ 238.832986] 50: ff ff ff ff 10 26 00 00 
04 03 09 04 10 03 41 00
Mar 29 15:28:24 laptop kernel: [ 238.854950] 60: 66 00 61 00 74 00 65 00 
63 00 68 00 10 03 44 00
Mar 29 15:28:24 laptop kernel: [ 238.877043] 70: 56 00 42 00 2d 00 54 00 
20 00 32 00 20 03 30 00
Mar 29 15:28:24 laptop kernel: [ 238.899005] 80: 31 00 30 00 31 00 30 00 
31 00 30 00 31 00 30 00
Mar 29 15:28:24 laptop kernel: [ 238.921097] 90: 36 00 30 00 30 00 30 00 
30 00 31 00 00 ff ff ff
Mar 29 15:28:24 laptop kernel: [ 238.942688] a0: ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff
Mar 29 15:28:24 laptop kernel: [ 238.964407] b0: ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff
Mar 29 15:28:24 laptop kernel: [ 238.986372] c0: ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff
Mar 29 15:28:24 laptop kernel: [ 239.008089] d0: ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff
Mar 29 15:28:24 laptop kernel: [ 239.008089] d0: ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff
Mar 29 15:28:24 laptop kernel: [ 239.030305] e0: ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff
Mar 29 15:28:24 laptop kernel: [ 239.052146] f0: ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff
Mar 29 15:28:24 laptop kernel: [ 239.053520] af9015_read_config: xtal:2 
set adc_clock:28000
Mar 29 15:28:24 laptop kernel: [ 239.056266] af9015_read_config: IF1:43000
Mar 29 15:28:24 laptop kernel: [ 239.056266] af9015_read_config: IF1:43000
Mar 29 15:28:24 laptop kernel: [ 239.059136] af9015_read_config: MT2060 
IF1:0
Mar 29 15:28:24 laptop kernel: [ 239.060634] af9015_read_config: tuner 
id1:156
Mar 29 15:28:24 laptop kernel: [ 239.062006] af9015_read_config: 
spectral inversion:0
Mar 29 15:28:24 laptop kernel: [ 239.062008] af9015_set_gpios:
Mar 29 15:28:24 laptop kernel: [ 239.063878] af9013: firmware version:4.95.0
Mar 29 15:28:24 laptop kernel: [ 239.063883] DVB: registering frontend 0 
(Afatech AF9013 DVB-T)...
Mar 29 15:28:24 laptop kernel: [ 239.063922] af9015_tuner_attach:
Mar 29 15:28:24 laptop kernel: [ 239.063948] tda18271 1-00c0: creating 
new instance
Mar 29 15:28:24 laptop kernel: [ 239.066873] TDA18271HD/C1 detected @ 1-00c0
Mar 29 15:28:24 laptop kernel: [ 239.333275] input: IR-receiver inside 
an USB DVB receiver as /class/input/input11
Mar 29 15:28:24 laptop kernel: [ 239.333298] dvb-usb: schedule remote 
query interval to 200 msecs.
Mar 29 15:28:24 laptop kernel: [ 239.333301] dvb-usb: Afatech AF9015 
DVB-T USB2.0 stick successfully initialized and connected.
Mar 29 15:28:24 laptop kernel: [ 239.333303] af9015_init:
Mar 29 15:28:24 laptop kernel: [ 239.337461] af9015_download_ir_table:
Mar 29 15:28:24 laptop kernel: [ 239.386468] input: Afatech DVB-T 2 as 
/class/input/input12
Mar 29 15:28:24 laptop kernel: [ 239.386497] input: USB HID v1.01 
Keyboard [Afatech DVB-T 2] on usb-0000:00:10.4-6


root@laptop:/etc/apt#



Antti Palosaari wrote:
> ausgnome wrote:
>> Hi got off mya ass and checked out the archives, have managed to get the
>> Tevion USB DVB-T going supplied by Aldi in australia $50
>>
>> Seems to work fine
>
> Did you use which tree? Debug / message-log outputs would be nice to 
> see. Use dmesg to dump.
>
> Antti


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
