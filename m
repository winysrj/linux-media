Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2888 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZEULyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 07:54:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: ext-eero.nurkkala@nokia.com
Subject: Re: [PATCH 0/2] V4L: Add BCM2048 radio driver
Date: Thu, 21 May 2009 13:54:12 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1242024079959-git-send-email-ext-eero.nurkkala@nokia.com> <200905120910.29214.hverkuil@xs4all.nl> <1242720549.19944.140.camel@eenurkka-desktop>
In-Reply-To: <1242720549.19944.140.camel@eenurkka-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905211354.12888.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 19 May 2009 10:09:09 Eero Nurkkala wrote:
> On Tue, 2009-05-12 at 09:10 +0200, ext Hans Verkuil wrote:
> > On Tuesday 12 May 2009 09:03:42 Eero Nurkkala wrote:
> > > On Tue, 2009-05-12 at 08:51 +0200, ext Hans Verkuil wrote:
> > > > I recommend that you move the RDS decoder code into an rds library
> > > > in the v4l2-apps directory of the v4l-dvb tree. As you say, the rds
> > > > decoder implementation does not belong in the driver, but it would
> > > > be very nice to have it as a library.
> > >
> > > Quick question, is there a RDS decoder library already out there?
> > > Or would it be the case it needs to be done from the scratch?
> >
> > Yes, here: http://rdsd.berlios.de/
> >
> > However, it's badly written and overly complicated. We need something
> > much simpler, doing just the basic decoding.
>
> Ok. I checked these libraries. Quickly looking they appear somewhat
> complicated as you mentioned. That's written in c++ like convention...
>
> If I'd have time, I'd redo all of that =)
>
> > > > Such region tables do not belong in a driver IMHO. These too should
> > > > go to a userspace library (libv4l2util? It already contains
> > > > frequency tables for TV).
> > >
> > > That's correct. Is there a link to this library?
> >
> > It's in the v4l2-apps directory of the main v4l-dvb repository.
> >
> > > > A more general comment: this driver should be split into two parts:
> > > > the radio tuner core should really be implemented using the tuner
> > > > API similar to the tea5767 radio tuner driver. That way this radio
> > > > tuner driver can be reused when it is placed on e.g. a TV tuner
> > > > card. However, the tuner API is missing functionality for e.g. RDS.
> > > > Alternatively, the core driver can be rewritten as an v4l2_subdev
> > > > driver, again allowing reuse in other drivers.
> > >
> > > Hmm. This chip is integrated on Bluetooth silicon, so could you
> > > please elaborate how it could be reused with a TV tuner? (Maybe I
> > > didn't just get the point, or if the manufacturer decides to
> > > integrate (in the future) the chip with TV tuner card, or someone
> > > wishes to use other manufacturers' TV tuner, but this radio chip at
> > > the same time?)
> >
> > Hmm, I need to think about this. BTW, is there a datasheet of some kind
> > available for this chip?
>
> I could try arrange you one if you really wish and need to have one?
>
> > Regards,
> >
> > 	Hans

Yes, I'd really like to see it. I'm willing to sign an NDA if necessary.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
