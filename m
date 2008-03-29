Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2T5oDtw030787
	for <video4linux-list@redhat.com>; Sat, 29 Mar 2008 01:50:13 -0400
Received: from qb-out-0506.google.com (qb-out-0506.google.com [72.14.204.237])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2T5o1AX001072
	for <video4linux-list@redhat.com>; Sat, 29 Mar 2008 01:50:01 -0400
Received: by qb-out-0506.google.com with SMTP id o12so5266898qba.17
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 22:50:01 -0700 (PDT)
Date: Fri, 28 Mar 2008 20:59:54 -0700
From: Brandon Philips <brandon@ifup.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-ID: <20080329035953.GA10356@plankton.ifup.org>
References: <7876c2bc2446dc3e3630.1206699512@localhost>
	<Pine.LNX.4.64.0803282114540.22651@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803282114540.22651@axis700.grange>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Guennadi Liakhovetski <kernel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1 of 9] soc_camera: Introduce a spinlock for use with
	videobuf
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On 21:53 Fri 28 Mar 2008, Guennadi Liakhovetski wrote:
> On Fri, 28 Mar 2008, Brandon Philips wrote:
> I have a couple of questions to this one.

Good- I obviously had no way of testing and just took a shot :D

> > @@ -714,6 +714,7 @@ static int soc_camera_probe(struct devic
> >  	if (ret >= 0) {
> >  		const struct v4l2_queryctrl *qctrl;
> >  
> > +		spin_lock_init(&icd->irqlock);
> >  		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_GAIN);
> >  		icd->gain = qctrl ? qctrl->default_value : (unsigned short)~0;
> >  		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
> 
> Initialization - wouldn't it be enough to initialize it once on 
> allocation? In your case if we really put it into struct 
> soc_camera_device, in soc_camera_device_register(). Probe can be called 
> multiple times for one device, e.g., if the bus gets unloaded and loaded 
> again.

Oops, yes it should only happen once per allocation.

> > diff --git a/linux/include/media/soc_camera.h b/linux/include/media/soc_camera.h
> > --- a/linux/include/media/soc_camera.h
> > +++ b/linux/include/media/soc_camera.h
> > @@ -19,6 +19,7 @@ struct soc_camera_device {
> >  	struct list_head list;
> >  	struct device dev;
> >  	struct device *control;
> > +	spinlock_t irqlock;
> >  	unsigned short width;		/* Current window */
> >  	unsigned short height;		/* sizes */
> >  	unsigned short x_min;		/* Camera capabilities */
> 
>
> 2. in struct soc_camera_file, then it would be one spinlock per open 
> /dev/videoX instance and thus per struct videobuf_queue.

This is what should happen.  The spinlock has to protect the struct
videobuf_buffer.queue and should also be held throughout the interrupt
handler as you manipulate the buffer. 

> 3. in struct soc_camera_host, then it is one per camera bus and per IRQ 
> thread.

What do you mean by per IRQ thread?

> I am not quite sure what this spinlock is supposed to protect. If it is 
> protecting the videobuf queue, then, maybe, variant (2) above is correct? 

Yes, I think 2 is correct.

> And then just put initialization in soc_camera_open() right after the 
> allocation of a struct soc_camera_file instance?

I think so.

> OTOH, at least the PXA270 hardware needs a more global protection - to 
> protect the DMA channel setup. And this is hardware specific. We can just 
> assume that (imaginary) systems with multiple camera busses will have an 
> own DMA channel per bus and will allow their concurrent onfiguration... 
> Maybe we should let the hardware host driver decide on spinlock locality 
> and just use whatever it provides?

I don't know enough about the hardware to comment.

Thank You,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
