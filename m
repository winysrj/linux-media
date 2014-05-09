Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:62359 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469AbaEIJSC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 05:18:02 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5A00L4MV60JG90@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 May 2014 05:18:00 -0400 (EDT)
Date: Fri, 09 May 2014 06:17:55 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: dheitmueller@kernellabs.com, Changbing Xiong <cb.xiong@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] au0828: Cancel stream-restart operation if frontend is
 disconnected
Message-id: <20140509061755.2f21dcfe.m.chehab@samsung.com>
In-reply-to: <20140509051253.0417fc38.m.chehab@samsung.com>
References: <1399611251-7746-1-git-send-email-cb.xiong@samsung.com>
 <20140509051253.0417fc38.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 09 May 2014 05:12:53 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Fri, 09 May 2014 12:54:11 +0800
> Changbing Xiong@pop3.w2.samsung.net escreveu:
> 
> > From: Changbing Xiong <cb.xiong@samsung.com>
> > 
> > If the tuner is already disconnected, It is meaningless to go on doing the
> > stream-restart operation, It is better to cancel this operation.
> > 
> > Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>
> > ---
> >  drivers/media/usb/au0828/au0828-dvb.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >  mode change 100644 => 100755 drivers/media/usb/au0828/au0828-dvb.c
> > 
> > diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
> > old mode 100644
> > new mode 100755
> > index 9a6f156..fd8e798
> > --- a/drivers/media/usb/au0828/au0828-dvb.c
> > +++ b/drivers/media/usb/au0828/au0828-dvb.c
> > @@ -403,6 +403,8 @@ void au0828_dvb_unregister(struct au0828_dev *dev)
> >  	if (dvb->frontend == NULL)
> >  		return;
> > 
> > +	cancel_work_sync(&dev->restart_streaming);
> > +
> >  	dvb_net_release(&dvb->net);
> >  	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
> >  	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
> 
> Seems ok on my eyes.
> 
> Btw, I think we should also call cancel_work_sync() on other
> places. On some tests I did with this frontend last week, things
> sometimes get badly when switching from one channel to another one,
> or doing channel scan.
> 
> This thread could be the culprit. Unfortunately, I can't test it
> ATM, as I'm in a business trip this week.
> 
> Anyway, from a theoretical perspective, it seems logical that
> call cancel_work_sync() should also be called when:
> 	- stop_urb_transfer() is called;

Hmm... we can't call it there, as the thread calls stop_urb_transfer.
Yet, IMHO, it makes sense to add it at au0828_dvb_stop_feed() and on
other places where stop_urb_transfer is called.

> 	- when a new tuning starts.
> 
> For the second one, the patch should be somewhat similar to what 
> cx23885_set_frontend_hook() does, e. g. hooking the 
> fe->ops.set_frontend, in order to call cancel_work_sync() before setting
> the frontend parameters for the next frequency to zap. Due to the 
> DVB zigzag algorithm, I suspect that this could even improve channel
> scanning.
> 
> Devin,
> 
> What do you think?

On a second thought, maybe au0828_restart_dvb_streaming() should
be called every time fe->ops.set_frontend() is called, as it seems 
likely that the misalignment condition that the changeset
43f2cccfc81c0af719a425ea816ce8003bb09748 fixes is actually caused
by not resetting the stream before tuning into a new frequency.

In other words, I think that an approach like the (untested) patch
below could improve tuning with this device.

Unfortunately, I can't test it during this week, as I'm in the middle of
a trip, without this device.

Regards,
Mauro

[PATCH] Reset au0828 streaming when a new frequency is set

Sometimes, when changing channels with au0828 causes it to fail.

Also, sometimes a channel is not properly tuned. I suspect that this is
caused by the DVB core zigzag logic that doesn't know about the scheduled
work to restart streaming when the MPEG TS gets misaligned.

The fix seems to be to cancel the restart_streaming scheduled task
and to stop/start the stream every time a new channel is set, e. g.
every time fe->ops.set_frontend() is called.

This patch is compile-tested only.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 4ae8b1074649..c5b5331c85a7 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -338,6 +338,32 @@ static void au0828_restart_dvb_streaming(struct work_struct *work)
 	mutex_unlock(&dvb->lock);
 }
 
+static int au0828_set_frontend(struct dvb_frontend *fe)
+{
+	struct au0828_dev *dev = fe->dvb->priv;
+	struct au0828_dvb *dvb = &dev->dvb;
+	int ret, was_streaming;
+
+	mutex_lock(&dvb->lock);
+
+	was_streaming = dev->urb_streaming;
+	if (was_streaming) {
+		stop_urb_transfer(dev);
+		cancel_work_sync(&dev->restart_streaming);
+	}
+	au0828_stop_transport(dev, 1);
+
+	ret = dvb->set_frontend(fe);
+
+	au0828_start_transport(dev);
+	if (was_streaming)
+		start_urb_transfer(dev);
+
+	mutex_unlock(&dvb->lock);
+
+	return ret;
+}
+
 static int dvb_register(struct au0828_dev *dev)
 {
 	struct au0828_dvb *dvb = &dev->dvb;
@@ -382,6 +408,10 @@ static int dvb_register(struct au0828_dev *dev)
 		goto fail_frontend;
 	}
 
+	/* Hook dvb frontend */
+        dvb->set_frontend = dvb->frontend->ops.set_frontend;
+        dvb->frontend->ops.set_frontend = au0828_set_frontend;
+
 	/* register demux stuff */
 	dvb->demux.dmx.capabilities =
 		DMX_TS_FILTERING | DMX_SECTION_FILTERING |
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 5439772c1551..7112b9d956fa 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -104,6 +104,8 @@ struct au0828_dvb {
 	int feeding;
 	int start_count;
 	int stop_count;
+
+	int (*set_frontend)(struct dvb_frontend *fe);
 };
 
 enum au0828_stream_state {

