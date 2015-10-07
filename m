Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:36657 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbbJGVmL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Oct 2015 17:42:11 -0400
MIME-Version: 1.0
In-Reply-To: <201510080202.LaV6j8eq%fengguang.wu@intel.com>
References: <1444214376-26931-3-git-send-email-geert+renesas@glider.be>
	<201510080202.LaV6j8eq%fengguang.wu@intel.com>
Date: Wed, 7 Oct 2015 23:42:10 +0200
Message-ID: <CAMuHMdU0qjZe6OmZN3f9yUT1xnt3H3WeOTXgLBJC4-5514UKcA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] [media] rcar_vin: Remove obsolete platform data support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: kbuild test robot <lkp@intel.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
	"kbuild-all@01.org" <kbuild-all@01.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 7, 2015 at 8:32 PM, kbuild test robot <lkp@intel.com> wrote:
> [auto build test ERROR on v4.3-rc4 -- if it's inappropriate base, please ignore]
>
> config: arm-bockw_defconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm
>
> All errors (new ones prefixed by >>):
>
>>> arch/arm/mach-shmobile/board-bockw.c:24:45: fatal error: linux/platform_data/camera-rcar.h: No such file or directory
>     #include <linux/platform_data/camera-rcar.h>
>                                                 ^

Please ignore. Legacy (non-DT) bockw support has been removed in
arm-soc/for-next.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
