Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33715 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752102AbdC1Ukh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 16:40:37 -0400
MIME-Version: 1.0
In-Reply-To: <201703290457.BJ1KohSr%fengguang.wu@intel.com>
References: <20170328100321.3836826-1-arnd@arndb.de> <201703290457.BJ1KohSr%fengguang.wu@intel.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 28 Mar 2017 22:40:35 +0200
Message-ID: <CAK8P3a3DMR4kJ2g7VEwdM7mfg5BjwGhJz9XSTVQjjSWSH9R7RA@mail.gmail.com>
Subject: Re: [PATCH] staging: atomisp: avoid false-positive
 maybe-uninitialized warning
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, devel@driverdev.osuosl.org,
        Varsha Rao <rvarsha016@gmail.com>,
        sayli karnik <karniksayli1995@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 28, 2017 at 10:10 PM, kbuild test robot <lkp@intel.com> wrote:
> Hi Arnd,
>
> [auto build test ERROR on staging/staging-testing]
> [also build test ERROR on next-20170328]
> [cannot apply to linuxtv-media/master v4.11-rc4]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Arnd-Bergmann/staging-atomisp-avoid-false-positive-maybe-uninitialized-warning/20170329-023715
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> All errors (new ones prefixed by >>):
>
>    drivers/staging/media/atomisp/i2c/mt9m114.c: In function 'mt9m114_get_fmt':
>>> drivers/staging/media/atomisp/i2c/mt9m114.c:818:25: error: unused variable 'dev' [-Werror=unused-variable]
>      struct mt9m114_device *dev = to_mt9m114_sensor(sd);
>                             ^~~
>    drivers/staging/media/atomisp/i2c/mt9m114.c: In function 'mt9m114_s_exposure_selection':
>    drivers/staging/media/atomisp/i2c/mt9m114.c:1179:25: error: unused variable 'dev' [-Werror=unused-variable]
>      struct mt9m114_device *dev = to_mt9m114_sensor(sd);
>                             ^~~
>    cc1: all warnings being treated as errors
>

Very odd, I should obviouly have run into these when verifying my patch.
I guess

I'm preparing an v2 patch and will send that once I've built some more
randconfigs on top of recreating the bug and fix.

     Arnd
