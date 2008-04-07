Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.250])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rvm3000@gmail.com>) id 1JimzX-0000c1-Se
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 10:46:17 +0200
Received: by an-out-0708.google.com with SMTP id d18so324911and.125
	for <linux-dvb@linuxtv.org>; Mon, 07 Apr 2008 01:46:02 -0700 (PDT)
Message-ID: <f474f5b70804070146l5ab13459sc25b8f1129b15122@mail.gmail.com>
Date: Mon, 7 Apr 2008 10:46:02 +0200
From: rvm <rvm3000@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <47F980D5.3030202@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <f474f5b70804021720i7926ea17q77b3ef551fb0841f@mail.gmail.com>
	<47F44538.2090508@iki.fi>
	<f474f5b70804051654h3ee0bdd5u6eb19db2ac626845@mail.gmail.com>
	<47F90CA3.1090102@iki.fi>
	<f474f5b70804061846o66a3126aidcde58b4889b926c@mail.gmail.com>
	<47F980D5.3030202@iki.fi>
Subject: Re: [linux-dvb] Pinnacle PCTV 71e
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

2008/4/7, Antti Palosaari <crope@iki.fi>:
> rvm wrote:
>

>
> > Still I'm getting the video (and audio) corrupted, could it be because
> > of the firmware? I used this one:
> >
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw
> >
>
>  No, it is no firmware issue. Firmware 4.95 is latest one and OK.
>
>  Can you say which tuner your device has? You can see that from message.log
> (dmesg). Please copy paste some lines.

[  910.286534] af9015_usb_probe: interface:0
[  910.292965] af9015_identify_state: reply:02
[  910.293003] dvb-usb: found a 'Pinnacle PCTV 71e' in warm state.
[  910.293608] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[  910.300877] DVB: registering new adapter (Pinnacle PCTV 71e)
[  910.304752] af9015_eeprom_dump:
[  910.432810] 00: 2f cc af 0b 00 00 00 00 04 23 2b 02 00 02 01 02
[  910.498755] 10: 03 80 00 fa fa 10 40 ef 00 30 31 30 31 31 31 30
[  910.554155] 20: 38 30 36 30 30 30 33 45 ff ff ff ff ff ff ff ff
[  910.610246] 30: 00 00 3a 01 00 08 02 00 1d 8d d2 04 82 ff ff ff
[  910.664090] 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
[  910.720030] 50: ff ff ff ff ff 24 00 00 04 03 09 04 22 03 50 00
[  910.778381] 60: 69 00 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00
[  910.837528] 70: 53 00 79 00 73 00 74 00 65 00 6d 00 73 00 12 03
[  910.895432] 80: 50 00 43 00 54 00 56 00 20 00 37 00 31 00 65 00
[  910.956367] 90: 20 03 30 00 31 00 30 00 31 00 30 00 31 00 30 00
[  911.013294] a0: 31 00 30 00 36 00 30 00 30 00 30 00 30 00 31 00
[  911.075256] b0: 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  911.135892] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  911.194811] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  911.252938] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  911.310816] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  911.314842] af9015_read_config: xtal:2 set adc_clock:28000
[  911.322559] af9015_read_config: IF1:36125
[  911.330385] af9015_read_config: MT2060 IF1:1234
[  911.332447] af9015_read_config: tuner id1:130
[  911.335536] af9015_read_config: spectral inversion:0
[  911.421856] af9013: firmware version:4.95.0
[  911.422145] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
[  911.422287] af9015_tuner_attach:
[  911.422351] af9015_set_gpio: gpio:3 gpioval:03
[  911.474019] MT2060: successfully identified (IF1 = 1234)
[  912.044368] dvb-usb: Pinnacle PCTV 71e successfully initialized and
connected.


-- 
Pepe

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
