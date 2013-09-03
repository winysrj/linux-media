Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57688 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3ICEss (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Sep 2013 00:48:48 -0400
Received: by mail-wg0-f44.google.com with SMTP id b13so169497wgh.35
        for <linux-media@vger.kernel.org>; Mon, 02 Sep 2013 21:48:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd9n__f62vRMUDOhjX+KygoFQqp-ip02-S0rt7cDYHk+BQ@mail.gmail.com>
References: <CAPgLHd-0+fYLMh+Ff+cgewBPy1itjp-EtbAjzs5UrJsqrY3aNg@mail.gmail.com>
 <CA+V-a8szUWiURmmuWReyH1xWSheyn9COOgdGkfFTSkbOPh44FQ@mail.gmail.com>
 <CA+V-a8vLpSWCAecvNEFB0jxoJ0=oXsB3LWEMbfN00LghkW4Egw@mail.gmail.com> <CAPgLHd9n__f62vRMUDOhjX+KygoFQqp-ip02-S0rt7cDYHk+BQ@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 3 Sep 2013 10:18:27 +0530
Message-ID: <CA+V-a8ty6aKTmgTp5TJmA3BeBqT0EjPUeTFoae9rPxrhd97J9Q@mail.gmail.com>
Subject: Re: [PATCH -next v2] [media] davinci: vpif_capture: fix error return
 code in vpif_probe()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 2, 2013 at 2:36 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
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
