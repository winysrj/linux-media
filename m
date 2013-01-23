Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55110 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3AWAYM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 19:24:12 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Sakari Ailus' <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	mchehab@redhat.com, hans.verkuil@cisco.com,
	kyungmin.park@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>, pawel@osciak.com
Subject: Re: [PATCH 3/3] v4l: Set proper timestamp type in selected drivers which use videobuf2
Date: Wed, 23 Jan 2013 01:25:57 +0100
Message-ID: <1544471.1HQKnOoEvq@avalon>
In-Reply-To: <032d01cdf88a$9ed559d0$dc800d70$%debski@samsung.com>
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com> <20130122100303.GM13641@valkosipuli.retiisi.org.uk> <032d01cdf88a$9ed559d0$dc800d70$%debski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Tuesday 22 January 2013 11:24:09 Kamil Debski wrote:
> On Tuesday, January 22, 2013 11:03 AM Sakari Ailus wrote:
> > On Mon, Jan 21, 2013 at 03:07:55PM +0100, Kamil Debski wrote:
> > > On Saturday, January 19, 2013 6:43 PM Sakari Ailus wrote:
> > > > On Mon, Jan 14, 2013 at 10:36:04AM +0100, Kamil Debski wrote:
> > > > > Set proper timestamp type in drivers that I am sure that use
> > > > > either MONOTONIC or COPY timestamps. Other drivers will correctly
> > > > > report UNKNOWN timestamp type instead of assuming that all
> > > > > drivers use monotonic timestamps.
> > > > 
> > > > What other kind of timestamps there can be? All drivers (at least
> > > > those not mem-to-mem) that do obtain timestamps using system clock use
> > > > monotonic ones.
> > > 
> > > Not set. It is not a COPY or MONOTONIC either. Any new or custom kind
> > > of timestamp, maybe?
> > 
> > Then new timestamp types should be defined for the purpose. Which is
> > indeed what your patch is about.
> > 
> > And about "COPY" timestamps: if an application wants to use timestamps,
> > it probably need to know what kind of timestamps they are. "COPY"
> > doesn't provide that information as such. Only the program that sets
> > the timestamps for the OUTPUT buffers does.
> 
> For me the COPY type is clear. If the app gets a COPY timestamp on a
> buffer (CAPTURE) then it knows that it was copied from the OUTPUT buffer.
> If the application did not set the timestamp for OUTPUT buffer, then
> it has to cope with the consequences.
> 
> > > > I'd think that there should no longer be any drivers using the
> > > > UNKNOWN timestamp type: UNKNOWN is either from monotonic or realtime
> > > > clock, and we just replaced all of them with the monotonic ones. No
> > > > driver uses realtime timestamps anymore.
> > > 
> > > Maybe there should be no drivers using UNKNOWN. But definitely there
> > > should be no driver reporting MONOTONIC when the timestamp is not
> > > monotonic.
> > > 
> > > > How about making MONOTONIC timestamps default instead, or at least
> > > > assigning all drivers something else than UNKNOWN?
> > > 
> > > So why did you add the UNKNOWN flag?
> > 
> > This is for API compatibility only. Applications running on kernels
> > prior to the headers of which define timestamp types will not have
> > timestamp type set (i.e. is zero, which equals to UNKNOWN). There was a
> > lengthy discussion on the topic back then, and the conclusion was that
> > the kernel version itself isn't enough to tell what kind of timestamps
> > are provided to the user.
> > 
> > Any new driver shouldn't use UNKNOWN timestamps since in this case the
> > application would have to know what kind of timestamps the driver uses
> > --- which is why we now specify it in the API.
> > 
> > > The way I see it - UNKNOWN is the default and the one who coded the
> > > driver will set it to either MONOTONIC or COPY if it is one of these
> > > two. It won't be changed otherwise. There are drivers, which do not
> > > fill the timestamp field at all:
> > > - drivers/media/platform/coda.c
> > > - drivers/media/platform/exynos-gsc/gsc-m2m.c
> > > - drivers/media/platform/m2m-deinterlace.c
> > > - drivers/media/platform/mx2_emmaprp.c
> > > - drivers/media/platform/s5p-fimc/fimc-m2m.c
> > > - drivers/media/platform/s5p-g2d.c
> > > - drivers/media/platform/s5p-jpeg/jpeg-core.c
> > 
> > Excellent point.
> > 
> > But --- should these drivers then fill the timestamp field? Isn't it a
> > bug in the driver not to do so?
> 
> Could be. The only thing I am complaining about is that the type should not
> be reported as monotonic when it is not.

Of course.

> (We can argue that constant is monotonic, but I think that it is not the
> point :-) ). This is why I propose to leave UNKNOWN as the default choice
> (which it is in case of non videobuf2 drivers). It is possible to eliminate
> the UNKNOWN in my opinion, but it should be up to the programmer to set the
> type. Another option is to eliminate the UNKNOWN flag in the next, or in two
> kernel releases. After the drivers are changed. Still I prefer to leave the
> driver's programmer in charge and leave the UNKNOWN type.

I think that Sakari's point is that all non mem-to-mem drivers should use the 
MONOTONIC timestamps type. UNKNOWN, in the non mem-to-mem case, is only meant 
for compatibility with older kernels. We should thus default to MONOTONIC and 
let drivers select a different timestamp type when needed (for mem-to-mem 
drivers for instance).

> > > The way you did it in your patches left no room for any kind of
> > > choice. I did comment at least twice about mem-2-mem devices in your
> > > RFCs, if I remember correctly. I think Sylwester was also writing
> > > about this. Still everything got marked as MONOTONIC.
> > 
> > I must have missed this in the discussion back then.
> > 
> > > If we were to assume that there were no other timestamp types then
> > > monotonic (which is not true, but this was your assumption), then
> > > what was the reason to add this timestamp framework?
> > 
> > For capture devices whose video source has no native timestamps the
> > timestamps are MONOTONIC, at least until it is made selectable. Other
> > examples could include video decoders or encoders, but these timestamps
> > will be entirely different kind, and probably doesn't end up to the
> > timestamp field.

-- 
Regards,

Laurent Pinchart

