Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40848 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389234AbeHAQIV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 12:08:21 -0400
Date: Wed, 1 Aug 2018 11:22:12 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 16/22] [media] tvp5150: add querystd
Message-ID: <20180801112212.4f450528@coco.lan>
In-Reply-To: <20180801132125.j4725kthupcc7fnd@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
        <20180628162054.25613-17-m.felsch@pengutronix.de>
        <20180730150945.3301864f@coco.lan>
        <20180801132125.j4725kthupcc7fnd@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 1 Aug 2018 15:21:25 +0200
Marco Felsch <m.felsch@pengutronix.de> escreveu:

> Hi Mauro,
> 
> On 18-07-30 15:09, Mauro Carvalho Chehab wrote:
> > Em Thu, 28 Jun 2018 18:20:48 +0200
> > Marco Felsch <m.felsch@pengutronix.de> escreveu:
> >   
> > > From: Philipp Zabel <p.zabel@pengutronix.de>
> > > 
> > > Add the querystd video_op and make it return V4L2_STD_UNKNOWN while the
> > > TVP5150 is not locked to a signal.
> > > 
> > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > ---
> > >  drivers/media/i2c/tvp5150.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > > index 99d887936ea0..1990aaa17749 100644
> > > --- a/drivers/media/i2c/tvp5150.c
> > > +++ b/drivers/media/i2c/tvp5150.c
> > > @@ -796,6 +796,15 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
> > >  	}
> > >  }
> > >  
> > > +static int tvp5150_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
> > > +{
> > > +	struct tvp5150 *decoder = to_tvp5150(sd);
> > > +
> > > +	*std_id = decoder->lock ? tvp5150_read_std(sd) : V4L2_STD_UNKNOWN;  
> > 
> > This patch requires rework. What happens when a device doesn't have
> > IRQ enabled? Perhaps it should, instead, read some register in order
> > to check for the locking status, as this would work on both cases.  
> 
> If IRQ isn't enabled, decoder->lock is set to always true during
> probe(). So this case should be fine.

Not sure if tvp5150_read_std() will do the right thing. If it does,
the above could simply be:
	std_id = tvp5150_read_std(sd);

But, as there are 3 variants of this chipset, it sounds safer to check
if the device is locked before calling tvp5150_read_std().

IMHO, the best would be to have a patch like the one below.

Regards,
Mauro

[PATCH] media: tvp5150: implement decoder lock when irq is not used

When irq is used, the lock is set via IRQ code. When it isn't,
the driver just assumes it is always locked. Instead, read the
lock status from the status register.

Compile-tested only.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 75e5ffc6573d..e07020d4053d 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -811,11 +811,24 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
 	}
 }
 
+static int query_lock(struct v4l2_subdev *sd)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	int status;
+
+	if (decoder->irq)
+		return decoder->lock;
+
+	regmap_read(map, TVP5150_INT_STATUS_REG_A, &status);
+
+	return (status & 0x06) == 0x06;
+}
+
 static int tvp5150_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
 
-	*std_id = decoder->lock ? tvp5150_read_std(sd) : V4L2_STD_UNKNOWN;
+	*std_id = query_lock(sd) ? tvp5150_read_std(sd) : V4L2_STD_UNKNOWN;
 
 	return 0;
 }
@@ -1247,7 +1260,7 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 		tvp5150_enable(sd);
 
 		/* Enable outputs if decoder is locked */
-		val = decoder->lock ? decoder->oe : 0;
+		val = query_lock(sd) ? decoder->oe : 0;
 		int_val = TVP5150_INT_A_LOCK;
 		v4l2_subdev_notify_event(&decoder->sd, &tvp5150_ev_fmt);
 	}
@@ -1816,8 +1829,6 @@ static int tvp5150_probe(struct i2c_client *c,
 						IRQF_ONESHOT, "tvp5150", core);
 		if (res)
 			return res;
-	} else {
-		core->lock = true;
 	}
 
 	res = v4l2_async_register_subdev(sd);
