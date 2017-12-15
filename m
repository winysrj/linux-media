Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:53026 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755578AbdLOOQp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 09:16:45 -0500
Subject: Re: [PATCH 1/2] bdisp: Fix a possible sleep-in-atomic bug in
 bdisp_hw_reset
To: fabien.dessenne@st.com,
        Benjamin Gaignard <benjamin.gaignard@st.com>
References: <1513086445-29265-1-git-send-email-baijiaju1990@gmail.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <27ce28d5-4e1e-f83e-f413-b297bbc1a2cc@xs4all.nl>
Date: Fri, 15 Dec 2017 15:16:42 +0100
MIME-Version: 1.0
In-Reply-To: <1513086445-29265-1-git-send-email-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fabien or Benjamin, can you take a look at these two patches?

I'm a bit hesitant applying this since e.g. this bdisp_hw_reset() function might wait
for up to a second, which is a mite long for an interrupt :-)

Regards,

	Hans

On 12/12/17 14:47, Jia-Ju Bai wrote:
> The driver may sleep under a spinlock.
> The function call path is:
> bdisp_device_run (acquire the spinlock)
>   bdisp_hw_reset
>     msleep --> may sleep
> 
> To fix it, msleep is replaced with mdelay.
> 
> This bug is found by my static analysis tool(DSAC) and checked by my code review.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/media/platform/sti/bdisp/bdisp-hw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/platform/sti/bdisp/bdisp-hw.c
> index b7892f3..4b62ceb 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-hw.c
> +++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
> @@ -382,7 +382,7 @@ int bdisp_hw_reset(struct bdisp_dev *bdisp)
>  	for (i = 0; i < POLL_RST_MAX; i++) {
>  		if (readl(bdisp->regs + BLT_STA1) & BLT_STA1_IDLE)
>  			break;
> -		msleep(POLL_RST_DELAY_MS);
> +		mdelay(POLL_RST_DELAY_MS);
>  	}
>  	if (i == POLL_RST_MAX)
>  		dev_err(bdisp->dev, "Reset timeout\n");
> 
