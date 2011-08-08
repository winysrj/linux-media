Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1HHU2B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Aug 2011 16:28:01 -0400
Message-ID: <4E40469B.9060707@redhat.com>
Date: Mon, 08 Aug 2011 16:27:07 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Stephan Raue <sraue@openelec.tv>, stable@kernel.org
Subject: Re: [PATCH] [media] nuvoton-cir: simplify raw IR sample handling
References: <1312834840-16929-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1312834840-16929-1-git-send-email-jarod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson wrote:
> The nuvoton-cir driver was storing up consecutive pulse-pulse and
> space-space samples internally, for no good reason, since
> ir_raw_event_store_with_filter() already merges back to back like
> samples types for us. This should also fix a regression introduced late
> in 3.0 that related to a timeout change, which actually becomes correct
> when coupled with this change. Tested with RC6 and RC5 on my own
> nuvoton-cir hardware atop vanilla 3.0.0, after verifying quirky
> behavior in 3.0 due to the timeout change.
>
> Reported-by: Stephan Raue<sraue@openelec.tv>
> CC: Stephan Raue<sraue@openelec.tv>
> CC: stable@vger.kernel.org

Bah. I pooched the above CC, should have been stable@kernel.org.

> Signed-off-by: Jarod Wilson<jarod@redhat.com>
> ---
>   drivers/media/rc/nuvoton-cir.c |   45 +++++++--------------------------------
>   drivers/media/rc/nuvoton-cir.h |    1 -
>   2 files changed, 8 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
> index ce595f9..9fd019e 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -624,7 +624,6 @@ static void nvt_dump_rx_buf(struct nvt_dev *nvt)
>   static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
>   {
>   	DEFINE_IR_RAW_EVENT(rawir);
> -	unsigned int count;
>   	u32 carrier;
>   	u8 sample;
>   	int i;
> @@ -637,65 +636,38 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
>   	if (nvt->carrier_detect_enabled)
>   		carrier = nvt_rx_carrier_detect(nvt);
>
> -	count = nvt->pkts;
> -	nvt_dbg_verbose("Processing buffer of len %d", count);
> +	nvt_dbg_verbose("Processing buffer of len %d", nvt->pkts);
>
>   	init_ir_raw_event(&rawir);
>
> -	for (i = 0; i<  count; i++) {
> -		nvt->pkts--;
> +	for (i = 0; i<  nvt->pkts; i++) {
>   		sample = nvt->buf[i];
>
>   		rawir.pulse = ((sample&  BUF_PULSE_BIT) != 0);
>   		rawir.duration = US_TO_NS((sample&  BUF_LEN_MASK)
>   					  * SAMPLE_PERIOD);
>
> -		if ((sample&  BUF_LEN_MASK) == BUF_LEN_MASK) {
> -			if (nvt->rawir.pulse == rawir.pulse)
> -				nvt->rawir.duration += rawir.duration;
> -			else {
> -				nvt->rawir.duration = rawir.duration;
> -				nvt->rawir.pulse = rawir.pulse;
> -			}
> -			continue;
> -		}
> -
> -		rawir.duration += nvt->rawir.duration;
> +		nvt_dbg("Storing %s with duration %d",
> +			rawir.pulse ? "pulse" : "space", rawir.duration);
>
> -		init_ir_raw_event(&nvt->rawir);
> -		nvt->rawir.duration = 0;
> -		nvt->rawir.pulse = rawir.pulse;
> -
> -		if (sample == BUF_PULSE_BIT)
> -			rawir.pulse = false;
> -
> -		if (rawir.duration) {
> -			nvt_dbg("Storing %s with duration %d",
> -				rawir.pulse ? "pulse" : "space",
> -				rawir.duration);
> -
> -			ir_raw_event_store_with_filter(nvt->rdev,&rawir);
> -		}
> +		ir_raw_event_store_with_filter(nvt->rdev,&rawir);
>
>   		/*
>   		 * BUF_PULSE_BIT indicates end of IR data, BUF_REPEAT_BYTE
>   		 * indicates end of IR signal, but new data incoming. In both
>   		 * cases, it means we're ready to call ir_raw_event_handle
>   		 */
> -		if ((sample == BUF_PULSE_BIT)&&  nvt->pkts) {
> +		if ((sample == BUF_PULSE_BIT)&&  (i + 1<  nvt->pkts)) {
>   			nvt_dbg("Calling ir_raw_event_handle (signal end)\n");
>   			ir_raw_event_handle(nvt->rdev);
>   		}
>   	}
>
> +	nvt->pkts = 0;
> +
>   	nvt_dbg("Calling ir_raw_event_handle (buffer empty)\n");
>   	ir_raw_event_handle(nvt->rdev);
>
> -	if (nvt->pkts) {
> -		nvt_dbg("Odd, pkts should be 0 now... (its %u)", nvt->pkts);
> -		nvt->pkts = 0;
> -	}
> -
>   	nvt_dbg_verbose("%s done", __func__);
>   }
>
> @@ -1054,7 +1026,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
>
>   	spin_lock_init(&nvt->nvt_lock);
>   	spin_lock_init(&nvt->tx.lock);
> -	init_ir_raw_event(&nvt->rawir);
>
>   	ret = -EBUSY;
>   	/* now claim resources */
> diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
> index 1241fc8..0d5e087 100644
> --- a/drivers/media/rc/nuvoton-cir.h
> +++ b/drivers/media/rc/nuvoton-cir.h
> @@ -67,7 +67,6 @@ static int debug;
>   struct nvt_dev {
>   	struct pnp_dev *pdev;
>   	struct rc_dev *rdev;
> -	struct ir_raw_event rawir;
>
>   	spinlock_t nvt_lock;
>


-- 
Jarod Wilson
jarod@redhat.com


