Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1I7GEX024259
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 13:07:16 -0500
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1I7Efp016785
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 13:07:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 1 Dec 2008 19:07:06 +0100
References: <200812011246.08885.hverkuil@xs4all.nl>
	<200812011524.43499.laurent.pinchart@skynet.be>
	<20081201130643.661f5743@pedra.chehab.org>
In-Reply-To: <20081201130643.661f5743@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011907.06370.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com,
	davinci-linux-open-source-bounces@linux.davincidsp.com,
	linux-kernel@vger.kernel.org,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng
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

On Monday 01 December 2008 16:06:43 Mauro Carvalho Chehab wrote:
> Hi Hans,
>
> On Mon, 1 Dec 2008 15:24:43 +0100
>
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > > > I am all for pushing the changes to the v4l-dvb repository so
> > > > they can get broader testing. I am, however, a bit more
> > > > concerned about pushing the changes to Linus yet.
> > >
> > > They will of course go to linux-next and end up in 2.6.29 when
> > > the merge window opens. It's obviously not for 2.6.28.
> >
> > I would say 2.6.29 is a bit early, but I can live with that.
>
> It also seems a bit early to me, but it may work. I'll try to
> schedule some time this week for a deep review.

Much appreciated.

> > > In addition, these changes make it easier as well to use the new
> > > i2c API in bridge drivers (in 2.6.29 the old-style I2C probing
> > > will be deprecated, so we need to convert). So we get many
> > > benefits with just these changes.
>
> IMO, this is one of the top priorities: the old-style i2c used on
> some bridge drivers like saa7134 and cx88 are causing malfunctions
> that can't be easily solved. I would like to see a fix for this for
> 2.6.29.

Using v4l2_i2c_new_subdev or v4l2_i2c_new_probed_subdev should make it 
much easier to switch over. It certainly simplified it for ivtv.

> > > Of course, I want to add more v4l2 framework support to these new
> > > structures, but I don't have any code yet for that anyway, just
> > > lots of ideas. Start simple, then expand.
> > >
> > > > I don't know if that's possible at all, or if all changes in
> > > > v4l-dvb are automatically selected for a push to the git
> > > > repository whenever Mauro triggers the hg->git process.
> > >
> > > Well, they go to linux-next, but is that a problem?
>
> I only send Linus the patches that are already ok, but I generally
> prefer to postpone a merge for the end of a merge window, when the
> patch is not meant to be at the next version.
>
> > In a few months time (probably even earlier) the v4l2_device
> > structure will be reworked (and possible renamed).
>
> Hmm... why? it would be better to try to have the KABI changes for it
> at the same kernel release if possible.

I would like to state again that I have no plans to rename it. There is 
a chance that it will be used by the dvb subsystem as well in the 
future, but that's not going to happen any time soon. But should that 
happen, then we might consider renaming it to 
media_device/media_subdev. However, right now it is very much v4l2 
specific code. I think it more likely that if this is used in dvb then 
it would be for v4l2 functionality, not dvb functionality.

There will definitely be future additions since this is only the first 
step. Things on my list: better framework support for controls, 
v4l2_prio handling, adding a similar v4l2_fh struct for 
filehandle-specific data and the media controller which has been 
discussed in earlier RFCs and that requires these fundamental data 
structs to be in place first.

Replacing the v4l2-int-device.h API with v4l2_subdev and adding support 
for sensor drivers to the v4l2_subdev ops will also no doubt require 
additions.

But I want to do this step by step. It's just humanly impossible to go 
for a Big Bang here. Each time something gets added there must be at 
least one driver actually using it so you have some confidence in the 
change. Just integrating these simple v4l2_device and v4l2_subdev 
structs will take a fair amount of time.

Regards,

	Hans

> > I'm fine with it going to linux-next now if
> > we agree on the following.
> >
> > - We should only advocate v4l2_device usage for subdevices-aware
> > video devices. Porting all drivers to v4l2_device is currently
> > pointless and will only make future transitions more difficult.
>
> This makes sense to me.
>
> > - v4l2_device should be marked as experimental. I don't want to
> > hear any API/ABI breakage argument in a few months time when the
> > framework will evolve.
>
> Are you meaning marking this as experimental at Kconfig? This seems
> too complex, since we'll need to test for some var on every driver
> that were converted, providing two KABI options for each converted
> driver (the legacy and the v4l2_device way). This doesn't seem to be
> a good idea, since will add a lot of extra complexity to debug bugs.
>
> Cheers,
> Mauro



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
