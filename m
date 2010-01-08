Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:61047 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab0AHM7G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2010 07:59:06 -0500
Received: by fxm25 with SMTP id 25so12590589fxm.21
        for <linux-media@vger.kernel.org>; Fri, 08 Jan 2010 04:59:05 -0800 (PST)
Content-Type: text/plain; charset=iso-8859-2; format=flowed; delsp=yes
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: WinTV Radio rev-c121 remote support
References: <d49708701001051211r447f6293g59dfac2b1af2818c@mail.gmail.com>
Date: Fri, 08 Jan 2010 13:59:14 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Samuel Rakitnican" <samuel.rakitnican@gmail.com>
Message-ID: <op.u57s00mk6dn9rq@crni.lan>
In-Reply-To: <d49708701001051211r447f6293g59dfac2b1af2818c@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 05 Jan 2010 21:11:59 +0100, Samuel Rakitnièan  
<samuel.rakitnican@gmail.com> wrote:

> Hi,
>
> I have an old bt878 based analog card. It's 'Hauppauge WinTV Radio'  
> model 44914,
> rev C121.
>
> I'm trying to workout support for this shipped remote control. I have
> tried to add
> following lines to bttv-cards.c and bttv-input.c, but that gived
> really bad results
> (dmesg output is in attachment).
>
>
> diff -r b6b82258cf5e linux/drivers/media/video/bt8xx/bttv-cards.c
> --- a/linux/drivers/media/video/bt8xx/bttv-cards.c      Thu Dec 31  
> 19:14:54 2009
> -0200
> +++ b/linux/drivers/media/video/bt8xx/bttv-cards.c      Tue Jan 05  
> 13:25:09 2010
> +0100
> @@ -491,6 +491,7 @@
>                 .pll            = PLL_28,
>                 .tuner_type     = UNSET,
>                 .tuner_addr     = ADDR_UNSET,
> +               .has_remote     = 1,
>         },
>         [BTTV_BOARD_MIROPRO] = {
>                 .name           = "MIRO PCTV pro",
> diff -r b6b82258cf5e linux/drivers/media/video/bt8xx/bttv-input.c
> --- a/linux/drivers/media/video/bt8xx/bttv-input.c      Thu Dec 31  
> 19:14:54 2009
> -0200
> +++ b/linux/drivers/media/video/bt8xx/bttv-input.c      Tue Jan 05  
> 13:25:09 2010
> +0100
> @@ -341,6 +341,12 @@
>                 ir->last_gpio    =  
> ir_extract_bits(bttv_gpio_read(&btv->c),
>                                                    ir->mask_keycode);
>                 break;
> +       case BTTV_BOARD_HAUPPAUGE878:
> +               ir_codes         = &ir_codes_pctv_sedna_table;
> +               ir->mask_keycode = 0;
> +               ir->mask_keyup   = 0;
> +               //ir->polling      = 50;
> +               break;
>         }
>         if (NULL == ir_codes) {
>                 dprintk(KERN_INFO "Ooops: IR config error [card=%d]\n",
> btv->c.type);
>
>
>
> root@crni:~/v4l-dvb# modprobe bttv
> Segmentation fault
> root@crni:~/v4l-dvb#
> Message from syslogd@crni at Tue Jan  5 13:03:08 2010 ...
> crni kernel: Oops: 0000 [#1] SMP
>
>  [...]
>
>
>
>
> So I guess that's not going to work. I have read in
> wiki that Hauppauge cards needs ir-kbd-i2c, so I tried with that too, but
> then similar error like previous happens when I try 'modprobe ir-kbd-i2c  
> debug=1
> hauppauge=1' as well as just 'modprobe ir-kbd-i2c'.
>
> Can I have a little pointer what to do?
>
> Regards,
> Samuel
> --
> Card: http://linuxtv.org/wiki/index.php/File:Wintv-radio-C121.jpg
> Remote: http://linuxtv.org/wiki/index.php/File:Wintv-radio-remote.jpg


Did some investigation, maybe this can help to clarify some things. Still  
didn't get any response in dmesg from remote.


Chips:
U1 - ST EEPROM - 24C02 4 ST K143L
U2 - Fairchild Dual 4-Channel Analog Multiplexer/Demultiplexer - CD4052BCM
U5 - Microchip EPROM - PIC16C54C 20/S3 0117H08 - IR Remote Control?
U6 - PTC Headphone Driver IC - PT2308-S
In metal can: EPCOS G1984D - demodulator

i2c_scan:
bttv0: i2c scan: found device @ 0x30  [IR (hauppauge)]
bttv0: i2c scan: found device @ 0xa0  [eeprom]
bttv0: i2c scan: found device @ 0xc2  [tuner (analog)]

eeprom dump:
tveeprom 1-0050: full 256-byte eeprom dump:
tveeprom 1-0050: 00: 84 12 00 00 05 50 0e 7f 04 15 01 72 af 91 14 8d
tveeprom 1-0050: 10: 00 00 00 00 05 84 0a 00 01 01 20 77 00 40 62 6c
tveeprom 1-0050: 20: 3c 00 74 02 01 00 02 79 b3 00 00 00 00 00 00 00
tveeprom 1-0050: 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
tveeprom 1-0050: 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
tveeprom 1-0050: 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
tveeprom 1-0050: 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
tveeprom 1-0050: 70: 00 00 00 00 00 00 00 00 00 00 00 00 13 eb 00 70
tveeprom 1-0050: 80: 84 12 00 00 05 50 0e 7f 04 15 01 72 af 91 14 8d
tveeprom 1-0050: 90: 00 00 00 00 05 84 0a 00 01 01 20 77 00 40 62 6c
tveeprom 1-0050: a0: 3c 00 74 02 01 00 02 79 b3 00 00 00 00 00 00 00
tveeprom 1-0050: b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
tveeprom 1-0050: c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
tveeprom 1-0050: d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
tveeprom 1-0050: e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
tveeprom 1-0050: f0: 00 00 00 00 00 00 00 00 00 00 00 00 13 eb 00 70
tveeprom 1-0050: Tag [00] + 17 bytes: 05 50 0e 7f 04 15 01 72 af 91 14 8d  
00 00 00 00 05
tveeprom 1-0050: Tag [01] + 9 bytes: 01 20 77 00 40 62 6c 3c 00
tveeprom 1-0050: Tag [02] + 3 bytes: 01 00 02

modprobe ir-kbd-i2c debug=1
ir-kbd-i2c: probe 0x1a @ bt878 #0 [sw]: no
ir-kbd-i2c: probe 0x18 @ bt878 #0 [sw]: yes


linux/drivers/media/video/ir-kbd-i2c.c

    417 	case 0x18:
    418 	case 0x1a:
    419 		name        = "Hauppauge";
    420 		//ir->get_key = get_key_haup;
    421 		ir_type     = IR_TYPE_RC5;
    422 		if (hauppauge == 1) {
    423 			ir_codes    = &ir_codes_hauppauge_new_table;
    424 		} else {
    425 			ir_codes    = &ir_codes_rc5_tv_table;
    426 		}
    427 		break;

If I comment above line segfault does not occur. Tried the remote under  
windows, and is working properly.
