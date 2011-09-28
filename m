Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40685 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1I1EnO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 00:43:14 -0400
Received: by wwf22 with SMTP id 22so8293853wwf.1
        for <linux-media@vger.kernel.org>; Tue, 27 Sep 2011 21:43:13 -0700 (PDT)
Date: Wed, 28 Sep 2011 14:43:07 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] FM1216ME_MK3 AUX byte for FM mode
Message-ID: <20110928144307.2fcc4037@glory.local>
In-Reply-To: <4E75E799.1010307@redhat.com>
References: <20090423154046.7b54f7cc@glory.loctelecom.ru>
	<4E75E799.1010307@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/p=a5K3C7USxotpBV=UOJK7U"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/p=a5K3C7USxotpBV=UOJK7U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Mauro

Need apply this patch. I test it for compile only right now I haven't TV cards with 1216ME_MK3.
I was send ask on our forum for test.

With my best regards, Dmitry.

> Hi Dmitri,
> 
> Em 23-04-2009 02:40, Dmitri Belimov escreveu:
> > Hi All
> > 
> > Write AUX byte to FM1216ME_MK3 when FM mode, better sensitivity. It
> > can be usefull for other tuners.
> 
> Hmm... Found this patch. It were never applied, but it may make some
> sense to apply it.
> 
> Could you please double-check if this patch is still valid, and, if
> so, re-send it to me?
> 
> Thanks!
> Mauro
> 
> 
> > 
> > diff -r 00a84f86671d
> > linux/drivers/media/common/tuners/tuner-simple.c ---
> > a/linux/drivers/media/common/tuners/tuner-simple.c	Mon Apr
> > 20 22:07:44 2009 +0000 +++
> > b/linux/drivers/media/common/tuners/tuner-simple.c	Thu Apr
> > 23 10:26:54 2009 +1000 @@ -751,6 +751,17 @@ if (4 != rc)
> > tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc); 
> > +	/* Write AUX byte */
> > +	switch (priv->type) {
> > +	case TUNER_PHILIPS_FM1216ME_MK3:
> > +		buffer[2] = 0x98;
> > +		buffer[3] = 0x20; /* set TOP AGC */
> > +		rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer,
> > 4);
> > +		if (4 != rc)
> > +			tuner_warn("i2c i/o error: rc == %d
> > (should be 4)\n", rc);
> > +		break;
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> > Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov
> > <d.belimov@gmail.com>
> > 
> > 
> > With my best regards, Dmitry.
> 

--MP_/p=a5K3C7USxotpBV=UOJK7U
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=me_mk3_fm.patch

diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
index f8ee29e..4092200 100644
--- a/drivers/media/common/tuners/tuner-simple.c
+++ b/drivers/media/common/tuners/tuner-simple.c
@@ -751,6 +751,17 @@ static int simple_set_radio_freq(struct dvb_frontend *fe,
 	if (4 != rc)
 		tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc);
 
+	/* Write AUX byte */
+	switch (priv->type) {
+	case TUNER_PHILIPS_FM1216ME_MK3:
+		buffer[2] = 0x98;
+		buffer[3] = 0x20; /* set TOP AGC */
+		rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer, 4);
+		if (4 != rc)
+			tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc);
+		break;
+	}
+
 	return 0;
 }
 

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/p=a5K3C7USxotpBV=UOJK7U--
