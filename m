Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48101 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935212Ab3DPDKv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 23:10:51 -0400
Received: by mail-pb0-f53.google.com with SMTP id un15so31247pbc.40
        for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 20:10:51 -0700 (PDT)
Date: Mon, 15 Apr 2013 20:10:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Randy Dunlap <rdunlap@infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH -next] media:
In-Reply-To: <516461FE.4020007@iki.fi>
Message-ID: <alpine.DEB.2.02.1304152010180.3952@chino.kir.corp.google.com>
References: <20130408174343.cc13eb1972470d20d38ecff1@canb.auug.org.au> <51630297.2040803@infradead.org> <516461FE.4020007@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 9 Apr 2013, Antti Palosaari wrote:

> On 04/08/2013 08:47 PM, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@infradead.org>
> > 
> > Fix randconfig error when USB is not enabled:
> > 
> > ERROR: "usb_control_msg" [drivers/media/common/cypress_firmware.ko]
> > undefined!
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Antti Palosaari <crope@iki.fi>
> 
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> 
> 
> > ---
> >   drivers/media/common/Kconfig |    1 +
> >   1 file changed, 1 insertion(+)
> > 
> > --- linux-next-20130408.orig/drivers/media/common/Kconfig
> > +++ linux-next-20130408/drivers/media/common/Kconfig
> > @@ -18,6 +18,7 @@ config VIDEO_TVEEPROM
> > 
> >   config CYPRESS_FIRMWARE
> >   	tristate "Cypress firmware helper routines"
> > +	depends on USB
> > 
> >   source "drivers/media/common/b2c2/Kconfig"
> >   source "drivers/media/common/saa7146/Kconfig"
> > 

Mauro, this problem persists in linux-next seven days later, any chance we 
can get this fix from Randy merged?
