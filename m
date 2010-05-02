Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1468 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758420Ab0EBSMA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 14:12:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: em28xx & sliced VBI
Date: Sun, 2 May 2010 20:13:03 +0200
Cc: linux-media@vger.kernel.org
References: <201005012312.14082.hverkuil@xs4all.nl> <k2w829197381005021025ra9b453bfv54900a16ae5fb580@mail.gmail.com> <y2l829197381005021049ze19f886cyedeeb79da4d87229@mail.gmail.com>
In-Reply-To: <y2l829197381005021049ze19f886cyedeeb79da4d87229@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005022013.03216.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 02 May 2010 19:49:33 Devin Heitmueller wrote:
> On Sun, May 2, 2010 at 1:25 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
> > On Sat, May 1, 2010 at 5:12 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> Hi all,
> >>
> >> I played a bit with my HVR900 and tried the sliced VBI API. Unfortunately I
> >> discovered that it is completely broken. Part of it is obvious: lots of bugs
> >> and code that does not follow the spec, but I also wonder whether it ever
> >> actually worked.
> >>
> >> Can anyone shed some light on this? And is anyone interested in fixing this
> >> driver?
> >>
> >> I can give pointers and help with background info, but I do not have the time
> >> to work on this myself.
> >>
> >> Regards,
> >>
> >>        Hans
> >
> > Hi Hans,
> >
> > I did the em28xx raw VBI support, and I can confirm that the sliced
> > support is completely broken.  I just forgot to send the patch
> > upstream which removes it from the set of v4l2 capabilities advertised
> > for the device.
> 
> Sorry, I forgot to answer the second half of the email.
> 
> We've got no plans to get the sliced VBI support working in em28xx.
> Everybody who has asked KernelLabs to do the work has been perfectly
> satisfied with the raw VBI support, so it just doesn't feel like there
> is a benefit worthy of the effort required.  Also, as far as I can
> tell, every Windows application I have seen which uses VBI against the
> em28xx all do it in raw mode, so I don't even have a way of verifying
> that the sliced VBI even works with the chip.
> 
> The time is better spent working on other things, although we should
> definitely do a one line patch so that the driver doesn't claim to
> support sliced mode.

Why not just nuke everything related to sliced VBI? Just leave a comment
saying that you should look at older versions if you want to resurrect sliced
vbi. That's what version control systems are for.

I hate code that doesn't do anything. It pollutes the source, it confuses the
reader and it increases the size for no good reason. And people like me spent
time flogging a dead horse :-(

Sliced VBI really only makes sense in combination with compressed video
streams. Or perhaps on SoCs where you don't want to process the raw VBI.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
