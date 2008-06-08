Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+ceff2bb65cb28e3d964d+1750+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1K5IKP-0000L3-FB
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 12:40:49 +0200
Date: Sun, 8 Jun 2008 07:38:36 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080608073836.233e801a@gaivota>
In-Reply-To: <1212886803.25974.44.camel@pc10.localdom.local>
References: <48498964.10301@iinet.net.au>
	<1212785950.16279.17.camel@pc10.localdom.local>
	<20080606183617.5c2b6398@gaivota> <484A1441.6070400@iinet.net.au>
	<484A1FC7.6070707@iinet.net.au>
	<1212886803.25974.44.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: hartmut.hackmann@t-online.de, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problem with latest v4l-dvb hg
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

On Sun, 08 Jun 2008 03:00:03 +0200
hermann pitton <hermann-pitton@arcor.de> wrote:

> 
> Am Samstag, den 07.06.2008, 13:42 +0800 schrieb timf:
> > timf wrote:
> > > Mauro Carvalho Chehab wrote:
> > >   
> > >> On Fri, 06 Jun 2008 22:59:10 +0200
> > >> hermann pitton <hermann-pitton@arcor.de> wrote:
> > >>
> > >>   
> > >>     
> > >>> Hi,
> > >>>
> > >>> Am Samstag, den 07.06.2008, 03:00 +0800 schrieb timf:
> > >>>     
> > >>>       
> > <snip>
> > 
> > Hi all,
> > 
> > Something very strange:
> > If in saa7134-dvb.c I do this:
> > 
> > <snip>
> > static int configure_tda827x_fe_kw210(struct saa7134_dev *dev,
> >                 struct tda1004x_config *cdec_conf,
> >                 struct tda827x_config *tuner_conf)
> > {
> >     dev->dvb.frontend = dvb_attach(tda10046_attach, cdec_conf, 
> > &dev->i2c_adap);
> >     if (dev->dvb.frontend) {
> > /*        if (cdec_conf->i2c_gate)
> >             dev->dvb.frontend->ops.i2c_gate_ctrl = tda8290_i2c_gate_ctrl; */
> >         if (dvb_attach(tda827x_attach, dev->dvb.frontend,
> >                    cdec_conf->tuner_address,
> >                    &dev->i2c_adap, tuner_conf))
> >             return 0;
> > 
> >         wprintk("no tda827x tuner found at addr: %02x\n",
> >                 cdec_conf->tuner_address);
> >     }
> >     return -EINVAL;
> > }
> > <snip>
> >     case SAA7134_BOARD_KWORLD_DVBT_210:
> > /*        if (configure_tda827x_fe(dev, &kworld_dvb_t_210_config, */
> >         if (configure_tda827x_fe_kw210(dev, &kworld_dvb_t_210_config,
> >                      &tda827x_cfg_2) < 0)
> >             goto dettach_frontend;
> >         break;
> > <snip>
> > then I can scan all available DVB-T channels, and view them.
> > If I leave it as original, it won't scan/view SBS.
> > 
> > Can someone tell me what part does this play?
> > 
> >         if (cdec_conf->i2c_gate)
> >             dev->dvb.frontend->ops.i2c_gate_ctrl = tda8290_i2c_gate_ctrl;
> 
> Tim,
> 
> without looking in any detail, choosed to have enough for myself.
> 
> Almost all, but not all, use the tda8290 analog IF demodulator within
> the saa7131e, on prior saa7135 stuff also present as a sepatate chip,
> as an i2c bridge to control the tuner, also if in DVB-T mode ...
> 
> To deminish interference on the bus, it is only opened to send the
> tuning bytes and then closed again.
> 
> IIRC, on your card are two tda8275a, which could serve as hybrid tuners,
> but on that early design it was choosen to burn some money in favor to
> have a first analog and DVB-T at once solution.
> 
> Since you have two tuners, you are not depending on the DVB-T gate stuff
> for DVB-T, which is a point for swichting issues from analog to DVB else
> on single hybrid tuners. To have a digital tuner controlled from the
> analog IF demod some still don't get and cause a lot of trouble.

There's another possibility. It might be possible that Viro's patches broke
firmware load. Did firmware load worked before (with the same version you're using)?

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
