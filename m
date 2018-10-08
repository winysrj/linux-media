Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllv0016.ext.ti.com ([198.47.19.142]:51730 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbeJHT5D (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 15:57:03 -0400
Subject: Re: [PATCH 4/5] omapdrm/dss/hdmi4_cec.c: clear TX FIFO before
 transmit_done
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
CC: <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20181004090900.32915-1-hverkuil@xs4all.nl>
 <20181004090900.32915-5-hverkuil@xs4all.nl>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <70112c2d-8551-4d78-0a4e-de55d71b98dc@ti.com>
Date: Mon, 8 Oct 2018 15:45:24 +0300
MIME-Version: 1.0
In-Reply-To: <20181004090900.32915-5-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 04/10/18 12:08, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The TX FIFO has to be cleared if the transmit failed due to e.g.
> a NACK condition, otherwise the hardware will keep trying to
> transmit the message.
> 
> An attempt was made to do this, but it was done after the call to
> cec_transmit_done, which can cause a race condition since the call
> to cec_transmit_done can cause a new transmit to be issued, and
> then attempting to clear the TX FIFO will actually clear the new
> transmit instead of the old transmit and the new transmit simply
> never happens.
> 
> By clearing the FIFO before transmit_done is called this race
> is fixed.
> 
> Note that there is no reason to clear the FIFO if the transmit
> was successful, so the attempt to clear the FIFO in that case
> was dropped.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c | 35 ++++++++++++-------------
>  1 file changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
> index 340383150fb9..dee66a5101b5 100644
> --- a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
> +++ b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
> @@ -106,6 +106,22 @@ static void hdmi_cec_received_msg(struct hdmi_core_data *core)
>  	}
>  }
>  
> +static bool hdmi_cec_clear_tx_fifo(struct cec_adapter *adap)
> +{
> +	struct hdmi_core_data *core = cec_get_drvdata(adap);
> +	int retry = HDMI_CORE_CEC_RETRY;
> +	int temp;
> +
> +	REG_FLD_MOD(core->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
> +	while (retry) {
> +		temp = hdmi_read_reg(core->base, HDMI_CEC_DBG_3);
> +		if (FLD_GET(temp, 7, 7) == 0)
> +			break;

This is fine, but as you're using the helper macros already, there's
REG_GET:

REG_GET(core->base, HDMI_CEC_DBG_3, 7, 7)

which removes the need for temp. Are you sure this works reliably?
Usually when polling a register bit, I like to measure real-world-time
in some way to ensure I actually poll for a certain amount of time.

And just a matter of opinion, but I would've written:

while (retry) {
	if (!REG_GET(..))
		return true;
	retry--;
}

return false;

> +		retry--;
> +	}
> +	return retry != 0;
> +}
> +
>  void hdmi4_cec_irq(struct hdmi_core_data *core)
>  {
>  	u32 stat0 = hdmi_read_reg(core->base, HDMI_CEC_INT_STATUS_0);
> @@ -117,36 +133,19 @@ void hdmi4_cec_irq(struct hdmi_core_data *core)
>  	if (stat0 & 0x20) {
>  		cec_transmit_done(core->adap, CEC_TX_STATUS_OK,
>  				  0, 0, 0, 0);
> -		REG_FLD_MOD(core->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
>  	} else if (stat1 & 0x02) {
>  		u32 dbg3 = hdmi_read_reg(core->base, HDMI_CEC_DBG_3);
>  
> +		hdmi_cec_clear_tx_fifo(core->adap);

Would a dev_err be ok here?

 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
