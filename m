Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:63999 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab3HWDOC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 23:14:02 -0400
Received: by mail-vb0-f53.google.com with SMTP id i3so77454vbh.12
        for <linux-media@vger.kernel.org>; Thu, 22 Aug 2013 20:14:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+V-a8sY0ej8_w0paeGu4sotg+DtxpK=JFUk_BhVxy0pb_hz9g@mail.gmail.com>
References: <CAPgLHd89o=SNERB1cCyQKUmyQE9q-hx6nj19yvVd_PzkOfp4BA@mail.gmail.com>
 <CA+V-a8sY0ej8_w0paeGu4sotg+DtxpK=JFUk_BhVxy0pb_hz9g@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 23 Aug 2013 08:43:41 +0530
Message-ID: <CA+V-a8u61HN2tziibzM5aBYavaRNtV-a6b3utH1BpDCwx3cm+w@mail.gmail.com>
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

Hi Wei

On Fri, Aug 23, 2013 at 8:39 AM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi Wei,
>
> On Fri, Aug 23, 2013 at 8:29 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Fix to return -ENODEV in the subdevice register error handling
>> case instead of 0, as done elsewhere in this function.
>>
>> Introduce by commit 4b8a531e6bb0686203e9cf82a54dfe189de7d5c2.
>> ([media] media: davinci: vpif: display: add V4L2-async support)
>>
> This fix is already present in the kernel with commit id
> 4fa94e224b84be7b2522a0f5ce5b64124f146fac
>
OOps my bad, I over looked it.

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
