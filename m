Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:60889 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbZBNAmc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 19:42:32 -0500
Date: Fri, 13 Feb 2009 16:42:31 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, Michael Schimek <mschimek@gmx.at>,
	hjkoch@users.berlios.de, tobias.lorenz@gmx.net,
	belavenuto@gmail.com
Subject: Re: RFC: Finalizing the V4L2 RDS interface
In-Reply-To: <200902132259.07618.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0902131609150.24268@shell2.speakeasy.net>
References: <200902130955.19995.hverkuil@xs4all.nl> <20090213191545.3d92e121@pedra.chehab.org>
 <200902132259.07618.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Feb 2009, Hans Verkuil wrote:
> On Friday 13 February 2009 22:15:45 Mauro Carvalho Chehab wrote:
> > On Fri, 13 Feb 2009 09:55:19 +0100
> > > The V4L API defines its RDS API as follows.
> > >
> > > From radio devices supporting it, RDS data can be read with the read()
> > > function. The data is packed in groups of three, as follows:
> > >
> > > First Octet: Least Significant Byte of RDS Block
> > > Second Octet: Most Significant Byte of RDS Block
> > > Third Octet:
> > > 	Bit 7: Error bit. Indicates that an uncorrectable error occurred
> > > 	       during reception of this block.
> > > 	Bit 6: Corrected bit. Indicates that an error was corrected for
> > > 	       this data block.
> > > 	Bits 5-3: Received Offset. Indicates the offset received by the
> > > 		  sync system.
> > > 	Bits 2-0: Offset Name. Indicates the offset applied to this data.

What device file does one read from, the radio device or is there another
one for RDS data?

If the radio device, then maybe it should handle (S|G|TRY)_FMT ioctls, so
that one can select the format.  Since the drivers probably already use
v4l2_ioctl, this should be easy enough to do.

Some hardware might produce at a higher or lower level in the decoding
stack that just doesn't fit this format.

For instance, the common cx88 chip has some sort of RDS decoding ability.
I think it returns 36 kHz 16 bit I/Q data from the RDS carrier that
something like gnuradio would need to demodulate.  That's a completely
different format that this one.  Though I think it might make more sense to
use ALSA to get data in this format.

> > > And we can add support to select RDS/RDBS by using one of the reserved
> > > fields:
> > >
> > > __u8 	rds_type;
> > > __u8 	rds_signal;	/* RDS signal strength quality, 0-255 */
> > > __u8 	rds_reserved[2];
> > > __u32   reserved[3];

Do any devices support returning signal strength or quality?  If so, can we
get real units from them?

> > > And rds_type is:
> > >
> > > V4L2_TUNER_RDS_TYPE_RDS   0x00
> > > V4L2_TUNER_RDS_TYPE_RBDS  0x01

Is it necessary to make a distinction between RDS and RBDS?

> > > Finally I would prefer to have the requirement that the driver will
> > > buffer at least 10 seconds worth of data (comes to 1200 bytes).
> >
> > Why? IMO, this seems to be something that should be a requirement at user
> > side, not at kernel side: After changing from one station to another, and
> > start receiving RDS/RBDS, wait for some time before output the data.
> >
> > > Or perhaps we should add a field that reports the maximum number of
> > > buffered packets? E.g. __u16 rds_buf_size. This might be more generic
> > > and you can even allow this to be set with VIDIOC_S_TUNER (although
> > > drivers can ignore it).
> >
> > Why to spend 16 bits for it? It seems easier to check for for the amount
> > of received packets on userspace. I think we should avoid to waste those
> > reserved bytes.
>
> Hmm, I'm too creative here, I agree. Let's keep it simple.

It would nice if there was a way to flush the buffer.  When changing
channels, I imaging software would like to be sure that it does not receive
stale data from the previous channel.  Maybe just define that changing
frequencies empties the buffer?  Keep in mind, there could be data sitting
in an on card buffer waiting for DMA, or DMAed data waiting for the IRQ
handler to processes it.  So just calling read() could easily not give you
all data received prior to calling read().
