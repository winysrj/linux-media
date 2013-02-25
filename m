Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab3BYLxx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Feb 2013 06:53:53 -0500
Date: Mon, 25 Feb 2013 08:53:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Ron Andreasen <dlanor78@gmail.com>,
	linux-media@vger.kernel.org, ivtv-users@ivtvdriver.org
Subject: Re: 3.7/3.8 kernel won't boot with Hauppauge pvr-150
Message-ID: <20130225085305.5871e603@redhat.com>
In-Reply-To: <201302220751.58931.hverkuil@xs4all.nl>
References: <CADUyVi=ztr2uF8jb6urSMtJ0yKRFrLWHrCHYmgKX+-9BTRsRFQ@mail.gmail.com>
	<ab89dced-9718-4e81-a2c9-1581e0528eb9@email.android.com>
	<1361546262.1968.11.camel@palomino.walls.org>
	<201302220751.58931.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Feb 2013 07:51:58 -0800
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Friday, February 22, 2013 07:17:42 Andy Walls wrote:
> > On Thu, 2013-02-21 at 22:32 -0500, Andy Walls wrote:
> > > Ron Andreasen <dlanor78@gmail.com> wrote:
> > > 
> > > >I've been having trouble getting distros that have any kernel above the
> > > >3.5
> > > >series to boot (only tried 64-bit). I get a black screen with a bunch
> > > >of
> > > >text and the boot process goes no further. I don't know if this is
> > > >usually
> > > >okay, but I'm posting a link to a picture I took of my monitor with my
> > > >cell
> > > >phone. It's a bit blurry but hopefully it's still okay:
> > > >
> > > >http://imgur.com/viP1kWk,3YJXKbG
> > > >
> > > >The distros I've had this problem in are Kubuntu (I've tried several of
> > > >the
> > > >daily builds) which uses the 3.8.? (can't boot far enough to see)
> > > >kernel,
> > > >Cinnarch which uses the 3.7.3 kernel, and openSUSE 12.3 and I don't
> > > >remember what version of the kernel that one used.
> 
> Please note that any 3.8 kernel is terminally broken with ivtv/cx18 and will
> crash during boot as long as this patch is not applied:
> 
> http://git.linuxtv.org/media_tree.git/commit/cfb046cb800ba306b211fbbe4ac633486e11055f
> 
> It can be worked around by renaming ivtv-alsa.ko, as Andy mentioned.
> 
> I hope to get this patch into the 3.8 stable series as soon as possible.
> I have to wait until it is merged into mainline first, though.

The patch got merged upstream yesterday:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=cfb046cb800ba306b211fbbe4ac633486e11055f

As it was tagged with:
	 Cc: stable@vger.kernel.org # for 3.8

I expect that it will be available for 3.8.1 after the end of the
merge window.

Regards,
Mauro
