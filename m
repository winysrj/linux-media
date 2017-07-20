Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37087
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934348AbdGTKtq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 06:49:46 -0400
Date: Thu, 20 Jul 2017 07:49:36 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Soeren Moch <smoch@web.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Regel <andreas.regel@gmx.de>,
        Manu Abraham <manu@linuxtv.org>,
        Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL] SAA716x DVB driver
Message-ID: <20170720074936.1a89f304@vento.lan>
In-Reply-To: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Soeren,

Em Sun, 16 Jul 2017 20:34:23 +0200
Soeren Moch <smoch@web.de> escreveu:

> This is a driver for DVB cards based on the SAA7160/62 PCIe bridges from
> Philips/NXP. The most important of these cards, at least for me, is the
> TechnoTrend S2-6400, a high-definition full-featured DVB-S2 card, the
> successor of the famous ttpci decoder cards. Other supported cards are:
> Avermedia H788
> Avermedia HC82 Express-54
> KNC One Dual S2
> KWorld DVB-T PE310
> Technisat SkyStar 2 eXpress HD
> Twinhan/Azurewave VP-1028
> Twinhan/Azurewave VP-3071
> Twinhan/Azurewave VP-6002
> Twinhan/Azurewave VP-6090
> 
> The driver is taken from [1] with adaptations for current mainline,
> converted to git and moved to drivers/staging/media. See TODO for
> required cleanups (from my point of view, maybe more to come from
> additional code review by other developers). I added myself as driver
> maintainer to document my commitment to further development to get this
> out of staging, help from others welcome.
> 
> This driver was licensed "GPL" from the beginning. S2-6400 firmware is
> available at [2].
> 
> I want to preserve the development history of the driver, since this
> is mainly work of Andreas Regel, Manu Abraham, and Oliver Endriss.
> Unfortunately Andreas seems not to take care of this driver anymore, he
> also did not answer my requests to integrate patches for newer kernel
> versions. So I send this upstream.
> 
> With all the history this is a 280 part patch series, so I send this as
> pull request. Of course I can also send this as 'git send-email' series
> if desired.

Even on staging, reviewing a 280 patch series take a while ;)

As the patches that make it build with current upstream are at the
end of the series, you need to be sure that the saa716x Makefile
won't be included until those fixes get applied. It seems you took
care of it already, with is good!


The hole idea of adding a driver to staging is that it will be moved
some day out of staging. That's why a TODO and an entry at MAINTAINERS
is required.

By looking at the saa716x_ff_main:

	https://github.com/s-moch/linux-saa716x/blob/for-media/drivers/staging/media/saa716x/saa716x_ff_main.c

I'm seeing that the main problem of this driver is that it still use
the API from the legacy ttpci driver, e. g. DVB audio, video and osd APIs.

Those APIs were deprecated because they duplicate a functionality
provided by the V4L2 API, and are obscure, because they're not
properly documented. Also, no other driver uses it upstream.

So, it was agreed several years ago that new full featured drivers
should use the V4L2 API for audio/video codecs.

We have a some drivers that use V4L2 for MPEG audio/video decoding
and encoding. The best examples are ivtv and cx18 (as both are for
PCI devices). Currently, none of those drivers support the DVB
API, though, as they're used only on analog TV devices.

It was also agreed that setup pipelines on more complex DVB
devices should use the media controller API (MC API).

Yet, we don't have, currently, any full featured drivers upstream
(except for the legacy one).

So, if we're willing to apply this driver, you should be committed
to do implement the media APIs properly, porting from DVB
audio/video/osd to V4L2 and MC APIs.

That should also reflect its TODO:

	https://github.com/s-moch/linux-saa716x/blob/for-media/drivers/staging/media/saa716x/TODO

Regards,
Mauro
