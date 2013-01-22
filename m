Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:1942 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3AVKfy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 05:35:54 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: "'Sakari Ailus'" <sakari.ailus@iki.fi>
Subject: Re: [PATCH 3/3] v4l: Set proper timestamp type in selected drivers which use videobuf2
Date: Tue, 22 Jan 2013 11:35:28 +0100
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, pawel@osciak.com
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com> <029c01cdf7e0$b64ce4c0$22e6ae40$%debski@samsung.com> <20130122100303.GM13641@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130122100303.GM13641@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221135.29016.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 22 January 2013 11:03:03 'Sakari Ailus' wrote:
> Hi Kamil,
> 
> (Cc'ing Pawel and Marek as well.)
> 
> On Mon, Jan 21, 2013 at 03:07:55PM +0100, Kamil Debski wrote:
> > Hi,
> > 
> > > From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> > > Sent: Saturday, January 19, 2013 6:43 PM
> > > Hi Kamil,
> > > 
> > > Thanks for the patch.
> > > 
> > > On Mon, Jan 14, 2013 at 10:36:04AM +0100, Kamil Debski wrote:
> > > > Set proper timestamp type in drivers that I am sure that use either
> > > > MONOTONIC or COPY timestamps. Other drivers will correctly report
> > > > UNKNOWN timestamp type instead of assuming that all drivers use
> > > > monotonic timestamps.
> > > 
> > > What other kind of timestamps there can be? All drivers (at least those
> > > not
> > > mem-to-mem) that do obtain timestamps using system clock use monotonic
> > > ones.
> > 
> > Not set. It is not a COPY or MONOTONIC either. Any new or custom kind of
> > timestamp, maybe?
> 
> Then new timestamp types should be defined for the purpose. Which is indeed
> what your patch is about.
> 
> And about "COPY" timestamps: if an application wants to use timestamps, it
> probably need to know what kind of timestamps they are. "COPY" doesn't
> provide that information as such. Only the program that sets the timestamps
> for the OUTPUT buffers does.

For these m2m devices the driver does not use the timestamp value at all, it
just copies it from the output stream (i.e. towards the codec) to the input
stream (i.e. from the codec). Since the application got the video from somewhere
the application presumably knows the type of the timestamp.

So I think marking this as COPY is a very good idea. It makes no sense to
put in a specific timestamp type since the driver doesn't control that at all.

Things are quite different when it is the driver that generates the timestamp,
then the application needs to know what sort of timestamp the driver generated
and that should be filled in correctly by the driver.

> > > I'd think that there should no longer be any drivers using the UNKNOWN
> > > timestamp type: UNKNOWN is either from monotonic or realtime clock, and
> > > we just replaced all of them with the monotonic ones. No driver uses
> > > realtime timestamps anymore.
> > 
> > Maybe there should be no drivers using UNKNOWN. But definitely
> > there should be no driver reporting MONOTONIC when the timestamp is not
> > monotonic.
> >  
> > > How about making MONOTONIC timestamps default instead, or at least
> > > assigning all drivers something else than UNKNOWN?
> > 
> > So why did you add the UNKNOWN flag?
> 
> This is for API compatibility only. Applications running on kernels prior to
> the headers of which define timestamp types will not have timestamp type set
> (i.e. is zero, which equals to UNKNOWN). There was a lengthy discussion on
> the topic back then, and the conclusion was that the kernel version itself
> isn't enough to tell what kind of timestamps are provided to the user.
> 
> Any new driver shouldn't use UNKNOWN timestamps since in this case the
> application would have to know what kind of timestamps the driver uses ---
> which is why we now specify it in the API.
> 
> > The way I see it - UNKNOWN is the default and the one who coded the driver
> > will set it to either MONOTONIC or COPY if it is one of these two. It won't
> > be changed otherwise. There are drivers, which do not fill the timestamp
> > field
> > at all:
> > - drivers/media/platform/coda.c
> > - drivers/media/platform/exynos-gsc/gsc-m2m.c
> > - drivers/media/platform/m2m-deinterlace.c
> > - drivers/media/platform/mx2_emmaprp.c
> > - drivers/media/platform/s5p-fimc/fimc-m2m.c
> > - drivers/media/platform/s5p-g2d.c
> > - drivers/media/platform/s5p-jpeg/jpeg-core.c
> 
> Excellent point.
> 
> But --- should these drivers then fill the timestamp field? Isn't it a bug
> in the driver not to do so?

Not for mem2mem devices. You give it a frame with an associate timestamp which
is copied to the (de)coded frame. The timestamps here indicate when the original
frame was generated, which is information you want to keep.

Note that the COPY timestamp assumes that there is a 1-to-1 mapping between
an input frame and an output frame. If that's no longer the case (e.g. if
a sequence of discrete frames is encoded as an MPEG bitstream), then drivers
should just generate MONOTONIC timestamps. Unlikely to be very useful, but
if nothing else it might be used for some performance measurements.

> > The way you did it in your patches left no room for any kind of choice. I
> > did
> > comment at least twice about mem-2-mem devices in your RFCs, if I remember
> > correctly. I think Sylwester was also writing about this. 
> > Still everything got marked as MONOTONIC. 
> 
> I must have missed this in the discussion back then.
> 
> > If we were to assume that there were no other timestamp types then monotonic
> > (which is not true, but this was your assumption), then what was the reason
> > to add this timestamp framework?
> 
> For capture devices whose video source has no native timestamps the
> timestamps are MONOTONIC, at least until it is made selectable. Other
> examples could include video decoders or encoders, but these timestamps will
> be entirely different kind, and probably doesn't end up to the timestamp
> field.

Regards,

	Hans
