Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:54536 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3HWDKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 23:10:15 -0400
Received: by mail-vc0-f175.google.com with SMTP id ia10so70923vcb.20
        for <linux-media@vger.kernel.org>; Thu, 22 Aug 2013 20:10:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd89o=SNERB1cCyQKUmyQE9q-hx6nj19yvVd_PzkOfp4BA@mail.gmail.com>
References: <CAPgLHd89o=SNERB1cCyQKUmyQE9q-hx6nj19yvVd_PzkOfp4BA@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 23 Aug 2013 08:39:54 +0530
Message-ID: <CA+V-a8sY0ej8_w0paeGu4sotg+DtxpK=JFUk_BhVxy0pb_hz9g@mail.gmail.com>
Subject: Re: [PATCH -next] [media] davinci: vpif_display: fix error return
 code in vpif_probe()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

On Fri, Aug 23, 2013 at 8:29 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return -ENODEV in the subdevice register error handling
> case instead of 0, as done elsewhere in this function.
>
> Introduce by commit 4b8a531e6bb0686203e9cf82a54dfe189de7d5c2.
> ([media] media: davinci: vpif: display: add V4L2-async support)
>
This fix is already present in the kernel with commit id
4fa94e224b84be7b2522a0f5ce5b64124f146fac

Regards,
--Prabhakar Lad
