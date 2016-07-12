Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:34708 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbcGLM1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:27:34 -0400
Received: by mail-lf0-f49.google.com with SMTP id h129so11877440lfh.1
        for <linux-media@vger.kernel.org>; Tue, 12 Jul 2016 05:27:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1468322506-32702-1-git-send-email-weiyj_lk@163.com>
References: <1468322506-32702-1-git-send-email-weiyj_lk@163.com>
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Date: Tue, 12 Jul 2016 15:27:31 +0300
Message-ID: <CALi4nhoFR0VyW+bCm7f9RDt8bk2zptG__svt_7YWq46cVQMB=g@mail.gmail.com>
Subject: Re: [PATCH -next] [media] rcar_jpu: Add missing clk_disable_unprepare()
 on error in jpu_open()
To: weiyj_lk@163.com
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 12, 2016 at 2:21 PM,  <weiyj_lk@163.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Add the missing clk_disable_unprepare() before return from
> jpu_open() in the software reset error handling case.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Hello, Wei Yongjun.
Thanks for the patch!

Acked-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>


-- 
W.B.R, Mikhail.
