Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:11704 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753211AbeDMJP3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Apr 2018 05:15:29 -0400
Subject: Re: [PATCH 15/17] media: st_rc: Don't stay on an IRQ handler forever
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
 <16b1993cde965edc096f0833091002dd05d4da7f.1523546545.git.mchehab@s-opensource.com>
From: Mason <slash.tmp@free.fr>
Message-ID: <37713022-870c-829b-bec9-18a62a39782c@free.fr>
Date: Fri, 13 Apr 2018 11:15:16 +0200
MIME-Version: 1.0
In-Reply-To: <16b1993cde965edc096f0833091002dd05d4da7f.1523546545.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/04/2018 17:24, Mauro Carvalho Chehab wrote:

> As warned by smatch:
> 	drivers/media/rc/st_rc.c:110 st_rc_rx_interrupt() warn: this loop depends on readl() succeeding
> 
> If something goes wrong at readl(), the logic will stay there
> inside an IRQ code forever. This is not the nicest thing to
> do :-)
> 
> So, add a timeout there, preventing staying inside the IRQ
> for more than 10ms.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/rc/st_rc.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
> index d2efd7b2c3bc..c855b177103c 100644
> --- a/drivers/media/rc/st_rc.c
> +++ b/drivers/media/rc/st_rc.c
> @@ -96,19 +96,24 @@ static void st_rc_send_lirc_timeout(struct rc_dev *rdev)
>  
>  static irqreturn_t st_rc_rx_interrupt(int irq, void *data)
>  {
> +	unsigned long timeout;
>  	unsigned int symbol, mark = 0;
>  	struct st_rc_device *dev = data;
>  	int last_symbol = 0;
> -	u32 status;
> +	u32 status, int_status;
>  	DEFINE_IR_RAW_EVENT(ev);
>  
>  	if (dev->irq_wake)
>  		pm_wakeup_event(dev->dev, 0);
>  
> -	status  = readl(dev->rx_base + IRB_RX_STATUS);
> +	/* FIXME: is 10ms good enough ? */
> +	timeout = jiffies +  msecs_to_jiffies(10);
> +	do {
> +		status  = readl(dev->rx_base + IRB_RX_STATUS);
> +		if (!(status & (IRB_FIFO_NOT_EMPTY | IRB_OVERFLOW)))
> +			break;
>  
> -	while (status & (IRB_FIFO_NOT_EMPTY | IRB_OVERFLOW)) {
> -		u32 int_status = readl(dev->rx_base + IRB_RX_INT_STATUS);
> +		int_status = readl(dev->rx_base + IRB_RX_INT_STATUS);
>  		if (unlikely(int_status & IRB_RX_OVERRUN_INT)) {
>  			/* discard the entire collection in case of errors!  */
>  			ir_raw_event_reset(dev->rdev);
> @@ -148,8 +153,7 @@ static irqreturn_t st_rc_rx_interrupt(int irq, void *data)
>  
>  		}
>  		last_symbol = 0;
> -		status  = readl(dev->rx_base + IRB_RX_STATUS);
> -	}
> +	} while (time_is_after_jiffies(timeout));
>  
>  	writel(IRB_RX_INTS, dev->rx_base + IRB_RX_INT_CLEAR);
>  

Isn't this a place where the iopoll.h helpers might be useful?

e.g. readl_poll_timeout()

https://elixir.bootlin.com/linux/latest/source/include/linux/iopoll.h#L114

Regards.
