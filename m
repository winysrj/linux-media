Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:2478 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbZEVMkU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 08:40:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: Re: About VIDIOC_G_OUTPUT/S_OUTPUT ?
Date: Fri, 22 May 2009 14:40:13 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"dongsoo45.kim@samsung.com" <dongsoo45.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?utf-8?q?=EA=B9=80=ED=98=95=EC=A4=80?= <riverful.kim@samsung.com>
References: <5e9665e10905200448n1ffc9d8s20317bbbba745e6a@mail.gmail.com> <200905211407.05354.hverkuil@xs4all.nl> <5e9665e10905211905t43ae195cv7a0fe243077887c9@mail.gmail.com>
In-Reply-To: <5e9665e10905211905t43ae195cv7a0fe243077887c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221440.13444.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 22 May 2009 04:05:47 Dongsoo, Nathaniel Kim wrote:
> Hi Hans,
>
> On Thu, May 21, 2009 at 9:07 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Wednesday 20 May 2009 13:48:08 Dongsoo, Nathaniel Kim wrote:
> >> Hello everyone,
> >>
> >> Doing a new camera interface driver job of new AP from Samsung, a
> >> single little question doesn't stop making me confused.
> >> The camera IP in Samsung application processor supports for two of
> >> output paths, like "to memory" and "to LCD FIFO".
> >> It seems to be VIDIOC_G_OUTPUT/S_OUTPUT which I need to use (just
> >> guessing), but according to Hans's ivtv driver the "output" of
> >> G_OUTPUT/S_OUTPUT is supposed to mean an actually and physically
> >> separated real output path like Composite, S-Video and so on.
> >>
> >> Do you think that memory or LCD FIFO can be an "output" device in this
> >> case? Because in earlier version of my driver, I assumed that the "LCD
> >> FIFO" is a kind of "OVERLAY" device, so I didn't even need to use
> >> G_OUTPUT and S_OUTPUT to route output device. I'm just not sure about
> >> which idea makes sense. or maybe both of them could make sense
> >> indeed...
> >
> > When you select "to memory", then the video from the camera is DMAed to
> > the CPU, right? But selecting "to LCD" means that the video is routed
> > internally to the LCD without any DMA to the CPU taking place, right?
>
> Yes definitely right.
>
> > This is similar to the "passthrough" mode of the ivtv driver.
> >
> > This header: linux/dvb/video.h contains an ioctl called
> > VIDEO_SELECT_SOURCE, which can be used to select either memory or a
> > demuxer (or in this case, the camera) as the source of the output (the
> > LCD in this case). It is probably the appropriate ioctl to implement
> > for this.
>
> So, in user space we should call  VIDIO_SELECT_SOURCE ioctl?

Yes.

> > The video.h header is shared between v4l and dvb and contains several
> > ioctls meant to handle output. It is poorly documented and I think it
> > should be merged into the v4l2 API and properly documented/cleaned up.
>
> I agree with you. Anyway, camera interface is not a DVB device but
> supporting this source routing feature means that we also need this
> API in v4l2.

It's valid to use VIDEO_SELECT_SOURCE in an v4l2 driver. It's currently used 
by ivtv. It's an historical accident that these ioctls ended up in the dvb 
header.

> > Note that overlays are meant for on-screen displays. Usually these are
> > associated with a framebuffer device. Your hardware may implement such
> > an OSD as well, but that is different from this passthrough feature.
>
> Sorry Hans, I'm not sure that I'm following this part. Can I put it in
> the way like this?
> The OSD feature in Samsung AP should be handled separated with the
> selecting source feature (camera-to-FB and camera-to-memory). So that
> I should implement both of them. (overlay feature and select source
> feature)
> Am I following? Please let me know if there is something wrong.

Yes, that's correct.

>
> BTW, my 5M camera driver which is including the new V4L2 API proposal
> I gave a talk in SF couldn't have approval from my bosses to be opened
> to the public. But I'll try to make another camera device driver which
> can cover must of the API I proposed.

That's a shame. Erm, just to make it clear for your bosses: any v4l2 driver 
that uses any of the videobuf_*, v4l2_i2c_*, v4l2_device_* or v4l2_int_* 
functions must be a GPL driver, and thus has to be made available upon 
request. All these functions are marked EXPORT_SYMBOL_GPL. I don't know if 
they realize this fact.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
