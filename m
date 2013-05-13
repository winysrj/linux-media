Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:51707 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3EMGFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 02:05:13 -0400
Received: by mail-we0-f172.google.com with SMTP id w60so5986290wes.17
        for <linux-media@vger.kernel.org>; Sun, 12 May 2013 23:05:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_iDfVzq2S_uSh1tBVpQdFa4oyMpWGovDDNCYsh0bLJog@mail.gmail.com>
References: <CAPgLHd_iDfVzq2S_uSh1tBVpQdFa4oyMpWGovDDNCYsh0bLJog@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 13 May 2013 11:34:51 +0530
Message-ID: <CA+V-a8v5Msfwr11tpC5xR90e5E02Mz+OJcqnYohmp2ri_VgC1Q@mail.gmail.com>
Subject: Re: [PATCH] [media] vpif_display: fix error return code in vpif_probe()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@redhat.com, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

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
