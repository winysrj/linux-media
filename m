Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:59268 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2D1ViB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 17:38:01 -0400
Date: Sat, 28 Apr 2012 23:37:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: video capture driver interlacing question (easycap)
In-Reply-To: <CALF0-+Xz8RkGkjSg8n45POLQKWpFUhsNQCPpth4NK9Svhc+4SA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1204282336140.7312@axis700.grange>
References: <CALF0-+WaMObsjmpqF8akQwaizETsS2zg05yT5fcOTA5CT=wLJA@mail.gmail.com>
 <CALF0-+Xz8RkGkjSg8n45POLQKWpFUhsNQCPpth4NK9Svhc+4SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel

On Sat, 28 Apr 2012, Ezequiel García wrote:

> On Thu, Apr 26, 2012 at 5:33 PM, Ezequiel García <elezegarcia@gmail.com> wrote:
> > Hi everyone,
> >
> > As you may know I'm re-writing from scratch the staging/easycap driver.
> >
> > Finally, after digging through the labyrinthic staging/easycap code,
> > I've reached a point where I'm able to understand isoc packets.
> > Despite not having any documentation (I asked several times) from chip vendor,
> > I can separate packets in odd and even.
> >
> > So, instead of receiving frames the device is sending me fields, right?
> >
> > My doubt now is this:
> > * Do I have to *merge* this pair of fields for each frame, or can I
> > give it to v4l?
> > If affirmative: how should I *merge* them?
> > * Is this related to multiplanar buffers (should I use vb2_plane_addr)?
> >
> > Currently, staging/easycap does some strange and complex conversion,
> > from the pair of fields buffers, to get a "frame" buffer (!) but I'm
> > not sure if it's the correct way to do it?
> >
> > I guess I can keep staring at em28xx (together with vivi/uvc/pwc) driver,
> > but if someone cares to give me a small hint or point me at a small portion
> > of code I'll be grateful.
> >
> > Thanks,
> > Ezequiel.
> 
> Anyone?

This might help:

http://linuxtv.org/downloads/v4l-dvb-apis/field-order.html

i.e., no, you should not merge fields in the driver, IIRC, you just hand 
them over to the user in separate buffers.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
