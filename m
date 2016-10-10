Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:51094 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751148AbcJJJlj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 05:41:39 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id DA4D820A2D
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2016 11:41:08 +0200 (CEST)
Date: Mon, 10 Oct 2016 11:41:03 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alejandro Torrado <aletorrado@gmail.com>,
        Nicolas Sugino <nsugino@3way.com.ar>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [media] dib0700: remove redundant else
Message-ID: <20161010114103.03caeef3@posteo.de>
In-Reply-To: <20161010063035.7b766b79@vento.lan>
References: <1475928199-20315-1-git-send-email-hofrat@osadl.org>
        <20161010063035.7b766b79@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 10 Oct 2016 06:30:35 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> >  drivers/media/usb/dvb-usb/dib0700_devices.c | 10 +++-------
> >  1 file changed, 3 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c
> > b/drivers/media/usb/dvb-usb/dib0700_devices.c index
> > 0857b56..3cd8566 100644 ---
> > a/drivers/media/usb/dvb-usb/dib0700_devices.c +++
> > b/drivers/media/usb/dvb-usb/dib0700_devices.c @@ -1736,13 +1736,9
> > @@ static int dib809x_tuner_attach(struct dvb_usb_adapter *adap)
> > struct dib0700_adapter_state *st = adap->priv; struct i2c_adapter
> > *tun_i2c = st->dib8000_ops.get_i2c_master(adap->fe_adap[0].fe,
> > DIBX000_I2C_INTERFACE_TUNER, 1); 
> > -	if (adap->id == 0) {
> > -		if (dvb_attach(dib0090_register,
> > adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
> > -			return -ENODEV;
> > -	} else {
> > -		if (dvb_attach(dib0090_register,
> > adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
> > -			return -ENODEV;
> > -	}
> > +	if (dvb_attach(dib0090_register, adap->fe_adap[0].fe,
> > +		       tun_i2c, &dib809x_dib0090_config) == NULL)
> > +		return -ENODEV;  
> 
> 
> I suspect that this patch is wrong. It should be, instead, using
> fe_adap[1] on the else.
> 
> Patrick,
> 
> Could you please take a look?

I think you're right, it should be fe_adap[1], but I have lost track of
these devices and don't know the correct answer.

However, this code was introduced by 

commit 91be260faaf8561dc51e72033c346f6ab28d40d8
Author: Nicolas Sugino <nsugino@3way.com.ar>
Date:   Thu Nov 26 19:00:28 2015 -0200

    [media] dib8000: Add support for Mygica/Geniatech S2870
    
    MyGica/Geniatech S2870 is very similar to the S870 but with dual tuner. The card is recognised as Geniatech STK8096-PVR.
    
    [mchehab@osg.samsung.com: Fix some checkpatch.pl issues]
    Signed-off-by: Nicolas Sugino <nsugino@3way.com.ar>
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 7ed4964..ea0391e 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -1736,8 +1736,13 @@ static int dib809x_tuner_attach(struct dvb_usb_adapter *adap)
 	struct dib0700_adapter_state *st = adap->priv;
 	struct i2c_adapter *tun_i2c = st->dib8000_ops.get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
 
-	if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
-		return -ENODEV;
+	if (adap->id == 0) {
+		if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
+			return -ENODEV;
+	} else {
+		if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
+			return -ENODEV;
+	}
 
 	st->set_param_save = adap->fe_adap[0].fe->ops.tuner_ops.set_params;
 	adap->fe_adap[0].fe->ops.tuner_ops.set_params = dib8096_set_param_override;

[..]

Maybe Nicolas can help (and test).

--
Patrick.
