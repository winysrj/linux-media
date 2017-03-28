Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:33680 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932176AbdC1Nel (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 09:34:41 -0400
Received: by mail-wr0-f174.google.com with SMTP id w43so91097598wrb.0
        for <linux-media@vger.kernel.org>; Tue, 28 Mar 2017 06:34:40 -0700 (PDT)
Subject: Re: [PATCH v4 1/6] drm: bridge: dw-hdmi: Extract PHY interrupt setup
 to a function
To: Jose Abreu <Jose.Abreu@synopsys.com>,
        dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org
References: <1490109161-20529-1-git-send-email-narmstrong@baylibre.com>
 <1490109161-20529-2-git-send-email-narmstrong@baylibre.com>
 <b8b3caca-d086-b390-a2fc-ef998e61e755@synopsys.com>
Cc: kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <98e06589-8eb3-e7b8-646a-8099f1de51b0@baylibre.com>
Date: Tue, 28 Mar 2017 15:34:17 +0200
MIME-Version: 1.0
In-Reply-To: <b8b3caca-d086-b390-a2fc-ef998e61e755@synopsys.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/22/2017 02:53 PM, Jose Abreu wrote:
> Hi Neil,
> 
> 
> On 21-03-2017 15:12, Neil Armstrong wrote:
>> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>>
>> In preparation for adding PHY operations to handle RX SENSE and HPD,
>> group all the PHY interrupt setup code in a single location and extract
>> it to a separate function.
>>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> 
> Reviewed-by: Jose Abreu <joabreu@synopsys.com>
> 
> Maybe if you submit a next version we could get rid of
> "dw_hdmi_fb_registered" totally and move the remaining setup code
> to a new "dw_hdmi_setup_i2c" function.

Ok I'll do this,

Neil
> 
> Best regards,
> Jose Miguel Abreu
> 
>> ---
>>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 50 ++++++++++++++-----------------
>>  1 file changed, 23 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
>> index af93f7a..f82750a 100644
>> --- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
>> +++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
>> @@ -1559,7 +1559,7 @@ static int dw_hdmi_setup(struct dw_hdmi *hdmi, struct drm_display_mode *mode)
>>  }
>>  
>>  /* Wait until we are registered to enable interrupts */
>> -static int dw_hdmi_fb_registered(struct dw_hdmi *hdmi)
>> +static void dw_hdmi_fb_registered(struct dw_hdmi *hdmi)
>>  {
>>  	hdmi_writeb(hdmi, HDMI_PHY_I2CM_INT_ADDR_DONE_POL,
>>  		    HDMI_PHY_I2CM_INT_ADDR);
>> @@ -1567,15 +1567,6 @@ static int dw_hdmi_fb_registered(struct dw_hdmi *hdmi)
>>  	hdmi_writeb(hdmi, HDMI_PHY_I2CM_CTLINT_ADDR_NAC_POL |
>>  		    HDMI_PHY_I2CM_CTLINT_ADDR_ARBITRATION_POL,
>>  		    HDMI_PHY_I2CM_CTLINT_ADDR);
>> -
>> -	/* enable cable hot plug irq */
>> -	hdmi_writeb(hdmi, hdmi->phy_mask, HDMI_PHY_MASK0);
>> -
>> -	/* Clear Hotplug interrupts */
>> -	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE,
>> -		    HDMI_IH_PHY_STAT0);
>> -
>> -	return 0;
>>  }
>>  
>>  static void initialize_hdmi_ih_mutes(struct dw_hdmi *hdmi)
>> @@ -1693,6 +1684,26 @@ static void dw_hdmi_update_phy_mask(struct dw_hdmi *hdmi)
>>  		hdmi_writeb(hdmi, hdmi->phy_mask, HDMI_PHY_MASK0);
>>  }
>>  
>> +static void dw_hdmi_phy_setup_hpd(struct dw_hdmi *hdmi)
>> +{
>> +	/*
>> +	 * Configure the PHY RX SENSE and HPD interrupts polarities and clear
>> +	 * any pending interrupt.
>> +	 */
>> +	hdmi_writeb(hdmi, HDMI_PHY_HPD | HDMI_PHY_RX_SENSE, HDMI_PHY_POL0);
>> +	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE,
>> +		    HDMI_IH_PHY_STAT0);
>> +
>> +	/* Enable cable hot plug irq. */
>> +	hdmi_writeb(hdmi, hdmi->phy_mask, HDMI_PHY_MASK0);
>> +
>> +	/* Clear and unmute interrupts. */
>> +	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE,
>> +		    HDMI_IH_PHY_STAT0);
>> +	hdmi_writeb(hdmi, ~(HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE),
>> +		    HDMI_IH_MUTE_PHY_STAT0);
>> +}
>> +
>>  static enum drm_connector_status
>>  dw_hdmi_connector_detect(struct drm_connector *connector, bool force)
>>  {
>> @@ -2204,29 +2215,14 @@ static int dw_hdmi_detect_phy(struct dw_hdmi *hdmi)
>>  			hdmi->ddc = NULL;
>>  	}
>>  
>> -	/*
>> -	 * Configure registers related to HDMI interrupt
>> -	 * generation before registering IRQ.
>> -	 */
>> -	hdmi_writeb(hdmi, HDMI_PHY_HPD | HDMI_PHY_RX_SENSE, HDMI_PHY_POL0);
>> -
>> -	/* Clear Hotplug interrupts */
>> -	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE,
>> -		    HDMI_IH_PHY_STAT0);
>> -
>>  	hdmi->bridge.driver_private = hdmi;
>>  	hdmi->bridge.funcs = &dw_hdmi_bridge_funcs;
>>  #ifdef CONFIG_OF
>>  	hdmi->bridge.of_node = pdev->dev.of_node;
>>  #endif
>>  
>> -	ret = dw_hdmi_fb_registered(hdmi);
>> -	if (ret)
>> -		goto err_iahb;
>> -
>> -	/* Unmute interrupts */
>> -	hdmi_writeb(hdmi, ~(HDMI_IH_PHY_STAT0_HPD | HDMI_IH_PHY_STAT0_RX_SENSE),
>> -		    HDMI_IH_MUTE_PHY_STAT0);
>> +	dw_hdmi_fb_registered(hdmi);
>> +	dw_hdmi_phy_setup_hpd(hdmi);
>>  
>>  	memset(&pdevinfo, 0, sizeof(pdevinfo));
>>  	pdevinfo.parent = dev;
> 
