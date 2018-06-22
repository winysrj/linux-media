Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:38773 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754634AbeFVXMn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 19:12:43 -0400
Received: by mail-pf0-f195.google.com with SMTP id a1-v6so5637pfi.5
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2018 16:12:43 -0700 (PDT)
Date: Fri, 22 Jun 2018 16:15:03 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Vikash Garodia <vgarodia@codeaurora.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org,
        stanimir.varbanov@linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        acourbot@chromium.org
Subject: Re: [PATCH v2 1/5] media: venus: add a routine to reset ARM9
Message-ID: <20180622231503.GN3402@tuxbook-pro>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-2-git-send-email-vgarodia@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527884768-22392-2-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 01 Jun 13:26 PDT 2018, Vikash Garodia wrote:
> +static void venus_reset_hw(struct venus_core *core)
> +{
> +	void __iomem *reg_base = core->base;
> +
> +	writel(0, reg_base + WRAPPER_FW_START_ADDR);
> +	writel(VENUS_FW_MEM_SIZE, reg_base + WRAPPER_FW_END_ADDR);
> +	writel(0, reg_base + WRAPPER_CPA_START_ADDR);
> +	writel(VENUS_FW_MEM_SIZE, reg_base + WRAPPER_CPA_END_ADDR);
> +	writel(0x0, reg_base + WRAPPER_CPU_CGC_DIS);
> +	writel(0x0, reg_base + WRAPPER_CPU_CLOCK_CONFIG);
> +
> +	/* Make sure all register writes are committed. */
> +	mb();

wmb() doesn't wait until the writes are completed, it simply ensures
that any writes before it are performed before any writes after it.

If you really want to ensure that these configs has hit the hardware
before you sleep, read back the value of the WRAPPER_CPU_CLOCK_CONFIG
register.

> +
> +	/*
> +	 * Need to wait 10 cycles of internal clocks before bringing ARM9
> +	 * out of reset.
> +	 */
> +	udelay(1);
> +
> +	/* Bring Arm9 out of reset */
> +	writel_relaxed(0, reg_base + WRAPPER_A9SS_SW_RESET);

There's no harm in using writel() here...

> +}

Regards,
Bjorn
