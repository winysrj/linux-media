Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4367 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1BZMMv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 07:12:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
Date: Sat, 26 Feb 2011 13:12:42 +0100
Cc: Edward Hervey <bilboed@gmail.com>, johan.mossberg.lml@gmail.com,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	"ST-Ericsson LT Mailing List" <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com> <1298578789.821.54.camel@deumeu> <AANLkTi=Twg-hzngyrpU_=o1yxQ3qVtiJf-Qhj--OubPu@mail.gmail.com>
In-Reply-To: <AANLkTi=Twg-hzngyrpU_=o1yxQ3qVtiJf-Qhj--OubPu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102261312.43125.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, February 25, 2011 18:22:51 Linus Walleij wrote:
> 2011/2/24 Edward Hervey <bilboed@gmail.com>:
> 
> >  What *needs* to be solved is an API for data allocation/passing at the
> > kernel level which v4l2,omx,X,GL,vdpau,vaapi,... can use and that
> > userspace (like GStreamer) can pass around, monitor and know about.
> 
> I think the patches sent out from ST-Ericsson's Johan Mossberg to
> linux-mm for "HWMEM" (hardware memory) deals exactly with buffer
> passing, pinning of buffers and so on. The CMA (Contigous Memory
> Allocator) has been slightly modified to fit hand-in-glove with HWMEM,
> so CMA provides buffers, HWMEM pass them around.
> 
> Johan, when you re-spin the HWMEM patchset, can you include
> linaro-dev and linux-media in the CC?

Yes, please. This sounds promising and we at linux-media would very much like
to take a look at this. I hope that the CMA + HWMEM combination is exactly
what we need.

Regards,

	Hans

> I think there is *much* interest
> in this mechanism, people just don't know from the name what it
> really does. Maybe it should be called mediamem or something
> instead...
> 
> Yours,
> Linus Walleij
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
