Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63125 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab0EXCi1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 22:38:27 -0400
Received: by gwaa20 with SMTP id a20so1311346gwa.19
        for <linux-media@vger.kernel.org>; Sun, 23 May 2010 19:38:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100518173011.5d9c7f2c@glory.loctelecom.ru>
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>
Date: Sun, 23 May 2010 22:38:26 -0400
Message-ID: <AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>
Subject: Re: [PATCH] xc5000, rework xc_write_reg
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Bee Hock Goh <beehock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 18, 2010 at 3:30 AM, Dmitri Belimov <d.belimov@gmail.com> wrote:
> Hi
>
> Rework xc_write_reg function for correct read register of the xc5000.
> It is very useful for tm6000.
>
> Tested for tm6000 and for saa7134 works well.

Hi Dmitri,

I've put this on my list of patches to review.  My concern is that the
xc_wait logic is pretty nasty since it's related to timing of the bus
(it took several weeks as well as a dozen emails with the people at
Xceive), and hence I am loathed to change it since it took quite a bit
of time to test against all the different cards that use xc5000 (and
in some cases there were bugs exposed in various bridge's i2c
implementations).

That said, I think I actually did attempt to implement a patch
comparable to what you did here, but I backed it out for some reason.
I will need to review my trees and my notes to see what the rationale
was for doing such.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
