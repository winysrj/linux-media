Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:63297 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935573AbaDJL6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 07:58:06 -0400
Received: by mail-la0-f48.google.com with SMTP id gf5so2183846lab.21
        for <linux-media@vger.kernel.org>; Thu, 10 Apr 2014 04:58:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140410094850.GF26890@mwanda>
References: <20140410090234.GA8654@witts-MacBook-Pro.local> <20140410094850.GF26890@mwanda>
From: Vitaly Osipov <vitaly.osipov@gmail.com>
Date: Thu, 10 Apr 2014 21:57:23 +1000
Message-ID: <CAH42NiVQ8ng3DSZ63uUb=-yq+icO7oV=h2Ry3mpm8m2kGLPgjA@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: media: omap24xx: fix up a checkpatch.pl warning
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, that's helpful - I for some reason thought that multi-part
patch had to have more or less uniform subject. We the checkpatch.pl
people come from http://www.eudyptula-challenge.org/, where at some
stage we are told to submit a patch for a single style issue in the
staging tree. All newbies... Hoping to be back with more substantial
contributions soon.
Regards,
Vitaly


On Thu, Apr 10, 2014 at 7:48 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The two subjects are really close to being the same.  You should choose
> better subjects.  Like:
>
> [PATCH 2/2] staging: media: omap24xx: use pr_info() instead of KERN_INFO
>
>
> (All the checkpatch.pl people use the exact same subject for everything
> though, so you're not alone in this).
>
> regards,
> dan carpenter
>
