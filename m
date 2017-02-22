Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:38981 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754306AbdBVKpF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 05:45:05 -0500
Date: Wed, 22 Feb 2017 10:45:03 +0000
From: Sean Young <sean@mess.org>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 17/19] [media] lirc: implement reading scancode
Message-ID: <20170222104503.GA11020@gofer.mess.org>
References: <af0fc6e2fbbbb5f6c54905b18d6e78f04eadb4f9.1487709384.git.sean@mess.org>
 <201702220813.YFEbz0HM%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201702220813.YFEbz0HM%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 22, 2017 at 08:14:50AM +0800, kbuild test robot wrote:
> Hi Sean,
> 
> [auto build test ERROR on linuxtv-media/master]
> [also build test ERROR on next-20170221]
> [cannot apply to v4.10]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Sean-Young/Teach-lirc-how-to-send-and-receive-scancodes/20170222-073718
> base:   git://linuxtv.org/media_tree.git master
> config: i386-randconfig-x015-201708 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> Note: the linux-review/Sean-Young/Teach-lirc-how-to-send-and-receive-scancodes/20170222-073718 HEAD 9a4d3444d507190ad7996731c8c7e4ef80979de4 builds fine.
>       It only hurts bisectibility.
> 
> All error/warnings (new ones prefixed by >>):
> 
>    drivers/media/rc/ir-lirc-codec.c: In function 'ir_lirc_poll':
> >> drivers/media/rc/ir-lirc-codec.c:393:7: error: 'drv' undeclared (first use in this function)
>      if (!drv->attached) {

Oops, too much rebasing without testing. :( The final commit compiles fine,
I'll have to do some better testing of each commit and resend.


Sean
