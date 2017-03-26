Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36398 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751191AbdCZWU3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Mar 2017 18:20:29 -0400
Received: by mail-wr0-f193.google.com with SMTP id u1so7953867wra.3
        for <linux-media@vger.kernel.org>; Sun, 26 Mar 2017 15:20:28 -0700 (PDT)
Date: Mon, 27 Mar 2017 00:20:25 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 12/12] [media] ddbridge: support STV0367-based cards
 and modules
Message-ID: <20170327002025.0a5afdc3@macbox>
In-Reply-To: <201703270045.qSpA8m3T%fengguang.wu@intel.com>
References: <20170324182408.25996-13-d.scheller.oss@gmail.com>
        <201703270045.qSpA8m3T%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 27 Mar 2017 00:46:45 +0800
schrieb kbuild test robot <lkp@intel.com>:

> [auto build test WARNING on linuxtv-media/master]
> [also build test WARNING on v4.11-rc3 next-20170324]
> [if your patch is applied to the wrong git tree, please drop us a
> note to help improve the system]
> 
> url:
> https://github.com/0day-ci/linux/commits/Daniel-Scheller/stv0367-ddbridge-support-CTv6-FlexCT-hardware/20170326-235957
> base:   git://linuxtv.org/media_tree.git master config:
> x86_64-rhel-7.2 (attached as .config) compiler: gcc-6 (Debian
> 6.2.0-3) 6.2.0 20160901 reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/media/pci/ddbridge/ddbridge-core.c: In function
> 'dvb_input_detach':
> >> drivers/media/pci/ddbridge/ddbridge-core.c:891:3: warning: this
> >> 'if' clause does not guard... [-Wmisleading-indentation]  
>       if (input->fe2)
>       ^~
>    drivers/media/pci/ddbridge/ddbridge-core.c:893:4: note: ...this
> statement, but the latter is misleadingly indented as if it is
> guarded by the 'if' input->fe2 = NULL; ^~~~~

Fixed in what I'll post as V3 series (planned for mid-week).

Daniel
