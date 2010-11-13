Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:34980 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755373Ab0KMVMS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 16:12:18 -0500
Date: Sat, 13 Nov 2010 22:12:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] SoC Camera: ov6650: minor cleanups
In-Reply-To: <201011131834.10133.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1011132132500.16281@axis700.grange>
References: <201011021714.37544.jkrzyszt@tis.icnet.pl>
 <Pine.LNX.4.64.1011082219580.29934@axis700.grange> <201011131834.10133.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 13 Nov 2010, Janusz Krzysztofik wrote:

> Thursday 30 September 2010 13:35:49 Janusz Krzysztofik wrote:
> > There are still two SG mode specific corner cases to be corrected,
> > previously not detected because of poor sensor driver functionality: 1)
> > frame size not exceeding one page, resulting in "unexpected end of frame"
> > message and capture restart every frame, and 2) last sgbuf lenght less than
> > bytes_per_line, resulting in unstable picture. I'm going to address those
> > two with fixes.
> 
> Since both issues don't affect typical usage (one of standard resolutions) and 
> both are videobuf-sg related, I'm wondering if I should better wait for 
> videobuf2 and try to port my driver instead of making things still more 
> complicated than they already are. What do you think?

Well, I _would_ say: restrict the driver to avoid those corner cases. 
I.e., add a test to omap1_cam_set_fmt() and / or omap1_cam_set_crop() in 
SG case to verify, that the frame is at least one page large and that the 
lasg sgbuf is large enough. If this is not the case adjust the frame to 
satisfy these restrictions. But the problem is - at S_FMT / S_CROP time 
you don't know yet, whether you're going to use SG.

I haven't studied videobuf2 in enough detail to understand, why and how 
it would help you? Isn't this a principal problem with your SG 
implementation? Maybe we should take this as yet one more argument against 
your "emulated sg" mode and remove it completely from the driver, relying 
on contiguous video buffers, selecting and implementing some boot-time 
memory reservation, and, possibly, adding the omap1 camera driver to the 
list of other drivers, waiting to break down again with 2.6.37, unless the 
"conflicting mapping mode" problem on ARM gets resolved before then?

Also, please, move use_sg inside struct omap1_cam_dev.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
