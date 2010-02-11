Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp22.services.sfr.fr ([93.17.128.13]:58088 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab0BKVoh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 16:44:37 -0500
From: "ftape-jlc" <ftape-jlc@club-internet.fr>
Reply-To: ftape-jlc@club-internet.fr
To: hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: Fwd: Re: FM radio problem with HVR1120
Date: Thu, 11 Feb 2010 22:45:21 +0100
References: <201001252029.12009.ftape-jlc@club-internet.fr> <4B733321.40803@redhat.com> <1265850476.4422.25.camel@localhost>
In-Reply-To: <1265850476.4422.25.camel@localhost>
MIME-Version: 1.0
Message-Id: <201002112245.21358.ftape-jlc@club-internet.fr>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thank you for the information.
I didn't tried regspy.exe yet.

Perhaps part of dmesg output for hvr1120 could help someone :

[  27.785329] Linux video capture interface: v2.00
[   27.999680] saa7130/34: v4l2 driver version 0.2.15 loaded
[   27.999767] saa7134 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[   27.999774] saa7133[0]: found at 0000:05:00.0, rev: 209, irq: 16, latency: 
64, mmio: 0xfebff800
[   27.999780] saa7133[0]: subsystem: 0070:6707, board: Hauppauge WinTV-
HVR1120 DVB-T/Hybrid [card=156,autodetected]
[   27.999812] saa7133[0]: board init: gpio is 40000
[   28.013025] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared 
IRQs
[   28.154016] saa7133[0]: i2c eeprom 00: 70 00 07 67 54 20 1c 00 43 43 a9 1c 
55 d2 b2 92
[   28.154029] saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff 
ff ff ff ff
[   28.154039] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 b0 
ff ff ff ff
[   28.154050] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[   28.154061] saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 06 32 97 04 00 20 
00 ff ff ff
[   28.154071] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[   28.154082] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[   28.154092] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[   28.154102] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 cf f6 61 f0 
73 05 29 00
[   28.154113] saa7133[0]: i2c eeprom 90: 84 08 00 06 89 06 01 00 95 29 8d 72 
07 70 73 09
[   28.154123] saa7133[0]: i2c eeprom a0: 23 5f 73 0a f4 9b 72 0b 2f 72 0e 01 
72 0f 45 72
[   28.154134] saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 73 13 a2 69 79 7f 00 
00 00 00 00
[   28.154144] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[   28.154154] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[   28.154165] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[   28.154175] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[   28.154186] i2c-adapter i2c-1: Invalid 7-bit address 0x7a
[   28.154678] tveeprom 1-0050: Hauppauge model 67209, rev C2F5, serial# 
6420175
[   28.154681] tveeprom 1-0050: MAC address is 00-0D-FE-61-F6-CF
[   28.154683] tveeprom 1-0050: tuner model is NXP 18271C2 (idx 155, type 54)
[   28.154686] tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') 
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[   28.154689] tveeprom 1-0050: audio processor is SAA7131 (idx 41)
[   28.154691] tveeprom 1-0050: decoder processor is SAA7131 (idx 35)
[   28.154693] tveeprom 1-0050: has radio, has IR receiver, has no IR 
transmitter
[   28.154695] saa7133[0]: hauppauge eeprom: model=67209
[   28.286091] tuner 1-004b: chip found @ 0x96 (saa7133[0])
[   28.327017] tda829x 1-004b: setting tuner address to 60
[   28.372183] tda18271 1-0060: creating new instance
[   28.402207] TDA18271HD/C2 detected @ 1-0060
[   28.621253] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011060000009769]
[   29.247016] tda18271: performing RF tracking filter calibration
[   40.948017] tda18271: RF tracking filter calibration complete
[   40.981028] tda829x 1-004b: type set to tda8290+18271
[   44.578145] saa7133[0]: registered device video0 [v4l2]
[   44.578208] saa7133[0]: registered device vbi0
[   44.578255] saa7133[0]: registered device radio0
[   45.056344] dvb_init() allocating 1 frontend
[   45.182381] tda829x 1-004b: type set to tda8290
[   45.188089] tda18271 1-0060: attaching existing instance
[   45.188093] DVB: registering new adapter (saa7133[0])
[   45.188097] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[   45.311022] tda10048_firmware_upload: waiting for firmware upload (dvb-fe-
tda10048-1.0.fw)...
[   45.311027] saa7134 0000:05:00.0: firmware: requesting dvb-fe-
tda10048-1.0.fw
[   45.349443] tda10048_firmware_upload: firmware read 24878 bytes.
[   45.349445] tda10048_firmware_upload: firmware uploading
[   46.482154] tda18271_read_regs: ERROR: i2c_transfer returned: -5
[   46.485876] tda18271_ir_cal_init: error -5 on line 786
[   46.489607] tda18271_init: error -5 on line 810
[   46.493636] tda18271_tune: error -5 on line 867
[   46.497755] tda18271_set_analog_params: error -5 on line 1004
[   49.233138] tda10048_firmware_upload: firmware uploaded
[   49.305625] saa7134 ALSA driver for DMA sound loaded
[   49.305635] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared 
IRQs
[   49.305658] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 16 registered as 
card -1

Best Regards,

ftape-jlc



On 11 Feb 2010, you wrote :
> Hi,
> 
> Am Mittwoch, den 10.02.2010, 20:28 -0200 schrieb Mauro Carvalho Chehab:
> > Hi,
> >
> > ftape-jlc wrote:
> > > Hello,
> > >
> > > I didn't received any message about radio on HVR1120.
> > > I just want to know if the use /dev/radio0 is deprecated in v4l2 today.
> > > In the mails, I only read messages about video or TV.
> >
> > No, it is not deprecated.
> >
> > > Did one user of the mailing list have tested actual v4l2 on /dev/radio0
> > > ?
> >
> > Yes. It works with several devices. Maybe there's a bug at the radio
> > entry for your board.
> >
> > >> The problem is to listen radio.
> > >> With Linux, the command used is
> > >> /usr/bin/radio -c /dev/radio0
> > >> in association with
> > >> sox -t ossdsp -r 32000 -c 2 /dev/dsp1 -t ossdsp /dev/dsp
> > >> to listen the sound.
> > >>
> > >> The result is an unstable frecuency. The station is not tuned. Stereo
> > >> is permanently switching to mono.
> > >> The 91.5MHz station is mixed permanently with other stations.
> >
> > This probably means that the GPIO setup for your board is wrong for
> > radio. Only someone with a HVR1120 could fix it, since the GPIO's are
> > board-specific.
> >
> > The better is if you could try to do it. It is not hard. Please take a
> > look at:
> >
> > http://linuxtv.org/wiki/index.php/GPIO_pins
> >
> > You'll need to run the regspy.exe utility (part of Dscaler package), and
> > check how the original driver sets the GPIO registers. Then edit them on
> > your board entry, at saa78134-cards.c, recompile the driver and test.
> >
> > The better is to use the out-of-tree mercuiral tree:
> > 	http://linuxtv.org/hg/v4l-dvb
> >
> > since it allows you to recompile and test without needing to replace your
> > kernel.
> 
> Mauro, without looking at anything, everything above 1110 can have the
> newer tuners and analog demods and on the radio is ongoing work.
> 
> We need to ask Mike for the latest status or try to look it up.
> 
> I doubt you come further with the regspy stuff.
> 
> Cheers,
> Hermann
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


