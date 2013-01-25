Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4011 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab3AYNnR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 08:43:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: partial revert of "uvcvideo: set error_idx properly"
Date: Fri, 25 Jan 2013 14:42:59 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <CAKbGBLiOuyUUHd+eEm+z=THEu57b2LSDFtoN9frXASZ5BG7Huw@mail.gmail.com> <201301251140.13707.hverkuil@xs4all.nl> <51028B5D.8080607@redhat.com>
In-Reply-To: <51028B5D.8080607@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301251442.59974.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri January 25 2013 14:40:45 Hans de Goede wrote:
> Hi,
> 
> On 01/25/2013 11:40 AM, Hans Verkuil wrote:
> 
> <snip>
> 
> >> What I did notice is that pwc_vidioc_try_fmt returns EINVAL when
> >> an unsupported pixelformat is requested. IIRC we agreed that the
> >> correct behavior in this case is to instead just change the
> >> pixelformat to a default format, so I'll write a patch fixing
> >> this.
> >
> > There are issues with that idea in the case of TV capture cards, since
> > some important apps (tvtime and mythtv to a lesser extent) assume -EINVAL
> > in the case of unsupported pixelformats.
> 
> Oh, I thought we agreed on never returning EINVAL accept for on invalid
> buffer types in Barcelona ?

We did, but then it was discovered that apps like tvtime *rely* on such an
error code.

All TV capture drivers that do stream I/O return EINVAL for unsupported
formats today. There are exceptions (cx18/ivtv/pvrusb2 (?)), but those
have a read() API only.

Very annoying...

Regards,

	Hans
