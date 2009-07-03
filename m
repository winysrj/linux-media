Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38979 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZGCLAK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 07:00:10 -0400
Date: Fri, 3 Jul 2009 08:00:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Joel Jordan <zcacjxj@hotmail.com>, video4linux-list@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: eMPIA Silvercrest 2710
Message-ID: <20090703080007.16e3ebd7@pedra.chehab.org>
In-Reply-To: <4A4DC9D9.9010907@redhat.com>
References: <BAY103-W483504B84F25BC84275FAAC190@phx.gbl>
	<20090703032100.64c3f70d@pedra.chehab.org>
	<4A4DC9D9.9010907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 03 Jul 2009 11:05:29 +0200
Hans de Goede <hdegoede@redhat.com> escreveu:

> My that webcam has done some interesting travelling (me -> Dough -> you), I'm glad
> it finally ended at someone who has managed to get it to produce a picture under Linux.

Yes. Thank you for borrow it!

> Hmm, having to specify the card=71 parameter, sucks, that makes this a very non plug
> and play / not just working experience for end users. Question would it be possible to
> modify the em28xx driver to, when it sees the generic usb-id, setup the i2c controller
> approriately and then check:
> 1) If there is anything at the i2c address of the mt9v011 sensor
> 2) Read a couple of identification registers (often sensors have special non changing
>     registers for this)
> 3) If both the 1 and 2 test succeed set card to 71 itself ?

The mt9v011 sensor has an unique ID, that can be read via register 0. One of the
issues is that it is using the same address as tvp5150 (that can also be
probed, since it also provides an unique ID via some register).

> This is how we handle the problem of having one generic usb-id for a certain bridge, with
> various different sensors used in different cams, I know the em28xx is a lot more complicated
> as it does a lot more, but this may still work ?

Yes, it may work. with the new i2c binding method, it would not be that hard to
do such method, but it would require some rework at em28xx-cards, since some
boards require a pre-i2c binding initialization, so board detection happens too
early inside the driver.



Cheers,
Mauro
