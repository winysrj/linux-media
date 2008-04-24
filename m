Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OL8r9g003047
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 17:08:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OL8JcZ011407
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 17:08:19 -0400
Date: Thu, 24 Apr 2008 18:08:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080424180802.6811568e@gaivota>
In-Reply-To: <200804242219.23906.laurent.pinchart@skynet.be>
References: <200804230137.12502.laurent.pinchart@skynet.be>
	<20080423142705.62b6e444@gaivota>
	<200804242219.23906.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB Video Class driver
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

On Thu, 24 Apr 2008 22:19:23 +0200
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> On Wednesday 23 April 2008, Mauro Carvalho Chehab wrote:
> > Driver looks sane. Just a few comments.
> >
> > On Wed, 23 Apr 2008 01:37:11 +0200
> >
> > Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > > +USB VIDEO CLASS
> > > +P:	Laurent Pinchart
> > > +M:	laurent.pinchart@skynet.be
> > > +L:      linux-uvc-devel@berlios.de
> >
> > I think you should also add V4L ML here - and maybe USB.
> 
> I don't think the linux-usb ML wants to be spammed with the uvcvideo driver 
> bugreports. I can add V4L ML, although it's already mentioned in the 
> maintainer's file V4L entry.

IMO, it is better to have V4L ML here.
 
> > > +static __s32 uvc_get_le_value(const __u8 *data,
> > > +	struct uvc_control_mapping *mapping)
> > > +{
> > > +	int bits = mapping->size;
> > > +	int offset = mapping->offset;
> > > +	__s32 value = 0;
> > > +	__u8 mask;
> > > +
> > > +	data += offset / 8;
> > > +	offset &= 7;
> > > +	mask = ((1LL << bits) - 1) << offset;
> > > +
> > > +	for (; bits > 0; data++) {
> > > +		__u8 byte = *data & mask;
> > > +		value |= offset > 0 ? (byte >> offset) : (byte << (-offset));
> > > +		bits -= 8 - (offset > 0 ? offset : 0);
> > > +		offset -= 8;
> > > +		mask = (1 << bits) - 1;
> > > +	}
> >
> > Instead of using your own le conversion, IMO, it would be better to use the
> > standard _le_ functions here.
> >
> > > +static void uvc_set_le_value(__s32 value, __u8 *data,
> > > +	struct uvc_control_mapping *mapping)
> > > +{
> >
> > Instead of using your own le conversion, IMO, it would be better to use the
> > standard _le_ functions here.
> 
> Have a closer look at the two functions. They extract/insert variable-size 
> fields from/to a 32 bit number. The existing _le_ functions can't do that.

I don't see any check if the processor is LE or BE. with the current approach,
I'm afraid that this may fail on some architectures.

> > You should consider moving to videobuf on a later version. videobuf also
> > implements read() method, and will likely implement also USERPTR and maybe
> > OVERLAY on future versions.
> 
> I've considered using videobuf when I started the driver, but it wasn't ready 
> for USB devices. There has been several nasty videobuf issues reported to the 
> V4L mailing list recently, so I'd rather wait until videobuf stabilises. I 
> will have to test it properly anyway, as I don't want to loose any 
> functionality/introduce any bug.

I think videobuf is now on a much better shape than before. We've migrated
em28xx USB driver to use it, and it seems to be working very nicely.

> There's also another issue. The UVC standard defines ways to capture still 
> images, and the V4L2 API doesn't support that. I thought about using the 
> read() interface for still images.

There are two read methods on videobuf
	videobuf_read_stream()
and
	videobuf_read_one()

The focus of videobuf_read_one() is to take still images. So, this will
probably fit on your needs.

> > Again, converting to video_ioctl2() will provide a clearer code, and will
> > save stack space.
> 
> We've discussed video_ioctl2 in the past and I'm still not convinced. I don't 
> plan/want to convert the uvcvideo driver to use video_ioctl2.

Maybe someone with enough time may try to send you a patch converting it for
you to test and compare the results on uvc. Anyway, this is not an issue for
merging it for 2.6.26.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
