Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37987 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZCLKQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 06:16:28 -0400
Date: Thu, 12 Mar 2009 07:15:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Fix I2C bridge error in zl10353
Message-ID: <20090312071559.2f8c7a34@pedra.chehab.org>
In-Reply-To: <20090312123540.6cd58ac8@glory.loctelecom.ru>
References: <E1LHmrf-0004LH-VV@www.linuxtv.org>
	<49A03A94.9030008@iki.fi>
	<49B63C6C.8070709@iki.fi>
	<20090310094019.16ab55d7@pedra.chehab.org>
	<20090310220819.1790cc44@glory.loctelecom.ru>
	<49B667A7.8090407@iki.fi>
	<49B6915A.6050108@iki.fi>
	<20090312123540.6cd58ac8@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Mar 2009 12:35:40 +0900
Dmitri Belimov <d.belimov@gmail.com> wrote:

> Hi Antti
> 
> > Antti Palosaari wrote:
> > > Dmitri Belimov wrote:
> > >>> Could one of you please do such patchset?
> > >>
> > >> I haven't a lot expirience with kernel programming. If Antti can
> > >> it is good. I'll check it
> > >> on our board.
> > > 
> > > OK, I will do. For the first phase and as a bug fix I will do that 
> > > (disable i2c-gate) like dtv5100 driver does. After that I will add
> > > new configuration switch for i2c-gate disable and also
> > > change .no_tuner name to better one.
> > 
> > Here it is, please review and test. I kept changes as small as
> > possible to prevent errors. Lets fix more later.
> > 
> > http://linuxtv.org/hg/~anttip/zl10353/
> 
> This patch is good. All work is ok.

Antti,

since you said that this patch should go to 2.6.29, I've already merged from
your tree, after having Dmitry ack.
> 
> With my best regards, Dmitry.
> 
> > 
> > regards
> > Antti
> > -- 
> > http://palosaari.fi/




Cheers,
Mauro
