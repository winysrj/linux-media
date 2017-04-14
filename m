Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52065 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750784AbdDNILU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 04:11:20 -0400
Date: Fri, 14 Apr 2017 10:11:10 +0200
From: Greg KH <greg@kroah.com>
To: kbuild test robot <lkp@intel.com>
Cc: Alan Cox <alan@linux.intel.com>, kbuild-all@01.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 14/14] atomisp: remove UDS kernel code
Message-ID: <20170414081110.GA3262@kroah.com>
References: <149202136244.16615.14834078586870499181.stgit@acox1-desk1.ger.corp.intel.com>
 <201704140306.UQAIWQYj%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201704140306.UQAIWQYj%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 14, 2017 at 03:27:08AM +0800, kbuild test robot wrote:
> Hi Alan,
> 
> [auto build test ERROR on next-20170412]
> [cannot apply to linuxtv-media/master v4.9-rc8 v4.9-rc7 v4.9-rc6 v4.11-rc6]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Alan-Cox/staging-atomisp-use-local-variable-to-reduce-number-of-references/20170413-112312
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
> >> make[7]: *** No rule to make target 'drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/uds/uds_1.0/ia_css_uds.host.o', needed by 'drivers/staging/media/atomisp/pci/atomisp2/atomisp.o'.
>    make[7]: *** No rule to make target 'drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.o', needed by 'drivers/staging/media/atomisp/pci/atomisp2/atomisp.o'.
>    make[7]: Target '__build' not remade because of errors.

This too is odd, are you not rebuilding everything properly when a file
is removed?  This works for me here.

thanks,

greg k-h
