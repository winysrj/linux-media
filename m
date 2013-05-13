Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60857 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3EMGGR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 02:06:17 -0400
Received: by mail-wi0-f176.google.com with SMTP id hr14so2519041wib.9
        for <linux-media@vger.kernel.org>; Sun, 12 May 2013 23:06:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_crJZgL3HxbCju0Zsq9q+vq8BrTnVxmhZWK9x464PF3A@mail.gmail.com>
References: <CAPgLHd_crJZgL3HxbCju0Zsq9q+vq8BrTnVxmhZWK9x464PF3A@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 13 May 2013 11:35:56 +0530
Message-ID: <CA+V-a8s8owT1CA-HFE+q9OZbmqFt-PjBzYQc3bztK=0cqfySEg@mail.gmail.com>
Subject: Re: [PATCH] [media] vpif_capture: fix error return code in vpif_probe()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@redhat.com, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei

Thanks for the patch.

On Mon, May 13, 2013 at 11:27 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return -ENODEV in the subdevice register error handling
> case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
