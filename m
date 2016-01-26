Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57429 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbcAZJJ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 04:09:59 -0500
Date: Tue, 26 Jan 2016 07:09:55 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eduard Gavin <egavinc@gmail.com>
Subject: Re: [PATCH] tvp5150: Fix breakage for serial usage
Message-ID: <20160126070955.3dcef1d4@recife.lan>
In-Reply-To: <20160125180121.5bc5bf75@recife.lan>
References: <54ffe2ae9209b607f54142809902764e2eaaf1d2.1453740290.git.mchehab@osg.samsung.com>
	<1496492.fG104z7bmU@avalon>
	<20160125170721.01dcf4dc@recife.lan>
	<2963199.ud5niVsfSC@avalon>
	<20160125180121.5bc5bf75@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Jan 2016 18:01:21 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Mon, 25 Jan 2016 21:32:21 +0200
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
> > Hi Mauro,  
> 
> > Let's see, I can't test em28xx, could you try remove the CONF_SHARED_PIN 
> > change and replacing the write in s_stream with a read-modify-write that 
> > disables the output (bits 3, 2 and 0) ? If that works I'll test it with the 
> > omap3 isp when I'll be back home.  
> 
> Didn't work. I'll  do more tests later (or tomorrow).

The root cause weren't at tvp5150 side, but, instead, at em28xx that
were only calling s_stream() to disable the stream, but never enabling it.

I'm wander why it was doing such thing. Well, s_stream() came years
after the em28xx driver, so I suspect it was a hack to fix some issue
with a particular device. Let's hope that the change won't cause any
regressions on such hardware.

The good news is that em28xx doesn't need MISC_CTL to be filled with
0x6f to stream. Just 0x09 is enough. So, the same initialization
needed by OMAP3 will work there.

I'm posting the patch in a few.

> 
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
