Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59262 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753858AbdGNK3k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 06:29:40 -0400
Date: Fri, 14 Jul 2017 12:29:35 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 00/14] gcc-7 warnings
Message-ID: <20170714102935.GB15467@kroah.com>
References: <20170714092540.1217397-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 11:25:12AM +0200, Arnd Bergmann wrote:
> This series should shut up all warnings introduced by gcc-6 or gcc-7 on
> today's linux-next, as observed in "allmodconfig" builds on x86,
> arm and arm64.
> 
> I have sent some of these before, but some others are new, as I had
> at some point disabled the -Wint-in-bool-context warning in my
> randconfig testing and did not notice the other warnings.
> 
> I have another series to address all -Wformat-overflow warnings,
> and one more patch to turn off the -Wformat-truncation warnings
> unless we build with "make W=1". I'll send that separately.
> 
> Most of these are consist of trivial refactoring of the code to
> shut up false-positive warnings, the one exception being
> "staging:iio:resolver:ad2s1210 fix negative IIO_ANGL_VEL read",
> which fixes a regression against linux-3.1 that has gone
> unnoticed since then. Still, review from subsystem maintainers
> would be appreciated.
> 
> I would suggest that Andrew Morton can pick these up into linux-mm
> so we can make sure they all make it into the release. Alternatively
> Linus might feel like picking them all up himself.
> 
> While I did not mark the harmless ones for stable backports,
> Greg may also want to pick them up once they go upstream, to
> help build-test the stable kernels with gcc-7.

Thanks for these, I'll keep an eye out for them to get into the stable
trees, so I can eventually update my test-build box to gcc-7.

thanks,

greg k-h
