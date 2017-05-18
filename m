Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51211 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755323AbdEROXW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 10:23:22 -0400
Date: Thu, 18 May 2017 15:23:19 +0100
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: Re: [PATCH 2/4] [media] imon: better code the pad_mouse toggling
Message-ID: <20170518142319.GA14397@gofer.mess.org>
References: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
 <cdce7df07641f6f364a241bfa77ba76ade9cae68.1495116400.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdce7df07641f6f364a241bfa77ba76ade9cae68.1495116400.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 18, 2017 at 11:06:44AM -0300, Mauro Carvalho Chehab wrote:
> The logic with toggles the pad_mouse is confusing. Now, gcc 7.1
> complains about it:
> 
> drivers/media/rc/imon.c: In function 'imon_incoming_scancode':
> drivers/media/rc/imon.c:1725:23: warning: '~' on a boolean expression [-Wbool-operation]
>     ictx->pad_mouse = (~ictx->pad_mouse) & 0x1;
>                        ^
> drivers/media/rc/imon.c:1725:23: note: did you mean to use logical not?
>     ictx->pad_mouse = (~ictx->pad_mouse) & 0x1;
>                        ^
>                        !
> 
> Rewrite it to be clearer for both code reviewers and gcc.

This was already spotted by Arnd.

https://patchwork.linuxtv.org/patch/41270/

Thanks
Sean
