Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:29512 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab0DLEs0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Apr 2010 00:48:26 -0400
Received: by ey-out-2122.google.com with SMTP id 9so111780eyd.5
        for <linux-media@vger.kernel.org>; Sun, 11 Apr 2010 21:48:25 -0700 (PDT)
Date: Mon, 12 Apr 2010 14:50:34 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Fix default state Beholder H6 tuner.
Message-ID: <20100412145034.6002ebd8@glory.loctelecom.ru>
In-Reply-To: <4BBE9CB7.5090206@infradead.org>
References: <20100330160217.52e26a33@glory.loctelecom.ru>
	<1269942855.3361.7.camel@pc07.localdom.local>
	<20100331131407.741b7822@glory.loctelecom.ru>
	<1270081915.3227.8.camel@pc07.localdom.local>
	<20100401143346.2b16319d@glory.loctelecom.ru>
	<4BBE9CB7.5090206@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

> Em 01-04-2010 01:33, Dmitri Belimov escreveu:
> > Hi Hermann
> > 
> >> Hi Dimitry,
> >>
> >> Am Mittwoch, den 31.03.2010, 13:14 +1000 schrieb Dmitri Belimov:
> >>> Hi Hermann
> >>>
> >>>> Hi,
> >>>>
> >>>> Am Dienstag, den 30.03.2010, 16:02 +1000 schrieb Dmitri Belimov:
> >>>>> Hi
> >>>>>
> >>>>> The hybrid tuner FMD1216MEX_MK3 after cold start has disabled
> >>>>> IF. This tuner has internal I2C switch. This switch switch I2C
> >>>>> bus between DVB-T and IF part. Default state is DVB-T. When
> >>>>> module saa7134 is load it can't find IF tda9887 and disable
> >>>>> analog TV mode.
> >>>>>
> >>>>> This patch set internal I2C switch of the tuner to IF by send
> >>>>> special value to the tuner as for receive analog TV from low
> >>>>> band. It can be usefule for other cards.
> >>>>>
> >>>>> I didn't set configure a tuner by a tuner model because this
> >>>>> tuner can has different I2C address. May be we can do it later
> >>>>> after discuss for more robust support a tuners.
> >>>>
> >>>> just as a reminder. It is the same for the FMD1216ME hybrid MK3.
> >>>> After every boot, analog mode fails with missing tda9887.
> >>>>
> >>>> Currently, after tuner modules are not independent anymore, one
> >>>> has to reload the saa7134 driver once.
> >>>>
> >>>> Relevant code in tuner.core.c.
> >>>>
> >>>> 	case TUNER_PHILIPS_FMD1216ME_MK3:
> >>>> 		buffer[0] = 0x0b;
> >>>> 		buffer[1] = 0xdc;
> >>>> 		buffer[2] = 0x9c;
> >>>> 		buffer[3] = 0x60;
> >>>> 		i2c_master_send(c, buffer, 4);
> >>>> 		mdelay(1);
> >>>> 		buffer[2] = 0x86;
> >>>> 		buffer[3] = 0x54;
> >>>> 		i2c_master_send(c, buffer, 4);
> >>>> 		if (!dvb_attach(simple_tuner_attach, &t->fe,
> >>>> 				t->i2c->adapter, t->i2c->addr,
> >>>> t->type)) goto attach_failed;
> >>>> 		break;
> >>>
> >>> That is good. I'll try add case TUNER_PHILIPS_FMD1216MEX_MK3 here
> >>> and test. This is much better.
> >>
> >> it wont work for any what I can tell.
> >>
> >> We were forced into such an universal looking solution, but it was
> >> broken only a short time later.
> >>
> >> I for sure don't say that this time, late 2005, it was in anyway
> >> perfect, too much random on module load orders and also duplicate
> >> address stuff around meanwhile.
> >>
> >> But, however, it seems to be blocked for a global attempt within
> >> the current schemes too.
> > 
> > Yes. Not worked. My patch is good for our customers right now. But
> > when this subsystem is ready we can switch to use it.
> > 
> > With my best regards, Dmitry.
> > 
> 
> I'll apply the patch for now, but the better is to fix the
> TUNER_PHILIPS_FMD1216MEX_MK3.
> 
> Dmitri, could you please try to fix it with a more generic solution?

Ok. I'll do it later.

With my best regards, Dmitry.

> 
> Thanks,
> Mauro
