Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:34198 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbbJFPuz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2015 11:50:55 -0400
Received: by ykdg206 with SMTP id g206so205719362ykd.1
        for <linux-media@vger.kernel.org>; Tue, 06 Oct 2015 08:50:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201510050538.k3ZpNf2w%fengguang.wu@intel.com>
References: <201510050538.k3ZpNf2w%fengguang.wu@intel.com>
Date: Tue, 6 Oct 2015 17:50:54 +0200
Message-ID: <CABxcv=mssUPcMdHonxee+EY1P_Hk8DXmMXhB7-Ok8HeJPiWdgA@mail.gmail.com>
Subject: Re: drivers/media/pci/netup_unidvb/netup_unidvb_core.c:417:18: error:
 too many arguments to function 'horus3a_attach'
From: Javier Martinez Canillas <javier@dowhile0.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Kozlov Sergey <serjk@netup.ru>, kbuild-all@01.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Fengguang,

On Sun, Oct 4, 2015 at 11:43 PM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> Hi Kozlov,
>
> FYI, the error/warning still remains.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   049e6dde7e57f0054fdc49102e7ef4830c698b46
> commit: 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card driver
> date:   8 weeks ago
> config: x86_64-randconfig-n0-10050530 (attached as .config)
> reproduce:
>         git checkout 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> All error/warnings (new ones prefixed by >>):
>
>    In file included from drivers/media/pci/netup_unidvb/netup_unidvb_core.c:34:0:
>    drivers/media/dvb-frontends/horus3a.h:51:13: warning: 'struct cxd2820r_config' declared inside parameter list
>          struct i2c_adapter *i2c)
>

A fix for this build issue is already queued [0] in the media_tree
fixes branch and AFAIU it will be pushed to mainline soon.

Best regards,
Javier

[0]: http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?h=fixes&id=de5abc98bf34e06d7accd943c4057843db921f00
