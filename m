Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3942 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760527Ab3DHIjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 04:39:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?iso-8859-15?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: em28xx: kernel oops in em28xx_tuner_callback() when watching digital TV
Date: Mon, 8 Apr 2013 10:38:54 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <515EF7CF.4060107@googlemail.com> <201304060838.42052.hverkuil@xs4all.nl> <5161ECE7.1060808@googlemail.com>
In-Reply-To: <5161ECE7.1060808@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201304081038.54531.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon April 8 2013 00:02:15 Frank Schäfer wrote:
> 
> 
> In em28xx_start_streaming() and also em28xx_stop_streaming() we do
> 
>      struct em28xx *dev = dvb->adapter.priv;
> 
> which I would say should be the culprit.
> Are you sure that dvb->adapter.priv needs to be assigned to i2c_bus
> instead of dev ?
> Anyway, I modified both functions to obtain the right pointer to dev,
> but this caused another oops.
> I also tested without changing dvb->adapter.priv: oops :-/

Can you try this patch? I did miss the adapter.priv change, so I've added that.
I also noticed that I converted fe->dvb->priv as well, which is not correct.

So I'm hoping that this will do the trick.

Regards,

	Hans

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 42a6a26..1f1f56f 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -178,7 +178,8 @@ static inline int em28xx_dvb_urb_data_copy(struct em28xx *dev, struct urb *urb)
 static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 {
 	int rc;
-	struct em28xx *dev = dvb->adapter.priv;
+	struct em28xx_i2c_bus *i2c_bus = dvb->adapter.priv;
+	struct em28xx *dev = i2c_bus->dev;
 	int dvb_max_packet_size, packet_multiplier, dvb_alt;
 
 	if (dev->dvb_xfer_bulk) {
@@ -217,7 +218,8 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 
 static int em28xx_stop_streaming(struct em28xx_dvb *dvb)
 {
-	struct em28xx *dev = dvb->adapter.priv;
+	struct em28xx_i2c_bus *i2c_bus = dvb->adapter.priv;
+	struct em28xx *dev = i2c_bus->dev;
 
 	em28xx_stop_urbs(dev);
 
@@ -839,7 +841,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 	if (dvb->fe[1])
 		dvb->fe[1]->ops.ts_bus_ctrl = em28xx_dvb_bus_ctrl;
 
-	dvb->adapter.priv = dev;
+	dvb->adapter.priv = &dev->i2c_bus[dev->def_i2c_bus];
 
 	/* register frontend */
 	result = dvb_register_frontend(&dvb->adapter, dvb->fe[0]);
