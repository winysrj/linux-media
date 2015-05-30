Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41036 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbbE3PKm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 May 2015 11:10:42 -0400
Date: Sat, 30 May 2015 12:10:38 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 1/5] m88ds3103: do not return error from
 get_frontend() when not ready
Message-ID: <20150530121038.4a1eddaf@recife.lan>
In-Reply-To: <20150530120214.15ae4165@recife.lan>
References: <1432236172-13964-1-git-send-email-crope@iki.fi>
	<1432236172-13964-2-git-send-email-crope@iki.fi>
	<20150530120214.15ae4165@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 30 May 2015 12:02:14 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Thu, 21 May 2015 22:22:48 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
> 
> > Do not return error from get_frontend() when status is queried, but
> > device is not ready. dvbv5-zap has habit to call that IOCTL before
> > device is tuned and it also refuses to use DVBv5 statistic after
> > that...
> 
> This is actually an error at libdvbv5, that was solved by this patch:
> 
> commit bf028618f0a2f86f8515560865b8f8142eddb1d9
> Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Date:   Tue Apr 14 11:47:57 2015 -0300
> 
>     libdvbv5: Retry FE_GET_PROPERTY ioctl if it returns EAGAIN
>     
>     Retry the FE_GET_PROPERTY ioctl used to determine if we have a DVBv5 device
>     if it returns EAGAIN indicating the driver is currently locked by the kernel.
>     
>     Also skip over subsequent information gathering calls to FE_GET_PROPERTY
>     that return EAGAIN.
>     
>     Signed-off-by: David Howells <dhowells@redhat.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Basically, -EAGAIN should be discarded.
> 
> That's said, see below.
> 
> 
> > 
> > Signed-off-by: Antti Palosaari <crope@iki.fi>
> > ---
> >  drivers/media/dvb-frontends/m88ds3103.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
> > index d3d928e..03dceb5 100644
> > --- a/drivers/media/dvb-frontends/m88ds3103.c
> > +++ b/drivers/media/dvb-frontends/m88ds3103.c
> > @@ -742,7 +742,7 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
> >  	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
> >  
> >  	if (!priv->warm || !(priv->fe_status & FE_HAS_LOCK)) {
> > -		ret = -EAGAIN;
> > +		ret = 0;
> 
> Returning EAGAIN here doesn't seem right, as this ioctl didn't fail
> due to mutex locked while calling an ioctl with non-block mode (that's
> basically the usage of EAGAIN).
> 
> The proper behavior is to succeed the ioctl, keeping the cache untouched,
> with all the DVBv5 available status with scale filled with
> FE_SCALE_NOT_AVAILABLE.
> 
> That's said, I'm not seeing the part of the code on m88ds3103 that would
> be filling the DVBv5 stats. It seems that this patch comment is bogus.

I ended by applying the patch together with the complete patch series
just fixing the patch description.

Regards,
Mauro
