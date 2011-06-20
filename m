Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41455 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1FTT3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 15:29:50 -0400
Received: by qwk3 with SMTP id 3so948136qwk.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 12:29:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DF49E2A.9030804@iki.fi>
References: <BANLkTimkYw70GAu1keW-N6ND=AyiRn2+CA@mail.gmail.com>
	<4DF49E2A.9030804@iki.fi>
Date: Mon, 20 Jun 2011 21:29:49 +0200
Message-ID: <BANLkTi=dGyN8SEwwAStD0Ob99k+FKkQPFg@mail.gmail.com>
Subject: Re: PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C) - DVB-C channel
 scan in mythtv - missing
From: Rune Evjen <rune.evjen@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/12 Antti Palosaari <crope@iki.fi>:
> On 06/12/2011 11:23 AM, Rune Evjen wrote:
>>
>> I just tested a PCTV 290e device using the latest media_build drivers
>> in MythTV as a DVB-C device, and ran into some problems.
>>
>> The adapter is recognized by the em28xx-dvb driver [1] and dmesg
>> output seems to be correct [2]. I can successfully scan for channels
>> using the scan utility in dvb-apps but when I try to scan for channels
>> in mythtv I get the following errors logged by mythtv-setup:
>>
>> 2011-06-12 00:57:20.971556  PIDInfo(/dev/dvb/adapter0/
>> frontend1): Failed to open demux device /dev/dvb/adapter0/demux1 for
>> filter on pid 0x0
>>
>> The demux1 does not exist, I only have the following nodes under
>> /dev/dvb/adapter0:
>>
>> demux0  dvr0  frontend0  frontend1  net0
>>
>> When searching the linx-media I came across this thread:
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg31839.html
>>
>> Is there any way to circumvent with the current driver that there is
>> no corresponding demux1 for frontend1?
>> Or can the DVB-T/T2 part be disabled somehow so that there is only one
>> DVB-C frontend registered which corresponds to the demux0?
>
> There is no way to say driver to create demux1 for frontend1.
>
> After all it is not 100% clear even for me if that's correct or not, but
> most likely it is correct as far as I understood.
>
Thank you for your response, Antti.
Your help is much appreciated.

I have tested the 290e as a DVB-C adapter with some success, to use it
I created a new adapter directory under /dev/dvb, and symlinked the
following:
ln -s /dev/dvb/adapter0/frontend1 /dev/dvb/adapter1/frontend0
ln -s /dev/dvb/adapter0/demux0 /dev/dvb/adapter1/demux0
ln -s /dev/dvb/adapter0/dvr0 /dev/dvb/adapter1/dvr0

When testing I can scan using the scan utility and mythtv, and receive
QAM-64 channels.
QAM-256 channels have distorted audio and video.

I tried to investigate the QAM-256 problem using the debug option on
cxd2820r, but when this option is enabled I get no lock using mythtv
or the scan utility.

This also happened intermittently without the debug option, and when I
get the "no lock" status, the only way to solve this is to shutdown
and start the computer (i.e not rebooting) to make sure the 290e gets
a power cycle (and it seems that the debug option also has to be off,
at least this is my experience after 3-4 power cycles with and without
this option).

I have attached the syslog output with failed locks [1] generated by
the debug option in case this may help with the driver development.

Best regards,

Rune

[1]: syslog output when performing a scan using the scan utility:
Jun 20 21:04:21 server kernel: [  711.180370] cxd2820r:
cxd2820r_set_frontend_c: RF=450000000 SR=6950000
Jun 20 21:04:21 server kernel: [  711.180375] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:22 server kernel: [  711.380429] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:22 server kernel: [  711.380436] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:22 server kernel: [  711.381308] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:22 server kernel: [  711.581398] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:22 server kernel: [  711.581403] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:22 server kernel: [  711.582206] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:22 server kernel: [  711.731275] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:22 server kernel: [  711.731281] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:22 server kernel: [  711.732101] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:22 server kernel: [  711.732108] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:22 server kernel: [  711.732112] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:22 server kernel: [  711.732118] cxd2820r:
cxd2820r_set_frontend_c: RF=450000000 SR=6950000
Jun 20 21:04:22 server kernel: [  711.732123] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:22 server kernel: [  711.792010] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:22 server kernel: [  711.792017] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:22 server kernel: [  711.792863] cxd2820r:
cxd2820r_read_status_c: lock=04 52
Jun 20 21:04:22 server kernel: [  711.992944] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:22 server kernel: [  711.992949] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:22 server kernel: [  711.993769] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:22 server kernel: [  712.194200] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:22 server kernel: [  712.194207] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:22 server kernel: [  712.195052] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:23 server kernel: [  712.291281] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:23 server kernel: [  712.291285] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:23 server kernel: [  712.292073] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:23 server kernel: [  712.292079] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:23 server kernel: [  712.292083] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:23 server kernel: [  712.292088] cxd2820r:
cxd2820r_set_frontend_c: RF=450000000 SR=6950000
Jun 20 21:04:23 server kernel: [  712.292093] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:23 server kernel: [  712.395130] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:23 server kernel: [  712.395135] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:23 server kernel: [  712.395960] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:23 server kernel: [  712.596040] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:23 server kernel: [  712.596044] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:23 server kernel: [  712.596867] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:23 server kernel: [  712.796947] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:23 server kernel: [  712.796951] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:23 server kernel: [  712.797775] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:23 server kernel: [  712.851274] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:23 server kernel: [  712.851279] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:23 server kernel: [  712.852033] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:23 server kernel: [  712.852038] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:23 server kernel: [  712.852042] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:23 server kernel: [  712.852047] cxd2820r:
cxd2820r_set_frontend_c: RF=450000000 SR=6950000
Jun 20 21:04:23 server kernel: [  712.852051] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:23 server kernel: [  712.997852] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:23 server kernel: [  712.997857] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:23 server kernel: [  712.998683] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:23 server kernel: [  713.198774] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:23 server kernel: [  713.198782] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:23 server kernel: [  713.199591] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:23 server kernel: [  713.199668] cxd2820r:
cxd2820r_get_tune_settings: delsys=1
Jun 20 21:04:23 server kernel: [  713.199673] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:23 server kernel: [  713.199700] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:23 server kernel: [  713.199708] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:23 server kernel: [  713.199713] cxd2820r:
cxd2820r_set_frontend_c: RF=450000000 SR=6950000
Jun 20 21:04:23 server kernel: [  713.199719] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:24 server kernel: [  713.399764] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:24 server kernel: [  713.399770] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:24 server kernel: [  713.400623] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:24 server kernel: [  713.600699] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:24 server kernel: [  713.600703] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:24 server kernel: [  713.601556] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:24 server kernel: [  713.750028] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:24 server kernel: [  713.750033] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:24 server kernel: [  713.750803] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:24 server kernel: [  713.750809] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:24 server kernel: [  713.750813] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:24 server kernel: [  713.750818] cxd2820r:
cxd2820r_set_frontend_c: RF=450000000 SR=6950000
Jun 20 21:04:24 server kernel: [  713.750823] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:24 server kernel: [  713.813083] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:24 server kernel: [  713.813091] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:24 server kernel: [  713.813939] cxd2820r:
cxd2820r_read_status_c: lock=04 52
Jun 20 21:04:24 server kernel: [  714.014015] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:24 server kernel: [  714.014020] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:24 server kernel: [  714.014846] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:25 server kernel: [  714.214938] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:25 server kernel: [  714.214946] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:25 server kernel: [  714.215754] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:25 server kernel: [  714.311277] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:25 server kernel: [  714.311282] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:25 server kernel: [  714.312143] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:25 server kernel: [  714.312149] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:25 server kernel: [  714.312153] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:25 server kernel: [  714.312159] cxd2820r:
cxd2820r_set_frontend_c: RF=450000000 SR=6950000
Jun 20 21:04:25 server kernel: [  714.312163] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:25 server kernel: [  714.415831] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:25 server kernel: [  714.415836] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:25 server kernel: [  714.416660] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:25 server kernel: [  714.616734] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:25 server kernel: [  714.616739] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:25 server kernel: [  714.617568] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:25 server kernel: [  714.817644] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:25 server kernel: [  714.817649] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:25 server kernel: [  714.818475] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:25 server kernel: [  714.870123] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:25 server kernel: [  714.870128] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:25 server kernel: [  714.870984] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:25 server kernel: [  714.870989] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:25 server kernel: [  714.870993] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:25 server kernel: [  714.870997] cxd2820r:
cxd2820r_set_frontend_c: RF=450000000 SR=6950000
Jun 20 21:04:25 server kernel: [  714.871002] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:25 server kernel: [  715.018554] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:25 server kernel: [  715.018558] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:25 server kernel: [  715.019383] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:26 server kernel: [  715.219470] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:26 server kernel: [  715.219477] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:26 server kernel: [  715.220291] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:26 server kernel: [  715.220363] cxd2820r:
cxd2820r_get_tune_settings: delsys=1
Jun 20 21:04:26 server kernel: [  715.220367] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:26 server kernel: [  715.220403] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:26 server kernel: [  715.220410] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:26 server kernel: [  715.220416] cxd2820r:
cxd2820r_set_frontend_c: RF=474000000 SR=6950000
Jun 20 21:04:26 server kernel: [  715.220421] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:26 server kernel: [  715.420455] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:26 server kernel: [  715.420460] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:26 server kernel: [  715.421330] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:26 server kernel: [  715.621409] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:26 server kernel: [  715.621413] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:26 server kernel: [  715.622230] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:26 server kernel: [  715.781273] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:26 server kernel: [  715.781277] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:26 server kernel: [  715.782131] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:26 server kernel: [  715.782137] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:26 server kernel: [  715.782141] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:26 server kernel: [  715.782146] cxd2820r:
cxd2820r_set_frontend_c: RF=474000000 SR=6950000
Jun 20 21:04:26 server kernel: [  715.782151] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:26 server kernel: [  715.843040] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:26 server kernel: [  715.843048] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:26 server kernel: [  715.843892] cxd2820r:
cxd2820r_read_status_c: lock=04 52
Jun 20 21:04:26 server kernel: [  716.043968] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:26 server kernel: [  716.043973] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:26 server kernel: [  716.044798] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:27 server kernel: [  716.244887] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:27 server kernel: [  716.244894] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:27 server kernel: [  716.245707] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:27 server kernel: [  716.341278] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:27 server kernel: [  716.341283] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:27 server kernel: [  716.342096] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:27 server kernel: [  716.342102] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:27 server kernel: [  716.342106] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:27 server kernel: [  716.342111] cxd2820r:
cxd2820r_set_frontend_c: RF=474000000 SR=6950000
Jun 20 21:04:27 server kernel: [  716.342116] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:27 server kernel: [  716.445785] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:27 server kernel: [  716.445790] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:27 server kernel: [  716.446613] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:27 server kernel: [  716.646688] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:27 server kernel: [  716.646693] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:27 server kernel: [  716.647521] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:27 server kernel: [  716.847594] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:27 server kernel: [  716.847599] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:27 server kernel: [  716.848428] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:27 server kernel: [  716.901281] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:27 server kernel: [  716.901285] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:27 server kernel: [  716.902062] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:27 server kernel: [  716.902067] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:27 server kernel: [  716.902071] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:27 server kernel: [  716.902075] cxd2820r:
cxd2820r_set_frontend_c: RF=474000000 SR=6950000
Jun 20 21:04:27 server kernel: [  716.902080] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:27 server kernel: [  717.048508] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:27 server kernel: [  717.048513] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:27 server kernel: [  717.049335] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:28 server kernel: [  717.249425] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:28 server kernel: [  717.249432] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:28 server kernel: [  717.250242] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:28 server kernel: [  717.250317] cxd2820r:
cxd2820r_get_tune_settings: delsys=1
Jun 20 21:04:28 server kernel: [  717.250322] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:28 server kernel: [  717.250352] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:28 server kernel: [  717.250359] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:28 server kernel: [  717.250365] cxd2820r:
cxd2820r_set_frontend_c: RF=474000000 SR=6950000
Jun 20 21:04:28 server kernel: [  717.250370] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:28 server kernel: [  717.450404] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:28 server kernel: [  717.450409] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:28 server kernel: [  717.451150] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:28 server kernel: [  717.651228] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:28 server kernel: [  717.651233] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:28 server kernel: [  717.652058] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:28 server kernel: [  717.801289] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:28 server kernel: [  717.801296] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:28 server kernel: [  717.802082] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:28 server kernel: [  717.802089] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:28 server kernel: [  717.802094] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:28 server kernel: [  717.802100] cxd2820r:
cxd2820r_set_frontend_c: RF=474000000 SR=6950000
Jun 20 21:04:28 server kernel: [  717.802105] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:28 server kernel: [  717.863117] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:28 server kernel: [  717.863124] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:28 server kernel: [  717.863968] cxd2820r:
cxd2820r_read_status_c: lock=04 52
Jun 20 21:04:28 server kernel: [  718.064051] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:28 server kernel: [  718.064056] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:28 server kernel: [  718.064873] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:29 server kernel: [  718.264961] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:29 server kernel: [  718.264969] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:29 server kernel: [  718.265783] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:29 server kernel: [  718.361273] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:29 server kernel: [  718.361277] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:29 server kernel: [  718.362046] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:29 server kernel: [  718.362052] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:29 server kernel: [  718.362056] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:29 server kernel: [  718.362063] cxd2820r:
cxd2820r_set_frontend_c: RF=474000000 SR=6950000
Jun 20 21:04:29 server kernel: [  718.362068] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:29 server kernel: [  718.465860] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:29 server kernel: [  718.465865] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:29 server kernel: [  718.466688] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:29 server kernel: [  718.666765] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:29 server kernel: [  718.666769] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:29 server kernel: [  718.667596] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:29 server kernel: [  718.867673] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:29 server kernel: [  718.867677] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:29 server kernel: [  718.868504] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:29 server kernel: [  718.920621] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:29 server kernel: [  718.920629] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:29 server kernel: [  718.921388] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:29 server kernel: [  718.921394] cxd2820r:
cxd2820r_set_frontend: delsys=1
Jun 20 21:04:29 server kernel: [  718.921398] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:29 server kernel: [  718.921403] cxd2820r:
cxd2820r_set_frontend_c: RF=474000000 SR=6950000
Jun 20 21:04:29 server kernel: [  718.921407] cxd2820r: cxd2820r_gpio: delsys=1
Jun 20 21:04:29 server kernel: [  719.068584] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:29 server kernel: [  719.068589] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:29 server kernel: [  719.069411] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:30 server kernel: [  719.269498] cxd2820r:
cxd2820r_read_status: delsys=1
Jun 20 21:04:30 server kernel: [  719.269505] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:30 server kernel: [  719.270320] cxd2820r:
cxd2820r_read_status_c: lock=05 52
Jun 20 21:04:30 server kernel: [  719.480741] cxd2820r: cxd2820r_sleep: delsys=1
Jun 20 21:04:30 server kernel: [  719.480745] cxd2820r: cxd2820r_lock:
active_fe=1
Jun 20 21:04:30 server kernel: [  719.480749] cxd2820r: cxd2820r_sleep_c
Jun 20 21:04:30 server kernel: [  719.482603] cxd2820r:
cxd2820r_unlock: active_fe=1
