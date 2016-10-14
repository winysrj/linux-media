Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:51517 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbdECVvw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 May 2017 17:51:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Max Kellermann <max@duempel.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Shuah Khan <shuah@kernel.org>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Abhilash Jindal <klock.android@gmail.com>,
        Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH 11/25] [media] dvb-core: use pr_foo() instead of printk()
Date: Fri, 14 Oct 2016 22:15:29 +0200
Message-ID: <5626419.v5W73DMoxa@wuerfel>
In-Reply-To: <1d5040384c93e1cb37dd41e780e44a88b1e63ce4.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com> <1d5040384c93e1cb37dd41e780e44a88b1e63ce4.1476466574.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, October 14, 2016 2:45:49 PM CEST Mauro Carvalho Chehab wrote:
> 
> -#define dprintk        if (debug) printk
> +#define dprintk(fmt, arg...) do {                                      \
> +       if (debug)                                                      \
> +               printk(KERN_DEBUG pr_fmt("%s: " fmt),                   \
> +                       __func__, ##arg);                               \
> +} while (0)
> 

Why not just use pr_debug() or dev_dbg() here? They already
have a way to control output at runtime (CONFIG_DYNAMIC_DEBUG).

	Arnd
