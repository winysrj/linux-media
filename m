Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:46461 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab0EYBtJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 21:49:09 -0400
Received: by fg-out-1718.google.com with SMTP id d23so2093147fga.1
        for <linux-media@vger.kernel.org>; Mon, 24 May 2010 18:49:08 -0700 (PDT)
Date: Tue, 25 May 2010 11:49:39 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Bee Hock Goh <beehock@gmail.com>
Subject: Re: [PATCH] xc5000, rework xc_write_reg
Message-ID: <20100525114939.067404eb@glory.loctelecom.ru>
In-Reply-To: <AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>
	<AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin

> On Tue, May 18, 2010 at 3:30 AM, Dmitri Belimov <d.belimov@gmail.com>
> wrote:
> > Hi
> >
> > Rework xc_write_reg function for correct read register of the
> > xc5000. It is very useful for tm6000.
> >
> > Tested for tm6000 and for saa7134 works well.
> 
> Hi Dmitri,
> 
> I've put this on my list of patches to review.  My concern is that the
> xc_wait logic is pretty nasty since it's related to timing of the bus
> (it took several weeks as well as a dozen emails with the people at
> Xceive), and hence I am loathed to change it since it took quite a bit
> of time to test against all the different cards that use xc5000 (and
> in some cases there were bugs exposed in various bridge's i2c
> implementations).
> 
> That said, I think I actually did attempt to implement a patch
> comparable to what you did here, but I backed it out for some reason.
> I will need to review my trees and my notes to see what the rationale
> was for doing such.

Ok. I can test your solution on our hardware.
XC5000+SAA7134
XC5000+TM6010

With my best regards, Dmitry.

> Devin
> 
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
