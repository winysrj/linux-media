Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59140
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933938AbdDSLPv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 07:15:51 -0400
Date: Wed, 19 Apr 2017 08:15:45 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] Order the Makefile alphabetically
Message-ID: <20170419081538.38272ae6@vento.lan>
In-Reply-To: <20170406144051.13008-1-maxime.ripard@free-electrons.com>
References: <20170406144051.13008-1-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  6 Apr 2017 16:40:51 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> escreveu:

> The Makefiles were a free for all without a clear order defined. Sort all the
> options based on the Kconfig symbol.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> 
> ---
> 
> Hi Mauro,
> 
> Here is my makefile ordering patch again, this time with all the Makefiles
> in drivers/media that needed ordering.
> 
> Since we're already pretty late in the release period, I guess there won't
> be any major conflicts between now and the merge window.
> 

The thing with patches like that is that they almost never apply fine.
By the time I review such patches, it was already broken. Also,
once applied, it breaks for everybody that have pending work to merge.

This patch is broken (see attached).

So, I prefer not applying stuff like that.

Regards,
Mauro


testing if patches/lmml_40670_media_order_the_makefile_alphabetically.patch applies
patch -p1 -i patches/lmml_40670_media_order_the_makefile_alphabetically.patch --dry-run -t -N
checking file drivers/media/common/Makefile
checking file drivers/media/dvb-frontends/Makefile
checking file drivers/media/i2c/Makefile
Hunk #1 FAILED at 1.
1 out of 1 hunk FAILED
checking file drivers/media/pci/Makefile
checking file drivers/media/platform/Makefile
Hunk #1 FAILED at 1.
1 out of 1 hunk FAILED
checking file drivers/media/radio/Makefile
checking file drivers/media/rc/Makefile
checking file drivers/media/tuners/Makefile
checking file drivers/media/usb/Makefile
Hunk #1 FAILED at 6.
1 out of 1 hunk FAILED
checking file drivers/media/v4l2-core/Makefile
 drivers/media/common/Makefile        |    2 
 drivers/media/dvb-frontends/Makefile |  220 +++++++++++++++++------------------
 drivers/media/i2c/Makefile           |  162 ++++++++++++-------------
 drivers/media/pci/Makefile           |   34 ++---
 drivers/media/platform/Makefile      |   92 +++++---------
 drivers/media/radio/Makefile         |   62 ++++-----
 drivers/media/rc/Makefile            |   74 +++++------
 drivers/media/tuners/Makefile        |   73 +++++------
 drivers/media/usb/Makefile           |   34 ++---
 drivers/media/v4l2-core/Makefile     |   36 ++---
 10 files changed, 381 insertions(+), 408 deletions(-)

Thanks,
Mauro
