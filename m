Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:51635 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758213AbdJMPs0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 11:48:26 -0400
Subject: Re: [PATCH v2 09/17] media: cec-pin.h: convert comments for
 cec_pin_state into kernel-doc
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <cover.1506548682.git.mchehab@s-opensource.com>
 <41e0821221f6e601791c5e1e6ee74a0f26339a7e.1506548682.git.mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5c4a9146-3d05-6e42-88f7-f287ce4e085a@xs4all.nl>
Date: Fri, 13 Oct 2017 17:48:21 +0200
MIME-Version: 1.0
In-Reply-To: <41e0821221f6e601791c5e1e6ee74a0f26339a7e.1506548682.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/17 23:46, Mauro Carvalho Chehab wrote:
> This enum is already documented, but it is not using a kernel-doc
> format. Convert its format, in order to produce documentation.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

No, this does not belong in the kernel API doc. It is really just an internal
API.

The only things that belong in this header are the two function prototypes
and struct cec-pin_ops. Everything else should be moved to a cec-pin-priv.h
header inside drivers/media/cec.

If it is OK with you, then I'll take care of that.

Regards,

	Hans

> ---
>  include/media/cec-pin.h | 81 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 52 insertions(+), 29 deletions(-)
> 
> diff --git a/include/media/cec-pin.h b/include/media/cec-pin.h
> index f09cc9579d53..fbe8c256820e 100644
> --- a/include/media/cec-pin.h
> +++ b/include/media/cec-pin.h
> @@ -24,65 +24,88 @@
>  #include <linux/atomic.h>
>  #include <media/cec.h>
>  
> +/**
> + * enum cec_pin_state - state of CEC pins
> + * @CEC_ST_OFF:
> + *	CEC is off
> + * @CEC_ST_IDLE:
> + *	CEC is idle, waiting for Rx or Tx
> + * @CEC_ST_TX_WAIT:
> + *	Pending Tx, waiting for Signal Free Time to expire
> + * @CEC_ST_TX_WAIT_FOR_HIGH:
> + *	Low-drive was detected, wait for bus to go high
> + * @CEC_ST_TX_START_BIT_LOW:
> + *	Drive CEC low for the start bit
> + * @CEC_ST_TX_START_BIT_HIGH:
> + *	Drive CEC high for the start bit
> + * @CEC_ST_TX_DATA_BIT_0_LOW:
> + *	Drive CEC low for the 0 bit
> + * @CEC_ST_TX_DATA_BIT_0_HIGH:
> + *	Drive CEC high for the 0 bit
> + * @CEC_ST_TX_DATA_BIT_1_LOW:
> + *	Drive CEC low for the 1 bit
> + * @CEC_ST_TX_DATA_BIT_1_HIGH:
> + *	Drive CEC high for the 1 bit
> + * @CEC_ST_TX_DATA_BIT_1_HIGH_PRE_SAMPLE:
> + *	Wait for start of sample time to check for Ack bit or first
> + *	four initiator bits to check for Arbitration Lost.
> + * @CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE:
> + *	Wait for end of bit period after sampling
> + * @CEC_ST_RX_START_BIT_LOW:
> + *	Start bit low detected
> + * @CEC_ST_RX_START_BIT_HIGH:
> + *	Start bit high detected
> + * @CEC_ST_RX_DATA_SAMPLE:
> + *	Wait for bit sample time
> + * @CEC_ST_RX_DATA_POST_SAMPLE:
> + *	Wait for earliest end of bit period after sampling
> + * @CEC_ST_RX_DATA_HIGH:
> + *	Wait for CEC to go high (i.e. end of bit period
> + * @CEC_ST_RX_ACK_LOW:
> + *	Drive CEC low to send 0 Ack bit
> + * @CEC_ST_RX_ACK_LOW_POST:
> + *	End of 0 Ack time, wait for earliest end of bit period
> + * @CEC_ST_RX_ACK_HIGH_POST:
> + *	Wait for CEC to go high (i.e. end of bit period
> + * @CEC_ST_RX_ACK_FINISH:
> + *	Wait for earliest end of bit period and end of message
> + * @CEC_ST_LOW_DRIVE:
> + *	Start low drive
> + * @CEC_ST_RX_IRQ:
> + *	Monitor pin using interrupts
> + * @CEC_PIN_STATES:
> + *	Total number of pin states
> + */
>  enum cec_pin_state {
> -	/* CEC is off */
>  	CEC_ST_OFF,
> -	/* CEC is idle, waiting for Rx or Tx */
>  	CEC_ST_IDLE,
>  
>  	/* Tx states */
> -
> -	/* Pending Tx, waiting for Signal Free Time to expire */
>  	CEC_ST_TX_WAIT,
> -	/* Low-drive was detected, wait for bus to go high */
>  	CEC_ST_TX_WAIT_FOR_HIGH,
> -	/* Drive CEC low for the start bit */
>  	CEC_ST_TX_START_BIT_LOW,
> -	/* Drive CEC high for the start bit */
>  	CEC_ST_TX_START_BIT_HIGH,
> -	/* Drive CEC low for the 0 bit */
>  	CEC_ST_TX_DATA_BIT_0_LOW,
> -	/* Drive CEC high for the 0 bit */
>  	CEC_ST_TX_DATA_BIT_0_HIGH,
> -	/* Drive CEC low for the 1 bit */
>  	CEC_ST_TX_DATA_BIT_1_LOW,
> -	/* Drive CEC high for the 1 bit */
>  	CEC_ST_TX_DATA_BIT_1_HIGH,
> -	/*
> -	 * Wait for start of sample time to check for Ack bit or first
> -	 * four initiator bits to check for Arbitration Lost.
> -	 */
>  	CEC_ST_TX_DATA_BIT_1_HIGH_PRE_SAMPLE,
> -	/* Wait for end of bit period after sampling */
>  	CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE,
>  
>  	/* Rx states */
> -
> -	/* Start bit low detected */
>  	CEC_ST_RX_START_BIT_LOW,
> -	/* Start bit high detected */
>  	CEC_ST_RX_START_BIT_HIGH,
> -	/* Wait for bit sample time */
>  	CEC_ST_RX_DATA_SAMPLE,
> -	/* Wait for earliest end of bit period after sampling */
>  	CEC_ST_RX_DATA_POST_SAMPLE,
> -	/* Wait for CEC to go high (i.e. end of bit period */
>  	CEC_ST_RX_DATA_HIGH,
> -	/* Drive CEC low to send 0 Ack bit */
>  	CEC_ST_RX_ACK_LOW,
> -	/* End of 0 Ack time, wait for earliest end of bit period */
>  	CEC_ST_RX_ACK_LOW_POST,
> -	/* Wait for CEC to go high (i.e. end of bit period */
>  	CEC_ST_RX_ACK_HIGH_POST,
> -	/* Wait for earliest end of bit period and end of message */
>  	CEC_ST_RX_ACK_FINISH,
>  
> -	/* Start low drive */
>  	CEC_ST_LOW_DRIVE,
> -	/* Monitor pin using interrupts */
>  	CEC_ST_RX_IRQ,
>  
> -	/* Total number of pin states */
>  	CEC_PIN_STATES
>  };
>  
> 
