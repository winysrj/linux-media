Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:51420 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751842AbdGLTnQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 15:43:16 -0400
Subject: Re: [PATCH 4/4] drm/vc4: add HDMI CEC support
To: Eric Anholt <eric@anholt.net>, linux-media@vger.kernel.org
References: <20170711112021.38525-1-hverkuil@xs4all.nl>
 <20170711112021.38525-5-hverkuil@xs4all.nl>
 <87d195h41b.fsf@eliezer.anholt.net>
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c45868d2-50e5-987b-db1e-b8e76983cbb2@xs4all.nl>
Date: Wed, 12 Jul 2017 21:43:11 +0200
MIME-Version: 1.0
In-Reply-To: <87d195h41b.fsf@eliezer.anholt.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/07/17 21:02, Eric Anholt wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This patch adds support to VC4 for CEC.
>>
>> To prevent the firmware from eating the CEC interrupts you need to add this to
>> your config.txt:
>>
>> mask_gpu_interrupt1=0x100
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This looks pretty great.  Just a couple of little comments.
> 
>> ---
>>  drivers/gpu/drm/vc4/Kconfig    |   8 ++
>>  drivers/gpu/drm/vc4/vc4_hdmi.c | 203 ++++++++++++++++++++++++++++++++++++++++-
>>  drivers/gpu/drm/vc4/vc4_regs.h |   5 +
>>  3 files changed, 211 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/vc4/Kconfig b/drivers/gpu/drm/vc4/Kconfig
>> index 4361bdcfd28a..fdae18aeab4f 100644
>> --- a/drivers/gpu/drm/vc4/Kconfig
>> +++ b/drivers/gpu/drm/vc4/Kconfig
>> @@ -19,3 +19,11 @@ config DRM_VC4
>>  	  This driver requires that "avoid_warnings=2" be present in
>>  	  the config.txt for the firmware, to keep it from smashing
>>  	  our display setup.
>> +
>> +config DRM_VC4_HDMI_CEC
>> +       bool "Broadcom VC4 HDMI CEC Support"
>> +       depends on DRM_VC4
>> +       select CEC_CORE
>> +       help
>> +	  Choose this option if you have a Broadcom VC4 GPU
>> +	  and want to use CEC.
> 
> Do we need a Kconfig for this?  Couldn't we just #ifdef on CEC_CORE
> instead?

It's been my practice to do so for all drivers where I added CEC support.
The main reason is that it is an optional feature of the HDMI protocol, so
you simply may not want to use it to avoid loading the 55+ kB of the cec module.
It will likely grow in size in the future as well.

Also (esp. true for embedded devices) the CEC pin might not even be hooked up!

Finally, you may prefer to use e.g. a Pulse-Eight USB adapter for whatever
reason and then you don't need this either.

> 
>> diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
>> index b0521e6cc281..14e2ece5db94 100644
>> --- a/drivers/gpu/drm/vc4/vc4_hdmi.c
>> +++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
> 
>> +static int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
>> +{
>> +	struct vc4_dev *vc4 = cec_get_drvdata(adap);
>> +	u32 hsm_clock = clk_get_rate(vc4->hdmi->hsm_clock);
>> +	u32 cntrl1 = HDMI_READ(VC4_HDMI_CEC_CNTRL_1);
>> +	u32 divclk = cntrl1 & VC4_HDMI_CEC_DIV_CLK_CNT_MASK;
> 
> We should probably be setting the divider to a value of our choice,
> rather than relying on whatever default value is there.

Hardcode the divider to 4091, you mean? I can do that.

> 
> (Bonus points if we were to do this using a common clk divider, so the
> rate shows up in /debug/clk/clk_summary, but I won't require that)
> 
>> +	/* clock period in microseconds */
>> +	u32 usecs = 1000000 / (hsm_clock / divclk);
>> +	u32 val = HDMI_READ(VC4_HDMI_CEC_CNTRL_5);
>> +
>> +	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
>> +		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
>> +		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
>> +	val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
>> +	       ((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
>> +
>> +	if (enable) {
>> +		cntrl1 &= VC4_HDMI_CEC_DIV_CLK_CNT_MASK |
>> +			  VC4_HDMI_CEC_ADDR_MASK;
>> +
>> +		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_5, val |
>> +			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
>> +		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_5, val);
>> +		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_2,
>> +			 ((1500 / usecs) << VC4_HDMI_CEC_CNT_TO_1500_US_SHIFT) |
>> +			 ((1300 / usecs) << VC4_HDMI_CEC_CNT_TO_1300_US_SHIFT) |
>> +			 ((800 / usecs) << VC4_HDMI_CEC_CNT_TO_800_US_SHIFT) |
>> +			 ((600 / usecs) << VC4_HDMI_CEC_CNT_TO_600_US_SHIFT) |
>> +			 ((400 / usecs) << VC4_HDMI_CEC_CNT_TO_400_US_SHIFT));
>> +		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_3,
>> +			 ((2750 / usecs) << VC4_HDMI_CEC_CNT_TO_2750_US_SHIFT) |
>> +			 ((2400 / usecs) << VC4_HDMI_CEC_CNT_TO_2400_US_SHIFT) |
>> +			 ((2050 / usecs) << VC4_HDMI_CEC_CNT_TO_2050_US_SHIFT) |
>> +			 ((1700 / usecs) << VC4_HDMI_CEC_CNT_TO_1700_US_SHIFT));
>> +		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_4,
>> +			 ((4300 / usecs) << VC4_HDMI_CEC_CNT_TO_4300_US_SHIFT) |
>> +			 ((3900 / usecs) << VC4_HDMI_CEC_CNT_TO_3900_US_SHIFT) |
>> +			 ((3600 / usecs) << VC4_HDMI_CEC_CNT_TO_3600_US_SHIFT) |
>> +			 ((3500 / usecs) << VC4_HDMI_CEC_CNT_TO_3500_US_SHIFT));
>> +
>> +		HDMI_WRITE(VC4_HDMI_CPU_MASK_CLEAR, VC4_HDMI_CPU_CEC);
>> +	} else {
>> +		HDMI_WRITE(VC4_HDMI_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
>> +		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_5, val |
>> +			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
>> +	}
>> +	return 0;
>> +}
> 
>> +static int vc4_hdmi_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
>> +				      u32 signal_free_time, struct cec_msg *msg)
>> +{
>> +	struct vc4_dev *vc4 = cec_get_drvdata(adap);
>> +	u32 val;
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < msg->len; i += 4)
>> +		HDMI_WRITE(VC4_HDMI_CEC_TX_DATA_1 + i,
>> +			   (msg->msg[i]) |
>> +			   (msg->msg[i + 1] << 8) |
>> +			   (msg->msg[i + 2] << 16) |
>> +			   (msg->msg[i + 3] << 24));
>> +
>> +	val = HDMI_READ(VC4_HDMI_CEC_CNTRL_1);
>> +	val &= ~VC4_HDMI_CEC_START_XMIT_BEGIN;
>> +	HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1, val);
>> +	val &= ~VC4_HDMI_CEC_MESSAGE_LENGTH_MASK;
>> +	val |= (msg->len - 1) << VC4_HDMI_CEC_MESSAGE_LENGTH_SHIFT;
>> +	val |= VC4_HDMI_CEC_START_XMIT_BEGIN;
> 
> It doesn't look to me like len should have 1 subtracted from it.  The
> field has 4 bits for our up-to-16-byte length, and the firmware seems to
> be setting it to the same value as a memcpy for the message data uses.

You need to subtract by one. The CEC protocol supports messages of 1-16
bytes in length. Since the message length mask is only 4 bits you need to
encode this in the value 0-15. Hence the '-1', otherwise you would never
be able to send 16 byte messages.

I actually found this when debugging the messages it was transmitting: they
were one too long.

This suggests that the firmware does this wrong. I don't have time tomorrow,
but I'll see if I can do a quick test on Friday to verify that.

> 
>> +
>> +	HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1, val);
>> +	return 0;
>> +}
>> +
>> +static const struct cec_adap_ops vc4_hdmi_cec_adap_ops = {
>> +	.adap_enable = vc4_hdmi_cec_adap_enable,
>> +	.adap_log_addr = vc4_hdmi_cec_adap_log_addr,
>> +	.adap_transmit = vc4_hdmi_cec_adap_transmit,
>> +};
>> +#endif
> 
>> diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_regs.h
>> index b18cc20ee185..55677bd50f66 100644
>> --- a/drivers/gpu/drm/vc4/vc4_regs.h
>> +++ b/drivers/gpu/drm/vc4/vc4_regs.h
>> @@ -595,6 +595,7 @@
>>  # define VC4_HDMI_CEC_ADDR_MASK			VC4_MASK(15, 12)
>>  # define VC4_HDMI_CEC_ADDR_SHIFT		12
>>  /* Divides off of HSM clock to generate CEC bit clock. */
>> +/* With the current defaults the CEC bit clock is 40 kHz = 25 usec */
>>  # define VC4_HDMI_CEC_DIV_CLK_CNT_MASK		VC4_MASK(11, 0)
>>  # define VC4_HDMI_CEC_DIV_CLK_CNT_SHIFT		0
>>  
>> @@ -670,6 +671,10 @@
>>  # define VC4_HDMI_CPU_CEC			BIT(6)
>>  # define VC4_HDMI_CPU_HOTPLUG			BIT(0)
>>  
>> +#define VC4_HDMI_CPU_MASK_STATUS		0x34c
>> +#define VC4_HDMI_CPU_MASK_SET			0x350
>> +#define VC4_HDMI_CPU_MASK_CLEAR			0x354
>> +
>>  #define VC4_HDMI_GCP(x)				(0x400 + ((x) * 0x4))
>>  #define VC4_HDMI_RAM_PACKET(x)			(0x400 + ((x) * 0x24))
>>  #define VC4_HDMI_PACKET_STRIDE			0x24
>> -- 
>> 2.11.0
> 
> Maybe squash these changes into the previous patch?  Or we could squash
> the previous patch into this one and just tack my signed-off-by on
> yours.  Either way's fine with me.
> 

I prefer the latter option, just combine it all into this patch.

Regards,

	Hans
