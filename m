Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:37574 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753758AbdCTMbk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 08:31:40 -0400
Date: Mon, 20 Mar 2017 12:31:50 +0000
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "kernelci.org bot" <bot@kernelci.org>,
        kernel-build-reports@lists.linaro.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <james.hogan@imgtec.com>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: mainline build: 208 builds: 0 failed, 208 passed, 422 warnings
 (v4.11-rc2-164-gdefc7d752265)
Message-ID: <20170320123150.GJ17263@arm.com>
References: <58c97f8f.c4b5190a.8c4e4.300d@mx.google.com>
 <CAK8P3a1jHhM=80Zo59JoDNd2RKwTfdR_i61_=ASqqUeJ1oecxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1jHhM=80Zo59JoDNd2RKwTfdR_i61_=ASqqUeJ1oecxg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 15, 2017 at 09:02:06PM +0100, Arnd Bergmann wrote:
> On Wed, Mar 15, 2017 at 6:53 PM, kernelci.org bot <bot@kernelci.org> wrote:
> >
> > mainline build: 208 builds: 0 failed, 208 passed, 422 warnings (v4.11-rc2-164-gdefc7d752265)
> 
> The last build failure in mainline is gone now, though I don't know
> what fixed it.
> Let's hope this doesn't come back as the cause was apparently a race condition
> in Kbuild that might have stopped triggering.
> 
> > Warnings summary:
> > 409 :1325:2: warning: #warning syscall statx not implemented [-Wcpp]
> 
> The warning triggers for arm, arm64 and mips on every build. I saw a patch
> was posted for asm-generic, which takes care of arm64.
> 
> Catalin and Will: can you take this through the arm64 tree? I don't have
> anything else for asm-generic at the moment.

Yes, I'll pick that up.

Will
