Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1F3OK2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 10:10:28 -0400
Message-ID: <4E0C83CF.2070401@redhat.com>
Date: Thu, 30 Jun 2011 11:10:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Roman Byshko <rbyshko@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: em28xx / ADS Tech USB Instant TV (USBAV-704)
References: <AANLkTimC48YCZQurf-MO+Fy4O3Kp7Y8c=Vnnfva08f=0@mail.gmail.com> <BANLkTi=SgxDYij3AC=eLfCd2DNuaPMks0g@mail.gmail.com>
In-Reply-To: <BANLkTi=SgxDYij3AC=eLfCd2DNuaPMks0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-05-2011 15:13, Roman Byshko escreveu:
> Hi,
> 
> unfortunately nobody replied to me, so I contacted Mauro (thank you!)
> and got some guidance.
> 
> According to http://www.linuxtv.org/wiki/index.php/Bus_snooping/sniffing
> I sniffed my device
> 
> http://www.linuxtv.org/wiki/index.php/ADS_Tech_Instant_TV_(USBAV-704)
> 
> two times. Just in case. The outputs are not identical. Is it ok?
> 
> Please find both files attached. I could have adjusted em28xx_cards.c
> by myself, but I know too little. So
> can you please do it or give me hints if this takes too much time.

This device is not touching at the GPIO bits, according with your logs
with is something unusual, but a few devices don't need GPIO's.

The logs shows that the I2C device addresses are:
	0x4a - saa7113h
	0x60 - not sure... it may be an IR chip. Maybe the Sonix is used as an IR decoder?
	0x86 - tda9887 (part of the tuner)
	0xc6 - Probably, this is the tuner

It seems close to EM2820_BOARD_GADMEI_TVR200 (card=62):

        [EM2820_BOARD_GADMEI_TVR200] = {
                .name         = "Gadmei TVR200",
                .tuner_type   = TUNER_LG_PAL_NEW_TAPC,
                .tda9887_conf = TDA9887_PRESENT,
                .decoder      = EM28XX_SAA711X,
                .input        = { {
                        .type     = EM28XX_VMUX_TELEVISION,
                        .vmux     = SAA7115_COMPOSITE2,
                        .amux     = EM28XX_AMUX_LINE_IN,
                }, {
                        .type     = EM28XX_VMUX_COMPOSITE1,
                        .vmux     = SAA7115_COMPOSITE0,
                        .amux     = EM28XX_AMUX_LINE_IN,
                }, {
                        .type     = EM28XX_VMUX_SVIDEO,
                        .vmux     = SAA7115_SVIDEO3,
                        .amux     = EM28XX_AMUX_LINE_IN,
                } },
        },


But, eventually, the audio/video interfaces are on different places.

You'll basically need to write an entry similar to the above, replacing the tuner type
by the one that represents the tuner FQ1216ME, and replace the .vmux/.amux entries to
match the entries used on your device. It shouldn't be hard to get the vmux entry by
taking a look at the "i2c_master_send(0x4a>>1," logs. All you need is to check at the
saa7113 datasheet (publicly available), and see what registers represent the video ports
(or look at the saa7115 driver). You'll also need to get the commands from your log that
are programming the audio mux register.

As there are not that much options, you might also use a trial and error approach, as
using the wrong values for vmux/amux won't damage your card.

It doesn't seem hard to add support for it, but you'll need to carefully check each
entry.

As this board doesn't have an eeprom, autodetecting it is tricky. For your tests, you'll
need to explicitly tell the driver to use your new entry, with card= modprobe option.

After having it done, please send us the patches, and the logs. It may be possible to
add an autodetection for it, based on the I2C addresses in usage (0xc6 is not a common
address, so this will probably work).

After having the video/audio working, we may try to figure out how IR works on it. From
your logs, it seems that it reads from 0x60 device only:

$ grep 0x60 /tmp/cmds2.txt 
i2c_master_recv(0x60>>1, &buf, 0x01); /* 12 */
i2c_master_recv(0x60>>1, &buf, 0x01); /* ff */
i2c_master_recv(0x60>>1, &buf, 0x01); /* ff */
i2c_master_recv(0x60>>1, &buf, 0x01); /* ff */
i2c_master_recv(0x60>>1, &buf, 0x01); /* ff */
i2c_master_recv(0x60>>1, &buf, 0x01); /* ff */
i2c_master_recv(0x60>>1, &buf, 0x01); /* ff */

Probably, a value different than 0xff means that a keystroke happened on your IR.

Thanks,
Mauro
