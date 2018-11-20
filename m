Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.eclipso.de ([217.69.254.104]:58237 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbeKTUUV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 15:20:21 -0500
Received: from roadrunner.suse (p5B31818E.dip0.t-ipconnect.de [91.49.129.142])
        by mail.eclipso.de with ESMTPS id 3E45F2F8
        for <linux-media@vger.kernel.org>; Tue, 20 Nov 2018 10:52:02 +0100 (CET)
From: stakanov <stakanov@eclipso.eu>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Date: Tue, 20 Nov 2018 10:51:59 +0100
Message-ID: <1626577.KffMZP8tvO@roadrunner.suse>
In-Reply-To: <20181120071810.7c8583b3@coco.lan>
References: <s5hbm6l5cdi.wl-tiwai@suse.de> <3267610.1jAA2Txdp3@roadrunner.suse> <20181120071810.7c8583b3@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In data martedì 20 novembre 2018 10:18:10 CET, Mauro Carvalho Chehab ha 
scritto:
> Em Tue, 20 Nov 2018 09:07:57 +0100
> 
> stakanov <stakanov@eclipso.eu> escreveu:
> > In data martedì 20 novembre 2018 00:58:41 CET, Mauro Carvalho Chehab ha
> > 
> > scritto:
> > > Em Tue, 20 Nov 2018 00:19:54 +0100
> > > 
> > > stakanov <stakanov@eclipso.eu> escreveu:
> > > > In data martedì 20 novembre 2018 00:08:45 CET, Mauro Carvalho Chehab
> > > > ha
> > > > 
> > > > scritto:
> > > > >  uname -a
> > > > >  
> > > > > > Linux silversurfer 4.20.0-rc3-1.g7e16618-default #1 SMP PREEMPT
> > > > > > Mon
> > > > > > Nov 19
> > > > > > 18:54:15 UTC 2018 (7e16618) x86_64 x86_64 x86_64 GNU/Linux
> > > >  
> > > >  uname -a
> > > >  
> > > > > Linux silversurfer 4.20.0-rc3-1.g7e16618-default #1 SMP PREEMPT Mon
> > > > > Nov
> > > > > 19
> > > > > 18:54:15 UTC 2018 (7e16618) x86_64 x86_64 x86_64 GNU/Linux
> > > > 
> > > > from
> > > > https://download.opensuse.org/repositories/home:/tiwai:/bsc1116374/
> > > > standard/x86_64/
> > > > 
> > > > So I booted this one, should be the right one.
> > > > sudo dmesg | grep -i b2c2   should give these additional messages?
> > > > 
> > > > If Takashi is still around, he could confirm.
> > > 
> > > Well, if the patch got applied, you should  now be getting messages
> > > similar
> > > 
> > > (but not identical) to:
> > > 	dvb_frontend_get_frequency_limits: frequencies: tuner:
> > > 	9150000...2150000,
> > > 
> > > frontend: 9150000...2150000 dvb_pll_attach: delsys: 5, frequency range:
> > > 9150000..2150000
> > > 
> > > > _________________________________________________________________
> > > > ________________________________________________________
> > > > Ihre E-Mail-Postfächer sicher & zentral an einem Ort. Jetzt wechseln
> > > > und
> > > > alte E-Mail-Adresse mitnehmen! https://www.eclipso.de
> > > 
> > > Thanks,
> > > Mauro
> > 
> > My bad.
> > With just dmesg:
> > 
> > [   89.399887] dvb_frontend_get_frequency_limits: frequencies: tuner:
> > 950000...2150000, frontend: 950000000...2150000000
> > [   95.020149] dvb_frontend_get_frequency_limits: frequencies: tuner:
> > 950000...2150000, frontend: 950000000...2150000000
> > [   95.152049] dvb_frontend_get_frequency_limits: frequencies: tuner:
> > 950000...2150000, frontend: 950000000...2150000000
> > [   95.152058] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0
> > frequency 1880000 out of range (950000..2150)
> > [   98.356539] dvb_frontend_get_frequency_limits: frequencies: tuner:
> > 950000...2150000, frontend: 950000000...2150000000
> > [   98.480372] dvb_frontend_get_frequency_limits: frequencies: tuner:
> > 950000...2150000, frontend: 950000000...2150000000
> > [   98.480381] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0
> > frequency 1587500 out of range (950000..2150)
> > [  100.016823] dvb_frontend_get_frequency_limits: frequencies: tuner:
> > 950000...2150000, frontend: 950000000...2150000000
> > [  100.140619] dvb_frontend_get_frequency_limits: frequencies: tuner:
> > 950000...2150000, frontend: 950000000...2150000000
> > [  100.140629] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0
> > frequency 1353500 out of range (950000..2150)
> > [  105.361166] dvb_frontend_get_frequency_limits: frequencies: tuner:
> > 950000...2150000, frontend: 950000000...2150000000
> > [  105.492972] dvb_frontend_get_frequency_limits: frequencies: tuner:
> > 950000...2150000, frontend: 950000000...2150000000
> > [  105.492977] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0
> > frequency 1944750 out of range (950000..2150)
> > 
> > 
> > Which is, I guess the info you need?
> 
> Yes, partially. Clearly, the problem is coming from the tuner, with is
> not reporting the frequency in Hz, but I was hoping to see another
> message from the tuner driver, in order for me to be sure about what's
> happening there.
> 
> Didn't you get any message that starts with "dvb_pll_attach"?
> 
> The thing with Flexcop is that there are several variations, each one
> with a different tuner driver.
> 
> Anyway, I guess I found the trouble: it is trying to use the DVB
> cache to check the delivery system too early (at attach time).
> 
> I suspect that the enclosed patch will fix the issue. Could you please
> test it?
> 
> Thanks!
> Mauro
> 
> 
> diff --git a/drivers/media/dvb-frontends/dvb-pll.c
> b/drivers/media/dvb-frontends/dvb-pll.c index 6d4b2eec67b4..390ecc915096
> 100644
> --- a/drivers/media/dvb-frontends/dvb-pll.c
> +++ b/drivers/media/dvb-frontends/dvb-pll.c
> @@ -80,8 +80,8 @@ struct dvb_pll_desc {
> 
>  static const struct dvb_pll_desc dvb_pll_thomson_dtt7579 = {
>  	.name  = "Thomson dtt7579",
> -	.min   = 177000000,
> -	.max   = 858000000,
> +	.min   = 177 * MHz,
> +	.max   = 858 * MHz,
>  	.iffreq= 36166667,
>  	.sleepdata = (u8[]){ 2, 0xb4, 0x03 },
>  	.count = 4,
> @@ -102,8 +102,8 @@ static void thomson_dtt759x_bw(struct dvb_frontend *fe,
> u8 *buf)
> 
>  static const struct dvb_pll_desc dvb_pll_thomson_dtt759x = {
>  	.name  = "Thomson dtt759x",
> -	.min   = 177000000,
> -	.max   = 896000000,
> +	.min   = 177 * MHz,
> +	.max   = 896 * MHz,
>  	.set   = thomson_dtt759x_bw,
>  	.iffreq= 36166667,
>  	.sleepdata = (u8[]){ 2, 0x84, 0x03 },
> @@ -126,8 +126,8 @@ static void thomson_dtt7520x_bw(struct dvb_frontend *fe,
> u8 *buf)
> 
>  static const struct dvb_pll_desc dvb_pll_thomson_dtt7520x = {
>  	.name  = "Thomson dtt7520x",
> -	.min   = 185000000,
> -	.max   = 900000000,
> +	.min   = 185 * MHz,
> +	.max   = 900 * MHz,
>  	.set   = thomson_dtt7520x_bw,
>  	.iffreq = 36166667,
>  	.count = 7,
> @@ -144,8 +144,8 @@ static const struct dvb_pll_desc
> dvb_pll_thomson_dtt7520x = {
> 
>  static const struct dvb_pll_desc dvb_pll_lg_z201 = {
>  	.name  = "LG z201",
> -	.min   = 174000000,
> -	.max   = 862000000,
> +	.min   = 174 * MHz,
> +	.max   = 862 * MHz,
>  	.iffreq= 36166667,
>  	.sleepdata = (u8[]){ 2, 0xbc, 0x03 },
>  	.count = 5,
> @@ -160,8 +160,8 @@ static const struct dvb_pll_desc dvb_pll_lg_z201 = {
> 
>  static const struct dvb_pll_desc dvb_pll_unknown_1 = {
>  	.name  = "unknown 1", /* used by dntv live dvb-t */
> -	.min   = 174000000,
> -	.max   = 862000000,
> +	.min   = 174 * MHz,
> +	.max   = 862 * MHz,
>  	.iffreq= 36166667,
>  	.count = 9,
>  	.entries = {
> @@ -182,8 +182,8 @@ static const struct dvb_pll_desc dvb_pll_unknown_1 = {
>   */
>  static const struct dvb_pll_desc dvb_pll_tua6010xs = {
>  	.name  = "Infineon TUA6010XS",
> -	.min   =  44250000,
> -	.max   = 858000000,
> +	.min   = 44250 * kHz,
> +	.max   = 858 * MHz,
>  	.iffreq= 36125000,
>  	.count = 3,
>  	.entries = {
> @@ -196,8 +196,8 @@ static const struct dvb_pll_desc dvb_pll_tua6010xs = {
>  /* Panasonic env57h1xd5 (some Philips PLL ?) */
>  static const struct dvb_pll_desc dvb_pll_env57h1xd5 = {
>  	.name  = "Panasonic ENV57H1XD5",
> -	.min   =  44250000,
> -	.max   = 858000000,
> +	.min   = 44250 * kHz,
> +	.max   = 858 * MHz,
>  	.iffreq= 36125000,
>  	.count = 4,
>  	.entries = {
> @@ -220,8 +220,8 @@ static void tda665x_bw(struct dvb_frontend *fe, u8 *buf)
> 
>  static const struct dvb_pll_desc dvb_pll_tda665x = {
>  	.name  = "Philips TDA6650/TDA6651",
> -	.min   =  44250000,
> -	.max   = 858000000,
> +	.min   = 44250 * kHz,
> +	.max   = 858 * MHz,
>  	.set   = tda665x_bw,
>  	.iffreq= 36166667,
>  	.initdata = (u8[]){ 4, 0x0b, 0xf5, 0x85, 0xab },
> @@ -254,8 +254,8 @@ static void tua6034_bw(struct dvb_frontend *fe, u8 *buf)
> 
>  static const struct dvb_pll_desc dvb_pll_tua6034 = {
>  	.name  = "Infineon TUA6034",
> -	.min   =  44250000,
> -	.max   = 858000000,
> +	.min   = 44250 * kHz,
> +	.max   = 858 * MHz,
>  	.iffreq= 36166667,
>  	.count = 3,
>  	.set   = tua6034_bw,
> @@ -278,8 +278,8 @@ static void tded4_bw(struct dvb_frontend *fe, u8 *buf)
> 
>  static const struct dvb_pll_desc dvb_pll_tded4 = {
>  	.name = "ALPS TDED4",
> -	.min = 47000000,
> -	.max = 863000000,
> +	.min =  47 * MHz,
> +	.max = 863 * MHz,
>  	.iffreq= 36166667,
>  	.set   = tded4_bw,
>  	.count = 4,
> @@ -296,8 +296,8 @@ static const struct dvb_pll_desc dvb_pll_tded4 = {
>   */
>  static const struct dvb_pll_desc dvb_pll_tdhu2 = {
>  	.name = "ALPS TDHU2",
> -	.min = 54000000,
> -	.max = 864000000,
> +	.min =  54 * MHz,
> +	.max = 864 * MHz,
>  	.iffreq= 44000000,
>  	.count = 4,
>  	.entries = {
> @@ -313,8 +313,8 @@ static const struct dvb_pll_desc dvb_pll_tdhu2 = {
>   */
>  static const struct dvb_pll_desc dvb_pll_samsung_tbmv = {
>  	.name = "Samsung TBMV30111IN / TBMV30712IN1",
> -	.min = 54000000,
> -	.max = 860000000,
> +	.min =  54 * MHz,
> +	.max = 860 * MHz,
>  	.iffreq= 44000000,
>  	.count = 6,
>  	.entries = {
> @@ -332,8 +332,8 @@ static const struct dvb_pll_desc dvb_pll_samsung_tbmv =
> { */
>  static const struct dvb_pll_desc dvb_pll_philips_sd1878_tda8261 = {
>  	.name  = "Philips SD1878",
> -	.min   =  950000,
> -	.max   = 2150000,
> +	.min   =  950 * MHz,
> +	.max   = 2150 * MHz,
>  	.iffreq= 249, /* zero-IF, offset 249 is to round up */
>  	.count = 4,
>  	.entries = {
> @@ -398,8 +398,8 @@ static void opera1_bw(struct dvb_frontend *fe, u8 *buf)
> 
>  static const struct dvb_pll_desc dvb_pll_opera1 = {
>  	.name  = "Opera Tuner",
> -	.min   =  900000,
> -	.max   = 2250000,
> +	.min   =  900 * MHz,
> +	.max   = 2250 * MHz,
>  	.initdata = (u8[]){ 4, 0x08, 0xe5, 0xe1, 0x00 },
>  	.initdata2 = (u8[]){ 4, 0x08, 0xe5, 0xe5, 0x00 },
>  	.iffreq= 0,
> @@ -445,8 +445,8 @@ static void samsung_dtos403ih102a_set(struct
> dvb_frontend *fe, u8 *buf) /* unknown pll used in Samsung DTOS403IH102A
> DVB-C tuner */
>  static const struct dvb_pll_desc dvb_pll_samsung_dtos403ih102a = {
>  	.name   = "Samsung DTOS403IH102A",
> -	.min    =  44250000,
> -	.max    = 858000000,
> +	.min    = 44250 * kHz,
> +	.max    = 858 * MHz,
>  	.iffreq =  36125000,
>  	.count  = 8,
>  	.set    = samsung_dtos403ih102a_set,
> @@ -465,8 +465,8 @@ static const struct dvb_pll_desc
> dvb_pll_samsung_dtos403ih102a = { /* Samsung TDTC9251DH0 DVB-T NIM, as used
> on AirStar 2 */
>  static const struct dvb_pll_desc dvb_pll_samsung_tdtc9251dh0 = {
>  	.name	= "Samsung TDTC9251DH0",
> -	.min	=  48000000,
> -	.max	= 863000000,
> +	.min	=  48 * MHz,
> +	.max	= 863 * MHz,
>  	.iffreq	=  36166667,
>  	.count	= 3,
>  	.entries = {
> @@ -479,8 +479,8 @@ static const struct dvb_pll_desc
> dvb_pll_samsung_tdtc9251dh0 = { /* Samsung TBDU18132 DVB-S NIM with TSA5059
> PLL, used in SkyStar2 DVB-S 2.3 */ static const struct dvb_pll_desc
> dvb_pll_samsung_tbdu18132 = {
>  	.name = "Samsung TBDU18132",
> -	.min	=  950000,
> -	.max	= 2150000, /* guesses */
> +	.min	=  950 * MHz,
> +	.max	= 2150 * MHz, /* guesses */
>  	.iffreq = 0,
>  	.count = 2,
>  	.entries = {
> @@ -500,8 +500,8 @@ static const struct dvb_pll_desc
> dvb_pll_samsung_tbdu18132 = { /* Samsung TBMU24112 DVB-S NIM with SL1935
> zero-IF tuner */
>  static const struct dvb_pll_desc dvb_pll_samsung_tbmu24112 = {
>  	.name = "Samsung TBMU24112",
> -	.min	=  950000,
> -	.max	= 2150000, /* guesses */
> +	.min	=  950 * MHz,
> +	.max	= 2150 * MHz, /* guesses */
>  	.iffreq = 0,
>  	.count = 2,
>  	.entries = {
> @@ -521,8 +521,8 @@ static const struct dvb_pll_desc
> dvb_pll_samsung_tbmu24112 = { * 822 - 862   1  *  0   0   1   0   0   0  
> 0x88 */
>  static const struct dvb_pll_desc dvb_pll_alps_tdee4 = {
>  	.name = "ALPS TDEE4",
> -	.min	=  47000000,
> -	.max	= 862000000,
> +	.min	=  47 * MHz,
> +	.max	= 862 * MHz,
>  	.iffreq	=  36125000,
>  	.count = 4,
>  	.entries = {
> @@ -537,8 +537,8 @@ static const struct dvb_pll_desc dvb_pll_alps_tdee4 = {
>  /* CP cur. 50uA, AGC takeover: 103dBuV, PORT3 on */
>  static const struct dvb_pll_desc dvb_pll_tua6034_friio = {
>  	.name   = "Infineon TUA6034 ISDB-T (Friio)",
> -	.min    =  90000000,
> -	.max    = 770000000,
> +	.min    =  90 * MHz,
> +	.max    = 770 * MHz,
>  	.iffreq =  57000000,
>  	.initdata = (u8[]){ 4, 0x9a, 0x50, 0xb2, 0x08 },
>  	.sleepdata = (u8[]){ 4, 0x9a, 0x70, 0xb3, 0x0b },
> @@ -553,8 +553,8 @@ static const struct dvb_pll_desc dvb_pll_tua6034_friio =
> { /* Philips TDA6651 ISDB-T, used in Earthsoft PT1 */
>  static const struct dvb_pll_desc dvb_pll_tda665x_earth_pt1 = {
>  	.name   = "Philips TDA6651 ISDB-T (EarthSoft PT1)",
> -	.min    =  90000000,
> -	.max    = 770000000,
> +	.min    =  90 * MHz,
> +	.max    = 770 * MHz,
>  	.iffreq =  57000000,
>  	.initdata = (u8[]){ 5, 0x0e, 0x7f, 0xc1, 0x80, 0x80 },
>  	.count = 10,
> @@ -845,18 +845,11 @@ struct dvb_frontend *dvb_pll_attach(struct
> dvb_frontend *fe, int pll_addr,
> 
>  	strncpy(fe->ops.tuner_ops.info.name, desc->name,
>  		sizeof(fe->ops.tuner_ops.info.name));
> -	switch (c->delivery_system) {
> -	case SYS_DVBS:
> -	case SYS_DVBS2:
> -	case SYS_TURBO:
> -	case SYS_ISDBS:
> -		fe->ops.tuner_ops.info.frequency_min_hz = desc->min * kHz;
> -		fe->ops.tuner_ops.info.frequency_max_hz = desc->max * kHz;
> -		break;
> -	default:
> -		fe->ops.tuner_ops.info.frequency_min_hz = desc->min;
> -		fe->ops.tuner_ops.info.frequency_max_hz = desc->max;
> -	}
> +
> +	fe->ops.tuner_ops.info.frequency_min_hz = desc->min;
> +	fe->ops.tuner_ops.info.frequency_max_hz = desc->max;
> +printk("%s: delsys: %d, frequency range: %u..%u\n",
> +       __func__, c->delivery_system,
> fe->ops.tuner_ops.info.frequency_min_hz,
> fe->ops.tuner_ops.info.frequency_max_hz);
> 
>  	if (!desc->initdata)
>  		fe->ops.tuner_ops.init = NULL;


I will as soon as it will be ready. 
BTW, I found what you search for (was a bit hidden in the jungle):


dvb_pll_attach: delsys: 0, frequency range: 950000..2150000
[    5.213817] b2c2-flexcop: found 'ST STV0299 DVB-S' .
[    5.213820] b2c2_flexcop_pci 0000:06:06.0: DVB: registering adapter 0 
frontend 0 (ST STV0299 DVB-S)...
[    5.213876] b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DVB-S rev 
2.6' at the 'PCI' bus controlled by a 'FlexCopIIb' complete




_________________________________________________________________
________________________________________________________
Ihre E-Mail-Postfächer sicher & zentral an einem Ort. Jetzt wechseln und alte E-Mail-Adresse mitnehmen! https://www.eclipso.de
