Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f52.google.com ([209.85.212.52]:60212 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab3HWDOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 23:14:33 -0400
Received: by mail-vb0-f52.google.com with SMTP id f12so81006vbg.11
        for <linux-media@vger.kernel.org>; Thu, 22 Aug 2013 20:14:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-0+fYLMh+Ff+cgewBPy1itjp-EtbAjzs5UrJsqrY3aNg@mail.gmail.com>
References: <CAPgLHd-0+fYLMh+Ff+cgewBPy1itjp-EtbAjzs5UrJsqrY3aNg@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 23 Aug 2013 08:44:12 +0530
Message-ID: <CA+V-a8vzjnH6a2ZcBUsrcOdfWbwaNhjJxydM8vcDZxszsDerRQ@mail.gmail.com>
Subject: Re: [PATCH -next] [media] davinci: vpif_capture: fix error return
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

Thanks for the patch.

On Fri, Aug 23, 2013 at 8:30 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return -ENODEV in the subdevice register error handling
> case instead of 0, as done elsewhere in this function.
>
> Introduced by commit 873229e4fdf34196aa5d707957c59ba54c25eaba
> ([media] media: davinci: vpif: capture: add V4L2-async support)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
