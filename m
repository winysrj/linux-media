Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37978 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753448AbdEENnF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 09:43:05 -0400
Received: by mail-wm0-f46.google.com with SMTP id 142so6729525wma.1
        for <linux-media@vger.kernel.org>; Fri, 05 May 2017 06:43:00 -0700 (PDT)
Subject: Re: [PATCH v8 00/10] Qualcomm video decoder/encoder driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1493370837-19793-1-git-send-email-stanimir.varbanov@linaro.org>
 <c0bdbddd-e6df-f8a5-6d04-0d4e84c9dd0a@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <59e18457-118f-94fe-58c5-7a0567bcde15@linaro.org>
Date: Fri, 5 May 2017 16:42:44 +0300
MIME-Version: 1.0
In-Reply-To: <c0bdbddd-e6df-f8a5-6d04-0d4e84c9dd0a@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 05/05/2017 03:44 PM, Hans Verkuil wrote:
> Hi Stanimir,
> 
> It looks good to me. I do think that patch 01/10 shouldn't go through
> media. This might mean that we have to drop the COMPILE_TEST dependency
> on the media driver until this firmware driver patch gets merged, which
> is fine with me as long as this is clearly stated in the commit log for
> the media Kconfig. Let me know what you want to do with this.

OK, the best I can do is to drop COMPILE_TEST for Venus driver in this
patch set and work separately on qcom_scm firmware driver patching. Thus
I will repost v9 version next week.

> 
> I also saw some comments for patch 05/10, but I'm not sure if that would
> block merging this driver or can be fixed afterwards.

I will prefix the exported symbols from venus-core driver as pointed by
Sakari in next v9 version plus fixes for few signed-unsigned compare
warnings.

-- 
regards,
Stan
