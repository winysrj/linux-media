Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2249 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab2BXJyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 04:54:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [RFCv1 PATCH 0/6] Improved/New timings API
Date: Fri, 24 Feb 2012 10:54:46 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1328263566-21620-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1328263566-21620-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202241054.46924.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, February 03, 2012 11:06:00 Hans Verkuil wrote:
> Hi all,
> 
> This is an implementation of this RFC:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg38168.html

Mauro,

I'd greatly appreciate it if you can review this API.

I've verified that it works well with CVT and GTF timings (the code for that
is in the test-timings branch in the git repo below).

One thing that might change slightly is the description of this flag:

           <entry>V4L2_DV_FL_DIVIDE_CLOCK_BY_1_001</entry>
           <entry>CEA-861 specific: only valid for video transmitters, the flag is cleared
  by receivers. It is also only valid for formats with the V4L2_DV_FL_NTSC_COMPATIBLE flag
  set, for other formats the flag will be cleared by the driver.

  If the application sets this flag, then the pixelclock used to set up the transmitter is
  divided by 1.001 to make it compatible with NTSC framerates. If the transmitter
  can't generate such frequencies, then the flag will also be cleared.
           </entry>

Currently it is only valid for transmitters, but I've seen newer receivers
that should be able to detect this small difference in pixelclock frequency.

I haven't tested (yet) whether they can actually do this, and it would have
to be considered a hint only since this minute pixelclock difference falls
within the CEA861-defined pixelclock variation. But if they can do this, then
that would be a really nice feature.

Basically I'm looking for a stamp of approval before I continue with this.

If you are OK with it, then I'll make a final version of this patch series,
and start adding this API to all drivers that currently use the preset API.
Once that's done we can deprecate and eventually remove the preset API.

But that's a fair amount of work and I don't want to start on that unless I
know you agree with this API.

Regards,

	Hans

> 
> The goal is that with these additions the existing DV_PRESET API can be
> removed eventually. It's always painful to admit, but that wasn't the best
> API ever :-)
> 
> To my dismay I discovered that some of the preset defines were even impossible:
> there are no interlaced 1920x1080i25/29.97/30 formats.
> 
> I have been testing this new code with the adv7604 HDMI receiver as used here:
> 
> http://git.linuxtv.org/hverkuil/cisco.git/shortlog/refs/heads/test-timings
> 
> This is my development/test branch, so the code is a bit messy.
> 
> One problem that I always had with the older proposals is that there was no
> easy way to just select a specific standard (e.g. 720p60). By creating the
> linux/v4l2-dv-timings.h header this is now very easy to do, both for drivers
> and applications.
> 
> I also took special care on how to distinguish between e.g. 720p60 and 720p59.94.
> See the documentation for more information.
> 
> Note that the QUERY_DV_TIMINGS and DV_TIMINGS_CAP ioctls will be marked
> experimental. Particularly the latter ioctl might well change in the future as
> I do not have enough experience to tell whether DV_TIMINGS_CAP is sufficiently
> detailed.
> 
> I would like to get some feedback on this approach, just to make sure I don't
> need to start over.
> 
> In the meantime I will be working on code to detect CVT and GTF video timings
> since that is needed to verify that that part works correctly as well.
> 
> And once everyone agrees to the API, then I will try and add this API to all
> drivers that currently use the preset API. That way there will be a decent
> path forward to eventually remove the preset API (sooner rather than later
> IMHO).
> 
> Regards,
> 
> 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
