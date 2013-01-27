Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781Ab3A0N5g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 08:57:36 -0500
Date: Sun, 27 Jan 2013 11:57:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: partial revert of "uvcvideo: set error_idx properly"
Message-ID: <20130127115734.06b02554@redhat.com>
In-Reply-To: <201301251442.59974.hverkuil@xs4all.nl>
References: <CAKbGBLiOuyUUHd+eEm+z=THEu57b2LSDFtoN9frXASZ5BG7Huw@mail.gmail.com>
	<201301251140.13707.hverkuil@xs4all.nl>
	<51028B5D.8080607@redhat.com>
	<201301251442.59974.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 25 Jan 2013 14:42:59 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Fri January 25 2013 14:40:45 Hans de Goede wrote:
> > Hi,
> > 
> > On 01/25/2013 11:40 AM, Hans Verkuil wrote:
> > 
> > <snip>
> > 
> > >> What I did notice is that pwc_vidioc_try_fmt returns EINVAL when
> > >> an unsupported pixelformat is requested. IIRC we agreed that the
> > >> correct behavior in this case is to instead just change the
> > >> pixelformat to a default format, so I'll write a patch fixing
> > >> this.
> > >
> > > There are issues with that idea in the case of TV capture cards, since
> > > some important apps (tvtime and mythtv to a lesser extent) assume -EINVAL
> > > in the case of unsupported pixelformats.
> > 
> > Oh, I thought we agreed on never returning EINVAL accept for on invalid
> > buffer types in Barcelona ?
> 
> We did, but then it was discovered that apps like tvtime *rely* on such an
> error code.

Yes. Basically, tvtime and MythTV rely on receiving an error when the format
is not supported (I think they accept if the driver changes resolution and
interleaving mode, though). Xawtv (and likely the other apps that use its
code as a reference) will accept if the driver would change the video format
to one that it is actually supported.

> 
> All TV capture drivers that do stream I/O return EINVAL for unsupported
> formats today. There are exceptions (cx18/ivtv/pvrusb2 (?)), but those
> have a read() API only.
> 
> Very annoying...
> 
> Regards,
> 
> 	Hans


-- 

Cheers,
Mauro
