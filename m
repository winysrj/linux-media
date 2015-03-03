Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58708 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbbCCOjD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 09:39:03 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKN00FRU4VSEZ10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Mar 2015 14:43:04 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Lad Prabhakar' <prabhakar.csengg@gmail.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org
References: <1425308434-26549-1-git-send-email-prabhakar.csengg@gmail.com>
 <54F57A43.30101@xs4all.nl>
In-reply-to: <54F57A43.30101@xs4all.nl>
Subject: RE: [PATCH] media: i2c: s5c73m3: make sure we destroy the mutex
Date: Tue, 03 Mar 2015 15:38:59 +0100
Message-id: <078601d055bf$c9964f50$5cc2edf0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
Sent: Tuesday, March 03, 2015 10:09 AM
> 
> On 03/02/2015 04:00 PM, Lad Prabhakar wrote:
> > From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> >
> > Make sure to call mutex_destroy() in case of probe failure or module
> > unload.
> 
> It's not actually necessary to destroy a mutex. Most drivers never do
> this.
> It only helps a bit in debugging.
> 
> I'll delegate this patch to Kamil, and he can decide whether or not to
> apply this.

I agree with Hans here, the patch is not necessary.

> 
> Regards,
> 
> 	Hans
> 

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

> >
> > Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > ---
> >  drivers/media/i2c/s5c73m3/s5c73m3-core.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> > b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> > index ee0f57e..da0b3a3 100644
> > --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> > +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> > @@ -1658,7 +1658,6 @@ static int s5c73m3_probe(struct i2c_client
> *client,
> >  	if (ret < 0)
> >  		return ret;
> >
> > -	mutex_init(&state->lock);
> >  	sd = &state->sensor_sd;
> >  	oif_sd = &state->oif_sd;
> >
> > @@ -1695,6 +1694,8 @@ static int s5c73m3_probe(struct i2c_client
> *client,
> >  	if (ret < 0)
> >  		return ret;
> >
> > +	mutex_init(&state->lock);
> > +
> >  	ret = s5c73m3_configure_gpios(state);
> >  	if (ret)
> >  		goto out_err;
> > @@ -1754,6 +1755,7 @@ out_err1:
> >  	s5c73m3_unregister_spi_driver(state);
> >  out_err:
> >  	media_entity_cleanup(&sd->entity);
> > +	mutex_destroy(&state->lock);
> >  	return ret;
> >  }
> >
> > @@ -1772,6 +1774,7 @@ static int s5c73m3_remove(struct i2c_client
> *client)
> >  	media_entity_cleanup(&sensor_sd->entity);
> >
> >  	s5c73m3_unregister_spi_driver(state);
> > +	mutex_destroy(&state->lock);
> >
> >  	return 0;
> >  }
> >

