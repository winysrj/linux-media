Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:54955 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933391AbcKJOYi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 09:24:38 -0500
Date: Thu, 10 Nov 2016 14:24:32 +0000
From: Sean Young <sean@mess.org>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] serial_ir: port lirc_serial to rc-core
Message-ID: <20161110142432.GA7376@gofer.mess.org>
References: <1478108285-12046-1-git-send-email-sean@mess.org>
 <201611030352.kXJ0FvOv%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201611030352.kXJ0FvOv%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 03, 2016 at 03:39:31AM +0800, kbuild test robot wrote:
> Hi Sean,
> 
> [auto build test WARNING on linuxtv-media/master]
> [also build test WARNING on v4.9-rc3 next-20161028]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> [Suggest to use git(>=2.9.0) format-patch --base=<commit> (or --base=auto for convenience) to record what (public, well-known) commit your patch series was built on]
> [Check https://git-scm.com/docs/git-format-patch for more information]
> 
> url:    https://github.com/0day-ci/linux/commits/Sean-Young/serial_ir-port-lirc_serial-to-rc-core/20161103-014155
> base:   git://linuxtv.org/media_tree.git master
> config: parisc-allyesconfig (attached as .config)
> compiler: hppa-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=parisc 
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/media/rc/serial_ir.c: In function 'serial_ir_irq_handler':
> >> drivers/media/rc/serial_ir.c:592:1: warning: the frame size of 1196 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Since ktime_t is in nanoseconds, ktime_to_us() does a 64 bit division by 1000
which quite some instructions/stack space on 32 bit parisc. Since the 
ktime_to_us() is just for a printk() it can simply report in nanoseconds
(so use ktime_to_ns() instead). The resulting machine code on parisc 32 bit
is much shorter and the warning goes away.

I'll send out a new version of this patch shortly. Please ignore this
version.

Thanks,

Sean
