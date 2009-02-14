Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2855 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbZBNJZC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 04:25:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: RFC: Finalizing the V4L2 RDS interface
Date: Sat, 14 Feb 2009 10:24:57 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, Michael Schimek <mschimek@gmx.at>,
	hjkoch@users.berlios.de, tobias.lorenz@gmx.net,
	belavenuto@gmail.com
References: <200902130955.19995.hverkuil@xs4all.nl> <200902132259.07618.hverkuil@xs4all.nl> <Pine.LNX.4.58.0902131609150.24268@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0902131609150.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902141024.57771.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 14 February 2009 01:42:31 Trent Piepho wrote:
> On Fri, 13 Feb 2009, Hans Verkuil wrote:
> > On Friday 13 February 2009 22:15:45 Mauro Carvalho Chehab wrote:
> > > On Fri, 13 Feb 2009 09:55:19 +0100
> > >
> > > > The V4L API defines its RDS API as follows.
> > > >
> > > > From radio devices supporting it, RDS data can be read with the
> > > > read() function. The data is packed in groups of three, as follows:
> > > >
> > > > First Octet: Least Significant Byte of RDS Block
> > > > Second Octet: Most Significant Byte of RDS Block
> > > > Third Octet:
> > > > 	Bit 7: Error bit. Indicates that an uncorrectable error occurred
> > > > 	       during reception of this block.
> > > > 	Bit 6: Corrected bit. Indicates that an error was corrected for
> > > > 	       this data block.
> > > > 	Bits 5-3: Received Offset. Indicates the offset received by the
> > > > 		  sync system.
> > > > 	Bits 2-0: Offset Name. Indicates the offset applied to this data.
>
> What device file does one read from, the radio device or is there another
> one for RDS data?

The radio device.

> If the radio device, then maybe it should handle (S|G|TRY)_FMT ioctls, so
> that one can select the format.  Since the drivers probably already use
> v4l2_ioctl, this should be easy enough to do.
>
> Some hardware might produce at a higher or lower level in the decoding
> stack that just doesn't fit this format.
>
> For instance, the common cx88 chip has some sort of RDS decoding ability.
> I think it returns 36 kHz 16 bit I/Q data from the RDS carrier that
> something like gnuradio would need to demodulate.  That's a completely
> different format that this one.  Though I think it might make more sense
> to use ALSA to get data in this format.

Hmm, basically raw RDS data. Interesting.

I'll look into this. It certainly makes it a lot more future-proof by using 
the FMT ioctls.

> > > > And we can add support to select RDS/RDBS by using one of the
> > > > reserved fields:
> > > >
> > > > __u8 	rds_type;
> > > > __u8 	rds_signal;	/* RDS signal strength quality, 0-255 */
> > > > __u8 	rds_reserved[2];
> > > > __u32   reserved[3];
>
> Do any devices support returning signal strength or quality?  If so, can
> we get real units from them?

The saa6588 support has a register containing the signal quality, but there 
are no units attached to that. Just a value 0-15.

> > > > And rds_type is:
> > > >
> > > > V4L2_TUNER_RDS_TYPE_RDS   0x00
> > > > V4L2_TUNER_RDS_TYPE_RBDS  0x01
>
> Is it necessary to make a distinction between RDS and RBDS?

I need to do a bit more research, but I'm fairly confident that the answer 
is yes. The saa6588 requires you to set it, the si470x seems to handle only 
the RDS subset of RBDS (no support for block E as far as I could see).

Note that I modified the types to:

V4L2_TUNER_RDS_TYPE_NONE  0x00
V4L2_TUNER_RDS_TYPE_RDS   0x01
V4L2_TUNER_RDS_TYPE_RBDS  0x02

This field is currently always 0, so that should indicate no RDS. In 
addition, it might be useful to have the option to turn off RDS decoding to 
save resources if you do not need it.

> > > > Finally I would prefer to have the requirement that the driver will
> > > > buffer at least 10 seconds worth of data (comes to 1200 bytes).
> > >
> > > Why? IMO, this seems to be something that should be a requirement at
> > > user side, not at kernel side: After changing from one station to
> > > another, and start receiving RDS/RBDS, wait for some time before
> > > output the data.
> > >
> > > > Or perhaps we should add a field that reports the maximum number of
> > > > buffered packets? E.g. __u16 rds_buf_size. This might be more
> > > > generic and you can even allow this to be set with VIDIOC_S_TUNER
> > > > (although drivers can ignore it).
> > >
> > > Why to spend 16 bits for it? It seems easier to check for for the
> > > amount of received packets on userspace. I think we should avoid to
> > > waste those reserved bytes.
> >
> > Hmm, I'm too creative here, I agree. Let's keep it simple.
>
> It would nice if there was a way to flush the buffer.  When changing
> channels, I imaging software would like to be sure that it does not
> receive stale data from the previous channel.  Maybe just define that
> changing frequencies empties the buffer?  Keep in mind, there could be
> data sitting in an on card buffer waiting for DMA, or DMAed data waiting
> for the IRQ handler to processes it.  So just calling read() could easily
> not give you all data received prior to calling read().

Good point. Changing frequencies or input should flush any internal buffers. 
I think that it is overkill to add an option to explicitly flush buffers. 
It can always be added later if needed.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
