Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1F7pJ6026487
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 10:07:53 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1F6ttm028883
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 10:06:55 -0500
Date: Mon, 1 Dec 2008 13:06:43 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20081201130643.661f5743@pedra.chehab.org>
In-Reply-To: <200812011524.43499.laurent.pinchart@skynet.be>
References: <200812011246.08885.hverkuil@xs4all.nl>
	<200812011429.54019.laurent.pinchart@skynet.be>
	<200812011445.50115.hverkuil@xs4all.nl>
	<200812011524.43499.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
	davinci-linux-open-source-bounces@linux.davincidsp.com,
	linux-kernel@vger.kernel.org, v4l-dvb
	maintainer list <v4l-dvb-maintainer@linuxtv.org>,
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

Hi Hans,

On Mon, 1 Dec 2008 15:24:43 +0100
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> > > I am all for pushing the changes to the v4l-dvb repository so they
> > > can get broader testing. I am, however, a bit more concerned about
> > > pushing the changes to Linus yet.
> >
> > They will of course go to linux-next and end up in 2.6.29 when the merge
> > window opens. It's obviously not for 2.6.28.
> 
> I would say 2.6.29 is a bit early, but I can live with that.

It also seems a bit early to me, but it may work. I'll try to schedule some
time this week for a deep review.

> > In addition, these changes make it easier as well to use the new i2c API
> > in bridge drivers (in 2.6.29 the old-style I2C probing will be
> > deprecated, so we need to convert). So we get many benefits with just
> > these changes.

IMO, this is one of the top priorities: the old-style i2c used on some bridge
drivers like saa7134 and cx88 are causing malfunctions that can't be easily
solved. I would like to see a fix for this for 2.6.29.

> > Of course, I want to add more v4l2 framework support to these new
> > structures, but I don't have any code yet for that anyway, just lots of
> > ideas. Start simple, then expand.
> >
> > > I don't know if that's possible at all, or if all changes in v4l-dvb
> > > are automatically selected for a push to the git repository whenever
> > > Mauro triggers the hg->git process.
> >
> > Well, they go to linux-next, but is that a problem?

I only send Linus the patches that are already ok, but I generally prefer to
postpone a merge for the end of a merge window, when the patch is not meant to
be at the next version.

> In a few months time (probably even earlier) the v4l2_device structure will be 
> reworked (and possible renamed). 

Hmm... why? it would be better to try to have the KABI changes for it at the
same kernel release if possible.

> I'm fine with it going to linux-next now if 
> we agree on the following.

> - We should only advocate v4l2_device usage for subdevices-aware video 
> devices. Porting all drivers to v4l2_device is currently pointless and will 
> only make future transitions more difficult.

This makes sense to me.

> - v4l2_device should be marked as experimental. I don't want to hear any 
> API/ABI breakage argument in a few months time when the framework will 
> evolve.

Are you meaning marking this as experimental at Kconfig? This seems too
complex, since we'll need to test for some var on every driver that were
converted, providing two KABI options for each converted driver (the legacy and
the v4l2_device way). This doesn't seem to be a good idea, since will add a lot
of extra complexity to debug bugs.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
