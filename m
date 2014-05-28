Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39653 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbaE1OKy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 10:10:54 -0400
Message-ID: <1401286252.3054.43.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH] [media] mt9v032: register v4l2 asynchronous subdevice
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Date: Wed, 28 May 2014 16:10:52 +0200
In-Reply-To: <14598510.Vt3YXH2eJa@avalon>
References: <1401112645-14884-1-git-send-email-p.zabel@pengutronix.de>
	 <14598510.Vt3YXH2eJa@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Mittwoch, den 28.05.2014, 13:16 +0200 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> Thank you for the patch.
> 
> On Monday 26 May 2014 15:57:25 Philipp Zabel wrote:
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Now that Mauro starts to enforce commit message, I'll need to ask you to 
> provide one :-)

My bad, I'll fix this up as you suggest and add a commit message.

> > ---
> >  drivers/media/i2c/mt9v032.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> > index 29d8d8f..ded97c2 100644
> > --- a/drivers/media/i2c/mt9v032.c
> > +++ b/drivers/media/i2c/mt9v032.c
> > @@ -985,6 +985,11 @@ static int mt9v032_probe(struct i2c_client *client,
> > 
> >  	mt9v032->pad.flags = MEDIA_PAD_FL_SOURCE;
> >  	ret = media_entity_init(&mt9v032->subdev.entity, 1, &mt9v032->pad, 0);
> > +	if (ret < 0)
> > +		return ret;
> 
> That's not correct. You need to free the control handler here.
> 
> > +
> > +	mt9v032->subdev.dev = &client->dev;
> > +	ret = v4l2_async_register_subdev(&mt9v032->subdev);
> 
> Don't you also need to call v4l2_async_unregister_subdev() in the remove 
> function ?
> 
> > 
> >  	if (ret < 0)
> >  		v4l2_ctrl_handler_free(&mt9v032->ctrls);
> 
> And you need to cleanup the media entity here. A dedicated error code block at 
> the end of the function with appropriate goto statements seems to be needed.

regards
Philipp

