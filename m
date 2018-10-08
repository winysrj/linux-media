Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllv0016.ext.ti.com ([198.47.19.142]:51904 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbeJHT7Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 15:59:25 -0400
Subject: Re: [PATCH 5/5] omapdrm/dss/hdmi4_cec.c: don't set the retransmit
 count
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
CC: <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20181004090900.32915-1-hverkuil@xs4all.nl>
 <20181004090900.32915-6-hverkuil@xs4all.nl>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <7b609cdf-ff95-f32c-8431-59f04f87de56@ti.com>
Date: Mon, 8 Oct 2018 15:47:49 +0300
MIME-Version: 1.0
In-Reply-To: <20181004090900.32915-6-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/18 12:09, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The HDMI_CEC_DBG_3 register does have a retransmit count, but you
> can't write to it, those bits are read-only.
> 
> So drop the attempt to set the retransmit count, since it doesn't
> work.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
> index dee66a5101b5..00407f1995a8 100644
> --- a/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
> +++ b/drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
> @@ -280,9 +280,6 @@ static int hdmi_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
>  	hdmi_write_reg(core->base, HDMI_CEC_INT_STATUS_1,
>  		       HDMI_CEC_RETRANSMIT_CNT_INT_MASK);
>  
> -	/* Set the retry count */
> -	REG_FLD_MOD(core->base, HDMI_CEC_DBG_3, attempts - 1, 6, 4);
> -

I presume there's no harm in having a different retry count in the HW
than what was requested via the API?

Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
