Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:57143 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab1EVOS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 10:18:28 -0400
Message-ID: <1306073899.4dd91b2bb7408@imp.free.fr>
Date: Sun, 22 May 2011 16:18:19 +0200
From: wallak@free.fr
To: linux-media@vger.kernel.org,
	Nicholas Leahy <silvercordiagsr@hotmail.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AverMedia A306 (cx23385, xc3028, af9013) (A577 too ?)
References: <1305838128.4dd582301742e@imp.free.fr> <SNT124-W4826814BFEF35D02DDBB99AC710@phx.gbl>
In-Reply-To: <SNT124-W4826814BFEF35D02DDBB99AC710@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Quoting Nicholas Leahy <silvercordiagsr@hotmail.com>:

>
> Hi Wallak
> How do you see the chips on the I2C bus? I have been trying to get a DiVCO
> card to work (it uses the same CX23885)
> I dont get the following parts
> CX23885_BOARD_AVERMEDIA_A306:> + // ?? PIO0: 1:on 0:nothing work> + // ??
> PIO1: demodulator address 1: 0x1c, 0:0x1d ??> + // ?? PIO2: tuner reset ?> +
> // ?? PIO3: demodulator reset ?> + printk(KERN_INFO "gpio...\n");
>


  Once the CX23885 driver is loaded, and the new board recognized, 3 new i2c bus
are added. The state may be dumped with the i2c-tools-3.0.3 package,  e.g.:

i2c-tools-3.0.3/tools/i2cdetect -l
...
    i2c-12      unknown         cx23885[0]
    i2c-13      unknown         cx23885[0]                                      
                       # SPD EEPROM
    i2c-14      unknown         cx23885[0]                                      
                       # SPD EEPROM

Adding the subsystem pci IDs is enough to be sure that the CX23885 driver is
loaded properly (the previous patch add theses lines).

After this stage; the following command dump an I2C bus:
i2c-tools-3.0.3/tools/i2cdetect -y $[12 + 0]

     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- 1c -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --

The DVB-T chip is here at the address : 0x1c

>
> and GPIO stuff
>
>
>
> Cheers Nick
>
> > Date: Thu, 19 May 2011 22:48:48 +0200
> > From: wallak@free.fr
> > To: linux-dvb@linuxtv.org
> > Subject: [linux-dvb] AverMedia A306 (cx23385, xc3028, af9013) (A577 too ?)
> >
> > Hello All,
> >
> > I've tried to use my A306 board on my system. All the main chips are fully
> > supported by linux.
> >
> > At this stage the CX23385 and the tuner: xc3028 seem to respond properly.
> But
> > the DVB-T chip (af9013) is silent. Nevertheless both chips are visible on
> the
> > I2C bus.
> >
> > I've no full datasheet of theses chips. with exception of the af9013 where
> this
> > information is available:
> > http://wenku.baidu.com/view/42240f72f242336c1eb95e08.html
> >
> > At this stage the CLK signal of the DVB-T chip may be missing or something
> is
> > wrong elsewhere.
> >
>
> > _______________________________________________
> > linux-dvb users mailing list
> > For V4L/DVB development, please use instead linux-media@vger.kernel.org
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>


Best Regards,
Wallak,
