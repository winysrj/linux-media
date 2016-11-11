Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36677 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750714AbcKKOFr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 09:05:47 -0500
Date: Fri, 11 Nov 2016 14:05:44 +0000
From: Sean Young <sean@mess.org>
To: kbuild test robot <lkp@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/2] serial_ir: use precision ktime rather than
 guessing
Message-ID: <20161111140544.GA19212@gofer.mess.org>
References: <1478805946-11546-2-git-send-email-sean@mess.org>
 <201611111102.O3LKEmHQ%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201611111102.O3LKEmHQ%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 11, 2016 at 11:49:38AM +0800, kbuild test robot wrote:
> Hi Sean,
> 
> [auto build test ERROR on linuxtv-media/master]
> [also build test ERROR on next-20161110]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Sean-Young/serial_ir-port-lirc_serial-to-rc-core/20161111-033554
> base:   git://linuxtv.org/media_tree.git master
> config: m68k-allmodconfig (attached as .config)
> compiler: m68k-linux-gcc (GCC) 4.9.0
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=m68k 
> 
> All errors (new ones prefixed by >>):
> 
> >> ERROR: "__divdi3" [drivers/media/rc/serial_ir.ko] undefined!

Apparently calling ndelay() with 64 bit type causes this on m68k. We don't
need it that wide so I'll down cast it to 32 bit. Expect a v3 later today
or tomorrow.

Thanks
Sean
