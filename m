Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40860 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758643Ab1JFPZo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 11:25:44 -0400
Received: by gyg10 with SMTP id 10so2684890gyg.19
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 08:25:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAwP0s1tK5XjmJmtvRFJ2+ADvoMP1ihf3z0UaJAfXOoJ=UrVqg@mail.gmail.com>
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
	<CAAwP0s0Z+EaRfY_9c0QLm0ZpyfG5Dy1qb9pFq=PRxzOOTwKTJw@mail.gmail.com>
	<CAAwP0s1tK5XjmJmtvRFJ2+ADvoMP1ihf3z0UaJAfXOoJ=UrVqg@mail.gmail.com>
Date: Thu, 6 Oct 2011 17:25:43 +0200
Message-ID: <CA+2YH7sdNxfeJvwMOq0zTVKJCQbsR6NekdjU1VW9sJPOUYw6tw@mail.gmail.com>
Subject: Re: omap3-isp status
From: Enrico <ebutera@users.berlios.de>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 6, 2011 at 9:51 AM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> Since the patches are not against mainline I can't post for reviewing
> but can be found in one of our development trees [1]. Comments are
> highly appreciated.
>
> The tree is a 2.6.37 that already contain Deepthy patch. I rebased my
> changes on top of that to correctly support both BT656 an non-BT656
> video data processing.
>
> [1]: http://git.igep.es/?p=pub/scm/linux-omap-2.6.git;a=shortlog;h=refs/heads/linux-2.6.37.y-next

Some random comments from a quick view at [1]:

- i don't see Deepthy patches, it seems to be based on the
pre-Deepthy-patches driver and fixed (not that this is a bad thing!);
i say this because, like Gary, i'm interested in a possible forward
porting to a more recent kernel so i was searching for a starting
point

- i don't think that adding the "priv" field in v4l2-mediabus.h will
be accepted, and since it is related to the default cropping you added
i think it can be dropped and just let the user choose the appropriate
cropping

- because of the previous point, i think the
PAL(NTSC)_NUM_ACTIVE_LINES can stay to 625(525)

- we really need some comments from someone that is not me, you and Gary

[1]: http://git.igep.es/?p=pub/scm/linux-omap-2.6.git;a=history;f=drivers/media/video/isp;hb=refs/heads/linux-2.6.37.y-next


>> Right now I have a working the tvp5151 with the ISP. I can capture
>> ITU-R BT656 video both in PAL-M and NTSC standard. Also, the whole
>> pipeline is configured automatically with the video standard detected
>> by the tvp5151. Also, I'm using the CCDC to crop the frames and only
>> capture the active lines for each standard (576 for PAL and 480 for
>> NTSC) using the CCDC to crop the image.
>>
>
> As I told you before video capturing is working for both PAL and NTSC
> using standard V4L2 application (i.e: gstreamer) but the video still
> shows some motion artifacts. Capturing YUV frames and looking at them
> I realized that there does exist a pattern, the sequence 2 frames
> correct and 3 frames with interlacing effects always repeats.

Yes i've seen that too, i was planning to do some tests when things
will settle down.

Enrico
