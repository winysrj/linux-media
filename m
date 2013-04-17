Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36616 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966606Ab3DQPIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 11:08:48 -0400
Received: by mail-wi0-f177.google.com with SMTP id hj19so25697wib.16
        for <linux-media@vger.kernel.org>; Wed, 17 Apr 2013 08:08:46 -0700 (PDT)
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Compilation breakage on drivers/media due to OF patches - was: Re: [PATCH] DT: export of_get_next_parent() for use by modules: fix modular V4L2
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Rob Herring <rob.herring@calxeda.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>,
	devicetree-discuss@lists.ozlabs.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
In-Reply-To: <20130417115357.0b0f31ae@redhat.com>
References: <Pine.LNX.4.64.1304021825130.31999@axis700.grange> <201304021630.13371.arnd@arndb.de> <Pine.LNX.4.64.1304021840590.31999@axis700.grange> <Pine.LNX.4.64.1304171555140.16330@axis700.grange> <20130417115357.0b0f31ae@redhat.com>
Date: Wed, 17 Apr 2013 16:08:43 +0100
Message-Id: <20130417150843.5A5A63E2B73@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 17 Apr 2013 11:53:57 -0300, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Hi Grant/Rob,
> 
> Our tree is currently _broken_ with OT, because of the lack of 
> exporting of_get_next_parent. The developer that submitted the patches 
> that added V4L2 OF support forgot to test to compilation with MODULES
> support enabled.
> 
> So, we're now having:
> 	ERROR: "of_get_next_parent" [drivers/media/v4l2-core/videodev.ko] undefined!
> 
> if compiled with OF enabled and media as module.
> 
> As those patches were applied at my master branch and there are lots of
> other patches on the top of the patches that added V4L2 OF support, 
> I prefer to avoid reverting those patches. 
> 
> On the other hand, I can't send the patches upstream next week (assuming 
> that -rc7 is the final one), without having this patch applying before 
> the media tree.

The fix needs to be applied to your tree then. Go ahead and apply it with my ack:

Acked-by: Grant Likely <grant.likely@linaro.org>

It is no good to apply it to the devicetree -next branch because that
will still leave your branch broken, even if device tree gets merged
first.

g.
