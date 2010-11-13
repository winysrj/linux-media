Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:56565 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab0KMRey (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 12:34:54 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] SoC Camera: ov6650: minor cleanups
Date: Sat, 13 Nov 2010 18:34:08 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201011021714.37544.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1011082219580.29934@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1011082219580.29934@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011131834.10133.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Monday 08 November 2010 22:20:33 Guennadi Liakhovetski wrote:
> On Tue, 2 Nov 2010, Janusz Krzysztofik wrote:
> > This is a followup patch that addresses two minor issues left in the
> > recently added ov6650 sensor driver, as I've promised to the subsystem
> > maintainer:
> > - remove a pair of extra brackets, 
> > - drop useless case for not possible v4l2_mbus_pixelcode enum value of 0.
> >
> > Created against linux-2.6.37-rc1.
> >
> > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
>
> Applied together with other your 3 patches and pushed for 2.6.37-rc2.

Hi Guennadi,
Thanks for taking my fixes.

Thursday 30 September 2010 13:35:49 Janusz Krzysztofik wrote:
> There are still two SG mode specific corner cases to be corrected,
> previously not detected because of poor sensor driver functionality: 1)
> frame size not exceeding one page, resulting in "unexpected end of frame"
> message and capture restart every frame, and 2) last sgbuf lenght less than
> bytes_per_line, resulting in unstable picture. I'm going to address those
> two with fixes.

Since both issues don't affect typical usage (one of standard resolutions) and 
both are videobuf-sg related, I'm wondering if I should better wait for 
videobuf2 and try to port my driver instead of making things still more 
complicated than they already are. What do you think?

Thanks,
Janusz
