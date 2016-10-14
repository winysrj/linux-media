Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:57635 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752103AbcJNSXi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 14:23:38 -0400
Subject: Re: [PATCH 11/25] [media] dvb-core: use pr_foo() instead of printk()
To: Mauro Carvalho Chehab <mchehab@kernel.org>
References: <cover.1476466574.git.mchehab@s-opensource.com>
 <1d5040384c93e1cb37dd41e780e44a88b1e63ce4.1476466574.git.mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Max Kellermann <max@duempel.org>,
        Shuah Khan <shuah@kernel.org>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Abhilash Jindal <klock.android@gmail.com>,
        Xiubo Li <lixiubo@cmss.chinamobile.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <ad6e8052-d9e2-e5bd-1c19-f402c04007ea@users.sourceforge.net>
Date: Fri, 14 Oct 2016 20:22:40 +0200
MIME-Version: 1.0
In-Reply-To: <1d5040384c93e1cb37dd41e780e44a88b1e63ce4.1476466574.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
> index 7b67e1dd97fd..1e96a6f1b6f0 100644
> --- a/drivers/media/dvb-core/dmxdev.c
> +++ b/drivers/media/dvb-core/dmxdev.c
> @@ -20,6 +20,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) "dmxdev: " fmt
> +
>  #include <linux/sched.h>
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>

How do you think to use an approach like the following there?


+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt


   or eventually


+#define MY_LOG_PREFIX KBUILD_MODNAME ": "
+#define pr_fmt(fmt) MY_LOG_PREFIX fmt


Regards,
Markus
