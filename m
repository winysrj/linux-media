Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:35318 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753901AbdCOUMG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 16:12:06 -0400
MIME-Version: 1.0
In-Reply-To: <58c97f8f.c4b5190a.8c4e4.300d@mx.google.com>
References: <58c97f8f.c4b5190a.8c4e4.300d@mx.google.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 15 Mar 2017 21:02:06 +0100
Message-ID: <CAK8P3a1jHhM=80Zo59JoDNd2RKwTfdR_i61_=ASqqUeJ1oecxg@mail.gmail.com>
Subject: Re: mainline build: 208 builds: 0 failed, 208 passed, 422 warnings (v4.11-rc2-164-gdefc7d752265)
To: "kernelci.org bot" <bot@kernelci.org>
Cc: kernel-build-reports@lists.linaro.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <james.hogan@imgtec.com>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 15, 2017 at 6:53 PM, kernelci.org bot <bot@kernelci.org> wrote:
>
> mainline build: 208 builds: 0 failed, 208 passed, 422 warnings (v4.11-rc2-164-gdefc7d752265)

The last build failure in mainline is gone now, though I don't know
what fixed it.
Let's hope this doesn't come back as the cause was apparently a race condition
in Kbuild that might have stopped triggering.

> Warnings summary:
> 409 :1325:2: warning: #warning syscall statx not implemented [-Wcpp]

The warning triggers for arm, arm64 and mips on every build. I saw a patch
was posted for asm-generic, which takes care of arm64.

Catalin and Will: can you take this through the arm64 tree? I don't have
anything else for asm-generic at the moment.

Russell and Ralf, do you already have patches for ARM and MIPS to
add the syscalls, or would you like me to send you patches for it?
I assume all arch maintainers will get to it eventually, but I'd like to
see this gone from the kernelci reporting.

Once the syscall number has been assigned for arch/arm, we will
also need to update the compat syscall table for arm64 of course.

> 2 include/linux/device.h:1479:15: warning: passing argument 1 of 'platform_driver_unregister' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
> 2 include/linux/device.h:1474:20: warning: passing argument 1 of '__platform_driver_register' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]

Mauro has applied the fix in linux-next, I assume this is going to hit mainline
before v4.11-rc3.

> 1 net/wireless/nl80211.c:5743:1: warning: the frame size of 2064 bytes is larger than 2048 bytes [-Wframe-larger-than=]
> 1 net/bridge/br_netlink.c:1339:1: warning: the frame size of 2544 bytes is larger than 2048 bytes [-Wframe-larger-than=]
> 1 drivers/tty/vt/keyboard.c:1472:1: warning: the frame size of 2344 bytes is larger than 2048 bytes [-Wframe-larger-than=]

I still have this one on my list, should be able to post an updated version
in a few days after I'm through with my backlog of older patches.

      Arnd
