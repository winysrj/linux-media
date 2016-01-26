Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35450 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934100AbcAZRGG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 12:06:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eduard Gavin <egavinc@gmail.com>
Subject: Re: [PATCH] tvp5150: Fix breakage for serial usage
Date: Tue, 26 Jan 2016 19:06:22 +0200
Message-ID: <1906458.x8tqLB8j7k@avalon>
In-Reply-To: <20160126070955.3dcef1d4@recife.lan>
References: <54ffe2ae9209b607f54142809902764e2eaaf1d2.1453740290.git.mchehab@osg.samsung.com> <20160125180121.5bc5bf75@recife.lan> <20160126070955.3dcef1d4@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 26 January 2016 07:09:55 Mauro Carvalho Chehab wrote:
> Em Mon, 25 Jan 2016 18:01:21 -0200 Mauro Carvalho Chehab escreveu:
> > Em Mon, 25 Jan 2016 21:32:21 +0200 Laurent Pinchart escreveu:
> > > Hi Mauro,
> > > 
> > > Let's see, I can't test em28xx, could you try remove the CONF_SHARED_PIN
> > > change and replacing the write in s_stream with a read-modify-write that
> > > disables the output (bits 3, 2 and 0) ? If that works I'll test it with
> > > the omap3 isp when I'll be back home.
> > 
> > Didn't work. I'll  do more tests later (or tomorrow).
> 
> The root cause weren't at tvp5150 side, but, instead, at em28xx that
> were only calling s_stream() to disable the stream, but never enabling it.
> 
> I'm wander why it was doing such thing. Well, s_stream() came years
> after the em28xx driver, so I suspect it was a hack to fix some issue
> with a particular device. Let's hope that the change won't cause any
> regressions on such hardware.

Let's blame history :-)

> The good news is that em28xx doesn't need MISC_CTL to be filled with
> 0x6f to stream. Just 0x09 is enough. So, the same initialization
> needed by OMAP3 will work there.
> 
> I'm posting the patch in a few.

Great, thanks.

-- 
Regards,

Laurent Pinchart

