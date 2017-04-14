Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35933 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751235AbdDNIJZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 04:09:25 -0400
Date: Fri, 14 Apr 2017 10:09:15 +0200
From: Greg KH <greg@kroah.com>
To: kbuild test robot <lkp@intel.com>
Cc: Alan Cox <alan@linux.intel.com>, kbuild-all@01.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 12/14] atomisp: remove fixedbds kernel code
Message-ID: <20170414080915.GA21311@kroah.com>
References: <149202134077.16615.9955869109062515751.stgit@acox1-desk1.ger.corp.intel.com>
 <201704131901.O8h0sjJH%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201704131901.O8h0sjJH%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 13, 2017 at 07:53:58PM +0800, kbuild test robot wrote:
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
> >> make[7]: *** No rule to make target 'drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds.host.o', needed by 'drivers/staging/media/atomisp/pci/atomisp2/atomisp.o'.
>    make[7]: Target '__build' not remade because of errors.

That's an odd error, this works fine for me here.

greg k-h
