Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34445 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751827AbdEPHlv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 03:41:51 -0400
Date: Tue, 16 May 2017 08:41:44 +0100
From: Sean Young <sean@mess.org>
To: kernel test robot <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        wfg@linux.intel.com
Subject: Re: [[media] rc] e662671619: BUG: kernel hang in test stage
Message-ID: <20170516074143.GA8691@gofer.mess.org>
References: <591060f1.yq3IrK0+vZ5287bb%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <591060f1.yq3IrK0+vZ5287bb%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 08, 2017 at 08:13:37PM +0800, kernel test robot wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> 
> commit e66267161971155a8b4756b4e17f2f2f82b9f842
> Author:     Sean Young <sean@mess.org>
> AuthorDate: Tue Mar 7 17:07:59 2017 -0300
> Commit:     Mauro Carvalho Chehab <mchehab@s-opensource.com>
> CommitDate: Wed Apr 5 14:50:57 2017 -0300
> 
>     [media] rc: promote lirc_sir out of staging
>     
>     Rename lirc_sir to sir_ir in the process.
>     
>     Signed-off-by: Sean Young <sean@mess.org>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Here the sir_ir gets in an infinite loop in its interrupt handler, since the
hardware is different from what it expects.

I was looking in all the wrong places so it took too long to find this. :/

I'll send a patch as a reply to this email.

Thanks,

Sean
