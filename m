Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38148 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756324AbcKKMto (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 07:49:44 -0500
Date: Fri, 11 Nov 2016 10:49:03 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: VDR User <user.vdr@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
Message-ID: <20161111104903.607428e5@vela.lan>
In-Reply-To: <CAA7C2qiPZnqpJ8MYkQ3wGhnmHzK25kLEP_Sm-1UOu8aECzkOGA@mail.gmail.com>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
        <20161108155520.224229d5@vento.lan>
        <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
        <20161109073331.204b53c4@vento.lan>
        <CAA7C2qhK0x9bwHH-Q8ufz3zdOgiPs3c=d27s0BRNfmcv9+T+Gg@mail.gmail.com>
        <CAA7C2qi2tk9Out3Q4=uj-kJwhczfG1vK55a7EN4Wg_ibbn0HzA@mail.gmail.com>
        <20161109153521.232b0956@vento.lan>
        <CAA7C2qjojJD17Y+=+NpxnJns_0Uby4mARzsXAx_+3gjQ+NzmQQ@mail.gmail.com>
        <20161110060717.221e8d88@vento.lan>
        <CAA7C2qiPZnqpJ8MYkQ3wGhnmHzK25kLEP_Sm-1UOu8aECzkOGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Nov 2016 07:01:44 -0800
VDR User <user.vdr@gmail.com> escreveu:

> > commit 0c979a12309af49894bb1dc60e747c3cd53fa888
> > Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Date:   Wed Nov 9 15:33:17 2016 -0200
> >
> >     [media] gp8psk: Fix DVB frontend attach
> >
> >     it should be calling module_get() at attach, as otherwise
> >     module_put() will crash.
> >
> >     Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >
> > diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
> > index cede0d8b0f8a..24eb6c6c8e24 100644
> > --- a/drivers/media/usb/dvb-usb/gp8psk.c
> > +++ b/drivers/media/usb/dvb-usb/gp8psk.c
> > @@ -250,7 +250,7 @@ static int gp8psk_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
> >
> >  static int gp8psk_frontend_attach(struct dvb_usb_adapter *adap)
> >  {
> > -       adap->fe_adap[0].fe = gp8psk_fe_attach(adap->dev);
> > +       adap->fe_adap[0].fe = dvb_attach(gp8psk_fe_attach, adap->dev);
> >         return 0;
> >  }  
> 
> This gives:
> 
> [119150.498863] DVB: Unable to find symbol gp8psk_fe_attach()
> [119150.498928] dvb-usb: no frontend was attached by 'Genpix
> SkyWalker-2 DVB-S receiver'

Hmm... dvb_attach() assumes that the symbol is exported. Please try
this patch. If it fixes the bug, I'll likely do something else, to
avoid the need of EXPORT_SYMBOL.


[PATCH] [media] gp8psk: Fix DVB frontend attach

it should be calling module_get() at attach, as otherwise
module_put() will crash.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/usb/dvb-usb/gp8psk-fe.c b/drivers/media/usb/dvb-usb/gp8psk-fe.c
index db6eb79cde07..ab7c6093436b 100644
--- a/drivers/media/usb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/usb/dvb-usb/gp8psk-fe.c
@@ -326,6 +326,7 @@ struct dvb_frontend * gp8psk_fe_attach(struct dvb_usb_device *d)
 success:
 	return &s->fe;
 }
+EXPORT_SYMBOL_GPL(gp8psk_fe_attach);
 
 
 static struct dvb_frontend_ops gp8psk_fe_ops = {
diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index 2829e3082d15..c3762c50e93b 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -250,7 +250,7 @@ static int gp8psk_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 static int gp8psk_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	adap->fe_adap[0].fe = gp8psk_fe_attach(adap->dev);
+	adap->fe_adap[0].fe = dvb_attach(gp8psk_fe_attach, adap->dev);
 	return 0;
 }
 





Cheers,
Mauro
