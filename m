Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:22024 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbZI0Lv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Sep 2009 07:51:56 -0400
Received: by qw-out-2122.google.com with SMTP id 5so1348146qwd.37
        for <linux-media@vger.kernel.org>; Sun, 27 Sep 2009 04:52:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909252322.26427.hverkuil@xs4all.nl>
References: <200909252322.26427.hverkuil@xs4all.nl>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Sun, 27 Sep 2009 20:51:40 +0900
Message-ID: <5e9665e10909270451l28e90ffaw862d04061ad66253@mail.gmail.com>
Subject: Re: V4L-DVB Summit Day 3
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Sep 26, 2009 at 3:22 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi all,
>
> Well, that was another very successful day here in Portland.
>
> I started off presenting the work we did in the past year and our plans for
> the next year during the BoF this morning. It was quite a big crowd and the
> talk was well received.
>
> The presentation is available from my website:
>
> http://www.xs4all.nl/~hverkuil/lpc/bof.odp
>
> The nice thing was that this presentation was hot off the press as it
> presented all the things we discussed in the two preceding days of the summit.
>
> Two additional presentations from Samsung regarding their SoCs and their
> implementation of a memory pool-like API are also available from my website:
>
> http://www.xs4all.nl/~hverkuil/lpc/Samsung_SoCs.ppt
> http://www.xs4all.nl/~hverkuil/lpc/Unified_media_buffers.pdf
>
> Unfortunately I couldn't attend the presentation from Hans de Goede and
> Brandon Philips, so I can't comment on that. It would be great if someone can
> post a report of that presentation (and links to the presentation itself, if
> possible).
>
> During the afternoon we worked on assigning people to the various tasks that
> need to be done.
>
> I made the following list:
>
> - We created a new mc mailinglist: linux-mc@googlegroups.com
>
> This is a temporary mailinglist where we can post and review patches during
> prototyping of the mc API. We don't want to flood the linux-media list with
> those patches since that is already quite high-volume.
>
> The mailinglist should be active, although I couldn't find it yet from
> www.googlegroups.com. I'm not sure if it hasn't shown up yet, or if I did
> something wrong.
>
> - implement sensor v4l2_subdev support (Laurent). We are still missing some
> v4l2_subdev sensor ops for setting up the bus config and data format. Laurent
> will look into implementing those. An RFC for the bus config already exists
> and will function as the basis of this.
>
> - when done, remove the v4l2-int-device API (Nokia, target 2.6.33). It's
> important to finally remove this non-standard API. When we can setup sensors
> properly using subdevs, then Nokia can convert the final two users of this API
> to v4l2_subdev.
>
> - subdev migration omap3:
>        - ISP (Laurent)
>        - video decoder (Vaibhav)
>        - display (Vaibhav)
>
> These are the initial test implementations for the media controller:
> converting the various parts of the omap3 driver to subdevs and see how these
> can be controller via the mc.
>
> - subdev migration Moorestown (Intel):
>        - sensors
>        - LED driver
>        - video decoder/encoder
>        - more...
>
> Intel will do something similar for their Moorestown platform.
>
> - Samsung: investigate V4L2 API and mc concept.
>
> Samsung needs to investigate the V4L2 API and the mc proposal first before
> they can commit to anything.
>

BTW I just forgot to ask Marek and Tomasz to ask you guys at
mini-summit about can the HDMI device fit into the v4l2 framework.
Because as far as my investigation, I found HDMI interface driver from
Intel not in the v4l2 drivers but in gpu drivers and totally doesn't
seem to be a v4l2 one at all.

As you already know, the new arm based SoC from Samsung has HDMI
interface and I'm very curious about which approach is better one
between v4l2 approach and framebuffer approach. Because that HDMI
interface has a mixer feature just like an overlay feature in
framebuffer devices. It will be nice if someone points me the right
way :)

According to your mail, I suppose that this conference was a
magnificent and important turning point for v4l2. I wished I could
attend the conference but trillions of works were stuck in my queue
:'(
Cheers,

Nate

-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
