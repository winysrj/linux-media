Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:31781 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbeAZV6l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 16:58:41 -0500
Message-ID: <1517003913.8590.37.camel@rohdewald.de>
Subject: Re: [linux-next:master 3766/11889]
 drivers/media/dvb-frontends/stb0899_drv.h:151:36: error: weak declaration
 of 'stb0899_attach' being applied to a already existing, static definition
From: Wolfgang Rohdewald <wolfgang.kde@rohdewald.de>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Date: Fri, 26 Jan 2018 22:58:33 +0100
In-Reply-To: <201801270517.AOACCOQB%fengguang.wu@intel.com>
References: <201801270517.AOACCOQB%fengguang.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sa, 2018-01-27 at 05:51 +0800, kbuild test robot wrote:
> Hi Wolfgang,
> 
> FYI, the error/warning still remains.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   f0701bf7db7ab816244aed52d28ac49f32c8c2c9
> commit: 6cdeaed3b1420bd2569891be0c4123ff59628e9e [3766/11889] media: dvb_usb_pctv452e: module refcount changes were unbalanced
> config: i386-randconfig-c0-01270453 (attached as .config)
> compiler: gcc-7 (Debian 7.2.0-12) 7.2.1 20171025
> reproduce:
>         git checkout 6cdeaed3b1420bd2569891be0c4123ff59628e9e
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from drivers/media/usb/dvb-usb/pctv452e.c:20:0:
>    drivers/media/usb/dvb-usb/pctv452e.c: In function 'pctv452e_frontend_attach':
> > > drivers/media/dvb-frontends/stb0899_drv.h:151:36: error: weak declaration of 'stb0899_attach' being applied to a already existing, static definition
> 
>     static inline struct dvb_frontend *stb0899_attach(struct stb0899_config *config,
>                                        ^~~~~~~~~~~~~~


Mauro and Arnd have an unfinished discussion about the correct fix, I cannot help with that.



Wolfgang
