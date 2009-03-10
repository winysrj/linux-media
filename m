Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:52032 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZCJNIV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 09:08:21 -0400
Received: by fxm24 with SMTP id 24so1610828fxm.37
        for <linux-media@vger.kernel.org>; Tue, 10 Mar 2009 06:08:18 -0700 (PDT)
Date: Tue, 10 Mar 2009 22:08:19 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Fix I2C bridge error in zl10353
Message-ID: <20090310220819.1790cc44@glory.loctelecom.ru>
In-Reply-To: <20090310094019.16ab55d7@pedra.chehab.org>
References: <E1LHmrf-0004LH-VV@www.linuxtv.org>
	<49A03A94.9030008@iki.fi>
	<49B63C6C.8070709@iki.fi>
	<20090310094019.16ab55d7@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

> On Tue, 10 Mar 2009 12:09:48 +0200
> Antti Palosaari <crope@iki.fi> wrote:
> 
> > Mauro,
> > Could you remove this bad patch patch soon? It must not go to the
> > final 2.6.29 as it breaks so many old devices. One of those is MSI
> > Megasky 580 which is rather popular.
> 
> > 
> > regards
> > Antti
> > 
> > Antti Palosaari wrote:
> > > Hello,
> > > This patch breaks devices using tuner behind zl10353 i2c-gate.
> > > au6610:
> > > Sigmatek DVB-110 DVB-T USB2.0
> > > 
> > > gl861:
> > > MSI Mega Sky 55801 DVB-T USB2.0
> > > A-LINK DTU DVB-T USB2.0
> > > 
> > > Probably some other too.
> > > 
> > > I think it is better to disable i2c-gate setting callback to NULL
> > > after demod attach like dtv5100 does this.
> > > 
> > > Also .no_tuner is bad name what it does currently. My opinion is
> > > that current .no_tuner = 1 should be set as default, because most 
> > > configuration does not this kind of slave tuner setup where tuner
> > > is programmed by demod.
> > > Change no_tuner to slave_tuner and set slave_tuner = 1 only when
> > > needed (not many drivers using that).
> 
> Hi Antti/Dmitri,
> 
> I agree that no_tuner is a bad name. The best is to rename it to
> something like "tuner_is_behind_bridge". If equal to 1, then it will
> use the new behaviour, otherwise the old one, and fix the boards
> where this trouble were found.
> 
> Could one of you please do such patchset?

I haven't a lot expirience with kernel programming. If Antti can it is good. I'll check it
on our board.

With my best regards, Dmitry.
