Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZC2Krh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 06:47:37 -0400
Date: Sun, 29 Mar 2009 07:47:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Juan =?ISO-8859-1?B?SmVz+nMgR2FyY+1h?= de Soria Lucena
	<skandalfo@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Add AVerMedia A310 USB IDs to CE6230 driver.
Message-ID: <20090329074714.4e893ae9@pedra.chehab.org>
In-Reply-To: <49CF5013.70901@iki.fi>
References: <b0bb99640903281936u43ba9a84l6cfa5c8d3d00de0e@mail.gmail.com>
	<49CF5013.70901@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 29 Mar 2009 13:40:19 +0300
Antti Palosaari <crope@iki.fi> wrote:

> hello
> 
> Juan Jesús García de Soria Lucena wrote:
> > El día 28 de marzo de 2009 22:05, Mauro Carvalho Chehab
> > <mchehab@infradead.org> escribió:
> >> So, please send the patch you did for analysis. Please submit it as explained at [1].
> >>
> >> [1] http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches
> > 
> > Add AVerMedia A310 USB IDs to CE6230 driver.
> > 
> > From: Juan Jesús García de Soria Lucena <skandalfo@gmail.com>
> > 
> > The CE6230 DVB USB driver works correctly for the AVerMedia A310 USB2.0
> > DVB-T tuner. Add the required USB ID's and hardware names so that the
> > driver will handle it.
> > 
> > Priority: normal
> > 
> > Signed-off-by: Juan Jesús García de Soria Lucena <skandalfo@gmail.com>
> > 
> > diff -r b1596c6517c9 -r 71dd4cff4eb6 linux/drivers/media/dvb/dvb-usb/ce6230.c
> 
> Thank you. Patch looks 100% correct and good for me.
> 
> Mauro, should I pick up and add this my devel tree and PULL-request or 
> is there now patchwork which handles this? Current procedure is not 
> clear for me...

Any ways will work. 

In fact, it is easier to get from Patchwork since otherwise I'll need to
manually check what patches you got from the mailing list and manually update
its status at the Patchwork.

If you prefer me to pick it from patchwork, just reply with your acked-by:

Patchwork will automatically fold the acked together with the patch when I
download the patch to apply.

Cheers,
Mauro
