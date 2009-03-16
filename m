Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZCPOYK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 10:24:10 -0400
Date: Mon, 16 Mar 2009 11:23:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Trent Piepho" <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
Message-ID: <20090316112314.05426ba8@pedra.chehab.org>
In-Reply-To: <45192.62.70.2.252.1237208659.squirrel@webmail.xs4all.nl>
References: <45192.62.70.2.252.1237208659.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Mar 2009 14:04:19 +0100 (CET)
"Hans Verkuil" <hverkuil@xs4all.nl> wrote:

> 
> >> > Based on this principle, IMO, the probing function should, by default,
> >> > probe
> >> > for tvaudio, if it doesn't find another audio device. You may
> >> eventually
> >> > ask
> >> > for people to report, to warn us that the board entry is broken, but
> >> we
> >> > shouln't intentionally break a device that we're almost sure that
> >> requires
> >> > tvaudio or tda7432.
> >>
> >> OK. In other words it would be better to probe for:
> >>
> >> 1) msp3400
> >> 2) msp3400_alt
> >> 3) tda7432
> >> 4) tvaudio
> >>
> >> and return as soon as we find a chip. So tvaudio is probed
> >> unconditionally, effectively ignoring the needs_tvaudio flag and only
> >> honoring the tvaudio module option (although I'm not sure whether that
> >> is
> >> still needed in that case).
> >
> > IMO, we should handle the needs_tvaudio with a different behaviour: using
> > such kind of
> > glue only when we're sure about the tv audio chips used for a certain
> > board. If
> > unsure, use the auto probing. Otherwise, we'll probe just that know
> > chip(s) range.
> 
> I have to admit that I've no idea what you mean. My patch replicates the
> original behavior of 'modprobe tvaudio' where all i2c addresses are probed
> that tvaudio supports (from the normal_i2c array in tvaudio.c). We cannot
> do a subset of this since it was never administrated which chip in
> particular is on the board, just that it is one of the chips supported by
> tvaudio.
> 
> If you want to be able to select particular devices, then you need to
> administrate that in the card definitions. That's out of scope of this
> patch IMHO.

You got my idea wrong. I'm just saying that maybe the better is to have the
default probing behaviour by default.

However, if the board has a defined set of tv audio modules that we're sure,
then we may override the automatic loading order.

So, the final implementation would be something like:

1) Try the modules that has explicit arguments at modprobe, or that needs_foo
first;
2) Try the probing way;
3) Give up trying to load an audio driver, printing an error message.

If we eventually found any bttv board without any audio driver, then we can add
a no_audio bit field to skip the probing process.

Note: since we can't really trust much on what we have (due to the non-standard
ways of probing the drivers, that it is possible with bttv), IMO, that
the logic you've implemented, with the adjustments I've proposed seem enough,
but this is just my 2 cents. 

We really need some feedback from the users to be sure if the bttv driver is
properly working with the new logic, to be more certain that this approach is
ok.


Cheers,
Mauro
