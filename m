Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43079 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaFDPEY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 11:04:24 -0400
Message-ID: <1401894260.3447.18.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 2/5] [media] mt9v032: register v4l2 asynchronous
 subdevice
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Wed, 04 Jun 2014 17:04:20 +0200
In-Reply-To: <2505444.YzkDIeOsnF@avalon>
References: <1401788155-3690-1-git-send-email-p.zabel@pengutronix.de>
	 <1401788155-3690-3-git-send-email-p.zabel@pengutronix.de>
	 <2505444.YzkDIeOsnF@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Mittwoch, den 04.06.2014, 16:16 +0200 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> Thank you for the patch.
> 
> On Tuesday 03 June 2014 11:35:52 Philipp Zabel wrote:
> > Add support for registering the sensor subdevice using the v4l2-async API.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > Changes since v1:
> >  - Fixed cleanup and error handling
> > ---
> >  drivers/media/i2c/mt9v032.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> > index 29d8d8f..83ae8ca6d 100644
> > --- a/drivers/media/i2c/mt9v032.c
> > +++ b/drivers/media/i2c/mt9v032.c
> > @@ -985,10 +985,20 @@ static int mt9v032_probe(struct i2c_client *client,
> > 
> >  	mt9v032->pad.flags = MEDIA_PAD_FL_SOURCE;
> >  	ret = media_entity_init(&mt9v032->subdev.entity, 1, &mt9v032->pad, 0);
> > +	if (ret < 0)
> > +		goto err_entity;
> > 
> > +	mt9v032->subdev.dev = &client->dev;
> > +	ret = v4l2_async_register_subdev(&mt9v032->subdev);
> >  	if (ret < 0)
> > -		v4l2_ctrl_handler_free(&mt9v032->ctrls);
> > +		goto err_async;
> > +
> > +	return 0;
> > 
> > +err_async:
> > +	media_entity_cleanup(&mt9v032->subdev.entity);
> 
> media_entity_cleanup() can safely be called on an unintialized entity, 
> provided the memory has been zeroed. You could thus merge the err_async and 
> err_entity labels into a single error label.

Alright, I'll update this patch accordingly.

regards
Philipp

