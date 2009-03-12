Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:52911 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZCLDfj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 23:35:39 -0400
Received: by fxm24 with SMTP id 24so233906fxm.37
        for <linux-media@vger.kernel.org>; Wed, 11 Mar 2009 20:35:36 -0700 (PDT)
Date: Thu, 12 Mar 2009 12:35:40 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Fix I2C bridge error in zl10353
Message-ID: <20090312123540.6cd58ac8@glory.loctelecom.ru>
In-Reply-To: <49B6915A.6050108@iki.fi>
References: <E1LHmrf-0004LH-VV@www.linuxtv.org>
 <49A03A94.9030008@iki.fi>
 <49B63C6C.8070709@iki.fi>
 <20090310094019.16ab55d7@pedra.chehab.org>
 <20090310220819.1790cc44@glory.loctelecom.ru>
 <49B667A7.8090407@iki.fi>
 <49B6915A.6050108@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti

> Antti Palosaari wrote:
> > Dmitri Belimov wrote:
> >>> Could one of you please do such patchset?
> >>
> >> I haven't a lot expirience with kernel programming. If Antti can
> >> it is good. I'll check it
> >> on our board.
> > 
> > OK, I will do. For the first phase and as a bug fix I will do that 
> > (disable i2c-gate) like dtv5100 driver does. After that I will add
> > new configuration switch for i2c-gate disable and also
> > change .no_tuner name to better one.
> 
> Here it is, please review and test. I kept changes as small as
> possible to prevent errors. Lets fix more later.
> 
> http://linuxtv.org/hg/~anttip/zl10353/

This patch is good. All work is ok.

With my best regards, Dmitry.

> 
> regards
> Antti
> -- 
> http://palosaari.fi/
