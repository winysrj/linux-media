Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:1030 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZIKU3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 16:29:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: RFCv2: Media controller proposal
Date: Fri, 11 Sep 2009 22:29:41 +0200
Cc: linux-media@vger.kernel.org
References: <200909100913.09065.hverkuil@xs4all.nl> <200909112108.14033.hverkuil@xs4all.nl> <20090911165403.0d1b872d@caramujo.chehab.org>
In-Reply-To: <20090911165403.0d1b872d@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909112229.41357.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 11 September 2009 21:54:03 Mauro Carvalho Chehab wrote:
> Em Fri, 11 Sep 2009 21:08:13 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:

<snip>

> > OK, so instead we require an application to construct a file containing a new
> > topology, write something to a sysfs file, require code in the v4l core to load
> > and parse that file, then find out which links have changed (since you really
> > don't want to set all the links: there can be many, many links, believe me on
> > that), and finally call the driver to tell it to change those links.
> 
> As I said before, the design should take into account how frequent are those
> changes. If they are very infrequent, this approach works, and offers one
> advantage: the topology will survive to application crashes and warm/cold
> reboots. If the changes are frequent, an approach like the audio
> user_pin_configs work better (see my previous email - note that this approach
> can be used for atomic operations if needed). You add at a sysfs node just the
> dynamic changes you need. We may even have both ways, as alsa seems to have
> (init_pin_configs and user_pin_configs).

How frequent those changes are will depend entirely on the application.
Never underestimate the creativity of the end-users :-)

I think that a good worst case guideline would be 60 times per second.
Say for a surveillance type application that switches between video decoders
for each frame. Or some 3D type application that switches between two
sensors for each frame.

Of course, in the future you might want to get 3D done at 60 fps, meaning
that you have to switch between sensors 120 times per second.

One problem with media boards is that it is very hard to predict how they
will be used and what they will be capable of in the future.

Note that I am pretty sure that no application wants to have a media
board boot into an unpredicable initial topology. That would make life
very difficult for them.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
