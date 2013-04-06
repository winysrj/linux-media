Return-path: <linux-media-owner@vger.kernel.org>
Received: from honeysuckle.london.02.net ([87.194.255.144]:50692 "EHLO
	honeysuckle.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422792Ab3DFM7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 08:59:48 -0400
Date: Sat, 6 Apr 2013 13:59:33 +0100
From: Adam Sampson <ats@offog.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-media@vger.kernel.org,
	jdonog01@eircom.net, bugzilla-kernel@tcnnet.com
Subject: Re: Hauppauge Nova-S-Plus DVB-S works for one channel, but cannot
 tune in others
Message-ID: <20130406125932.GA4564@cartman.at.offog.org>
References: <1463242.ms8FUp7FVg@xrated>
 <y2ar4ipcggy.fsf@cartman.at.offog.org>
 <20130405131854.6512bad6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405131854.6512bad6@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 05, 2013 at 01:18:54PM -0300, Mauro Carvalho Chehab wrote:
> Could you please test the enclosed patch? It allows the bridge
> driver to tell if the set_tone should be overrided by isl6421 or
> not.

Yes, your patch works fine for me, backported to 3.4, which was just a
case of changing the paths:
  http://offog.org/stuff/bug9476v2.diff

Tested-by: Adam Sampson <ats@offog.org>

I've tested it on my "Hauppauge model 92001, rev C1B1, serial# 1888307"
board with lowband V, lowband H, highband V and highband H transponders,
so both tone and voltage switching are working. I've not tested it on
any other boards.

> --- a/drivers/media/dvb-frontends/isl6421.h
> +++ b/drivers/media/dvb-frontends/isl6421.h
> @@ -42,10 +42,10 @@
>  #if IS_ENABLED(CONFIG_DVB_ISL6421)
>  /* override_set and override_clear control which system register bits (above) to always set & clear */
>  extern struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 i2c_addr,
> -			  u8 override_set, u8 override_clear);
> +			  u8 override_set, u8 override_clear, bool override_tone);

It might be worth adding a comment there saying what override_tone is
actually doing?

Thanks very much,

-- 
Adam Sampson <ats@offog.org>                         <http://offog.org/>
