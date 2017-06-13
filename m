Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:50757 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752956AbdFMKbO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 06:31:14 -0400
Subject: Re: [PATCH 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1497347657.git.joabreu@synopsys.com>
 <22ea8b160edaef464d7f5ad362b23a68a6e07633.1497347657.git.joabreu@synopsys.com>
 <e1fb1420-28b1-c5ba-230e-3f1c3f9dfee0@synopsys.com>
Cc: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <c8d726a6-ebf2-cf05-2c30-62aae1b51304@cisco.com>
Date: Tue, 13 Jun 2017 12:31:11 +0200
MIME-Version: 1.0
In-Reply-To: <e1fb1420-28b1-c5ba-230e-3f1c3f9dfee0@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/17 12:06, Jose Abreu wrote:
> Hi Hans,
> 
> 
> On 13-06-2017 11:01, Jose Abreu wrote:
> 
> [snip]
>> Changes from RFC:
>> 	- Added support for HDCP 1.4
> 
> [snip]
>> +
>> +/* HDCP 1.4 */
>> +#define DW_HDMI_HDCP14_BKSV_SIZE	2
>> +#define DW_HDMI_HDCP14_KEYS_SIZE	(2 * 40)
>> +
>> +struct dw_hdmi_hdcp14_key {
>> +	u32 seed;
>> +	u32 bksv[DW_HDMI_HDCP14_BKSV_SIZE];
>> +	u32 keys[DW_HDMI_HDCP14_KEYS_SIZE];
>> +	bool keys_valid;
>> +};
>> +
>> +struct dw_hdmi_rx_pdata {
>> +	/* Controller configuration */
>> +	unsigned int iref_clk; /* MHz */
>> +	struct dw_hdmi_hdcp14_key hdcp14_keys;
>> +	/* 5V sense interface */
>> +	bool (*dw_5v_status)(void __iomem *regs, int input);
>> +	void (*dw_5v_clear)(void __iomem *regs);
>> +	void __iomem *dw_5v_arg;
>> +	/* Zcal interface */
>> +	void (*dw_zcal_reset)(void __iomem *regs);
>> +	bool (*dw_zcal_done)(void __iomem *regs);
>> +	void __iomem *dw_zcal_arg;
>> +};
>> +
>> +#endif /* __DW_HDMI_RX_PDATA_H__ */
> 
> I now have support for HDCP 1.4 in this driver. Can you send me
> the patches about HDCP that you mentioned a while ago?

This is what I have:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=hdcp

This is very old and somewhat messy.

It uses ioctls for the bksv's, but I wonder if array/compound controls
wouldn't be more appropriate (those didn't exist when this was written
originally).

It also needs to be checked against HDCP 2 so it can support that as well
(or at least be easily extended for that).

Regards,

	Hans
