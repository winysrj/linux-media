Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:35322 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470Ab0CETs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Mar 2010 14:48:57 -0500
Message-ID: <4B916006.90303@arcor.de>
Date: Fri, 05 Mar 2010 20:48:22 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: tm6000 and Hauppauge HVR-900H
References: <4B913F2E.1080703@arcor.de> <4B9144E6.5000109@redhat.com>
In-Reply-To: <4B9144E6.5000109@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Am 05.03.2010 18:52, schrieb Mauro Carvalho Chehab:
> Stefan,
>
> Stefan Ringel wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>>
>> Hi Mauro, Devin,
>>
>> I study the tm6000 source and I have any questions.
>>
>> 1. I tested my stick (terratec cinery hybrid) with the windows
>> driver from the Hauppauge HVR-900H and it's work. So I think that
>> have the same driver setting.
>
> It is very likely that the original driver has some code to probe
> the devices and to read certain configurations at the board's
> eeprom. At least on the USB sniffs I've saw, some probing is
> noticed, and several eeprom addresses are read. So, the fact that
> both devices work with the same driver doesn't mean that both use
> the same GPIO's.
>
>> In the board struct is setting tuner reset gpio with label
>> TM6000_GPIO_2, but is that not a tm6010? Then it must set to
>> TM6010_GPIO_2. And can I add  the setting from terratec cinery
>> hybrid for the Hauppauge HVR-900H?
>
> It should be noticed that all GPIO addresses that exists for tm6000
> also exists for tm6010, but with different names:
>
> #define TM6000_GPIO_1           0x102 #define TM6000_GPIO_2
> 0x103 #define TM6000_GPIO_3           0x104 #define TM6000_GPIO_4
> 0x300 #define TM6000_GPIO_5           0x301 #define TM6000_GPIO_6
> 0x304 #define TM6000_GPIO_7           0x305
>
> #define TM6010_GPIO_0      0x0102 #define TM6010_GPIO_1
> 0x0103 #define TM6010_GPIO_2      0x0104 #define TM6010_GPIO_3
> 0x0105 #define TM6010_GPIO_4      0x0106 #define TM6010_GPIO_5
> 0x0107 #define TM6010_GPIO_6      0x0300 #define TM6010_GPIO_7
> 0x0301 #define TM6010_GPIO_9      0x0305
>
> So, maybe there are some issues there.
>
I know that. You misunderstand me, I mean

[TM6010_BOARD_HAUPPAUGE_900H] = {
            .name = "Hauppauge HVR-900H",
            .tuner_type = TUNER_XC2028, /* has a XC3028 */
            .tuner_addr = 0xc2 >> 1,
            .demod_addr = 0x1e >> 1,
            .type = TM6010,  /* that says it's tm6010 */
            .caps = {
            .has_tuner = 1,
            .has_dvb = 1,
            .has_zl10353 = 1,
            .has_eeprom = 1,
             },
            .gpio_addr_tun_reset = TM6000_GPIO_2, /* but here use it's
for TM6000 and I think it must use here TM6010_GPIO_2 */
},


> AFAIK, this device uses those addresses:
>
> GPIO_1 MT352_Reset GPIO_2 XC3028 Tuner_Reset GPIO_4 MT352_Sleep
>
> Anyway, the better is to double-check those addresses, trying the
> driver with both TM6000 and TM6010 addresses to be sure.
>
This gpio use also the terratec cinery cybrid, but I think that TM6010
use also this gpio for the same functions.

>> 2. In the board struct have not all a tuner reset gpio.

TM5600_BOARD_10MOONS_UT330, TM6000_BOARD_ADSTECH_DUAL_TV have no
.gpio_addr_tun_reset field.

>> 3. Is it better when we implemented the firmware value in the
>> board struct?
>
switch(dev->model) {
case TM6010_BOARD_HAUPPAUGE_900H:
case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
        ctl.fname = "xc3028L-v36.fw";
        break;
default:
        if (dev->dev_type == TM6010)
            ctl.fname = "xc3028-v27.fw";
        else
            ctl.fname = "tm6000-xc3028.fw";
        }

I mean here, if we use the firmware defination from here into the
board struct for example:

[TM6010_BOARD_HAUPPAUGE_900H] = {
            .name = "Hauppauge HVR-900H",
            .tuner_type = TUNER_XC2028, /* has a XC3028 */
            .tuner_addr = 0xc2 >> 1,
            .demod_addr = 0x1e >> 1,
            .type = TM6010,
            .caps = {
                    .has_tuner = 1,
                    .has_dvb = 1,
                    .has_zl10353 = 1,
                    .has_eeprom = 1,
             },
            .gpio_addr_tun_reset = TM6000_GPIO_2,
            .tuner_firmware = "xc3028L-v36.fw",  /* here */
},

and then without the switch(dev->model) and use directly ctl.fname =
dev->tuner_firmware.
> Sorry, but I didn't understand your questions.
>

Stefan Ringel
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQEcBAEBAgAGBQJLkWAGAAoJEDX/lZlmjdJlbKMH/j4T9fadC9JFd3HaM0M9UqIE
SGGY1MqcQfvH1q8Clyd8iJeRgcJxJYFnHF5H8WpsN80mJXNHvKChqPhtwnTRaYgc
tZg2BZ23jwQdweAabUMbKQvZDk6Zm3L11ln00Pdbq9ECcaoq/xSclomyHFdAPQrw
V47KmLpIkdYjSkgD/f/m58lhbVMraNkcGYZ8oFhJYWyDIvYmk4oxyJIHubzN+8SZ
qlw4ex7+KvgzBSuLPVOPctkXY1dLV0AaIuOhJgfXAODU7lLaVoFzDb25SVZkGFEo
FdnEPFvDn57vgfxhtld02CtpCDS8JxGORTZKuIk5BiyG5UW2r2CDCCbGzfiLByk=
=TNZ3
-----END PGP SIGNATURE-----

