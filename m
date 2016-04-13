Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36048 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030279AbcDMJgy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 05:36:54 -0400
Date: Wed, 13 Apr 2016 10:36:51 +0100
From: Sean Young <sean@mess.org>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] rc: Remove init_ir_raw_event and
 DEFINE_IR_RAW_EVENT
Message-ID: <20160413093651.GA9875@gofer.mess.org>
References: <1460464072-2245-1-git-send-email-sean@mess.org>
 <201604131446.hEjbhLyL%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201604131446.hEjbhLyL%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 13, 2016 at 02:07:49PM +0800, kbuild test robot wrote:
> Hi Sean,
> 
> [auto build test ERROR on linuxtv-media/master]
> [also build test ERROR on v4.6-rc3 next-20160412]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Sean-Young/rc-Remove-init_ir_raw_event-and-DEFINE_IR_RAW_EVENT/20160412-203118
> base:   git://linuxtv.org/media_tree.git master
> config: openrisc-allmodconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=openrisc 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/media/i2c/cx25840/cx25840-ir.c: In function 'cx25840_ir_rx_read':
> >> drivers/media/i2c/cx25840/cx25840-ir.c:710:4: error: unknown field 'duration' specified in initializer
> --
>    drivers/media/rc/streamzap.c: In function 'streamzap_callback':
> >> drivers/media/rc/streamzap.c:258:6: error: unknown field 'duration' specified in initializer
> 
> vim +/duration +710 drivers/media/i2c/cx25840/cx25840-ir.c
> 
>    704			v = (unsigned) pulse_width_count_to_ns(
>    705					  (u16) (p->hw_fifo_data & FIFO_RXTX), divider);
>    706			if (v > IR_MAX_DURATION)
>    707				v = IR_MAX_DURATION;
>    708	
>    709			p->ir_core_data = (struct ir_raw_event)
>  > 710				{ .pulse = u, .duration = v, .timeout = w };

Looks like gcc 4.5.1 does not handle anonymous union initializers properly.

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=10676

I don't think this patch can be reworked without it.

Thanks,

Sean
