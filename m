Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36360
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751586AbdFXUPP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 16:15:15 -0400
Date: Sat, 24 Jun 2017 17:15:07 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND 0/7] Introduce MEDIA_VERSION to end
 KENREL_VERSION abuse in media
Message-ID: <20170624171507.38353b10@vento.lan>
In-Reply-To: <20170621080812.6817-1-jthumshirn@suse.de>
References: <20170621080812.6817-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 21 Jun 2017 10:08:05 +0200
Johannes Thumshirn <jthumshirn@suse.de> escreveu:

> Currently the media subsystem has a very creative abuse of the
> KERNEL_VERSION macro to encode an arbitrary version triplet for media
> drivers and device hardware revisions.
> 
> This series introduces a new macro called MEDIA_REVISION which encodes
> a version triplet like KERNEL_VERSION does, but clearly has media
> centric semantics and doesn't fool someone into thinking specific
> parts are defined for a specific kernel version only like in out of
> tree drivers.

Sorry, but I can't see any advantage on it. On the downside, it
includes the media controller header file (media.h) where it
is not needed.

> 
> Johannes Thumshirn (7):
>   [media] media: introduce MEDIA_REVISION macro
>   video: fbdev: don't use KERNEL_VERSION macro for MEDIA_REVISION
>   [media] media: document the use of MEDIA_REVISION instead of
>     KERNEL_VERSION
>   [media] cx25821: use MEDIA_REVISION instead of KERNEL_VERSION
>   [media] media: s3c-camif: Use MEDIA_REVISON instead of KERNEL_VERSION
>   [media] media: bcm2048: use MEDIA_REVISION isntead of KERNEL_VERSION
>   staging/atomisp: use MEDIA_VERSION instead of KERNEL_VERSION

That's said, some of the above shouldn't be using KERNEL_VERSION
at all. The V4L2 core sets the version already. So, drivers like
cx25821, s3c-camif, bcm2048 and atomisp are likely doing the wrong
thing.

Thanks,
Mauro
