Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:51593 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbbJPVtU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 17:49:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sergey Kozlov <serjk@netup.ru>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] lnbh25: fix lnbh25_attach inline wrapper
Date: Fri, 16 Oct 2015 23:49:09 +0200
Message-ID: <4801142.TL3UEFHxhL@wuerfel>
In-Reply-To: <CABxcv=n_N-176+iOsBaroJoGy0kj35YELyfLnaXJGmsi9xkDOg@mail.gmail.com>
References: <10110482.QkOJ1nlAsE@wuerfel> <CABxcv=n_N-176+iOsBaroJoGy0kj35YELyfLnaXJGmsi9xkDOg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 16 October 2015 23:45:46 Javier Martinez Canillas wrote:
> 
> On Fri, Oct 16, 2015 at 10:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > The 'static inline' version of lnbh25_attach() has an incorrect
> > prototype which results in a build error when
> > CONFIG_DVB_LNBH25 is disabled:
> >
> > In file included from /git/arm-soc/drivers/media/pci/netup_unidvb/netup_unidvb_core.c:36:0:
> > /git/arm-soc/drivers/media/dvb-frontends/lnbh25.h:46:86: error: unknown type name 'dvb_frontend'
> >
> > This changes the code to have the correct prototype.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Fixes: e025273b86fb ("[media] lnbh25: LNBH25 SEC controller driver")
> > ---
> 
> Same for this patch, the same change is already in the media fixes branch [0].
> 
> [0]: http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?h=fixes&id=b36a55cf298127a285806c52d8777c49548f3785

Ah, I see. The patches must have crossed then, it was still broken in linux-next
this morning.

	Arnd
