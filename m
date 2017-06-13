Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:38691 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752456AbdFMKyU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 06:54:20 -0400
Subject: Re: [PATCH 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Hans Verkuil <hansverk@cisco.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1497347657.git.joabreu@synopsys.com>
 <22ea8b160edaef464d7f5ad362b23a68a6e07633.1497347657.git.joabreu@synopsys.com>
 <e1fb1420-28b1-c5ba-230e-3f1c3f9dfee0@synopsys.com>
 <c8d726a6-ebf2-cf05-2c30-62aae1b51304@cisco.com>
Cc: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5d374038-7a10-ebec-9d84-bfa3e07b3fe5@xs4all.nl>
Date: Tue, 13 Jun 2017 12:54:13 +0200
MIME-Version: 1.0
In-Reply-To: <c8d726a6-ebf2-cf05-2c30-62aae1b51304@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/17 12:31, Hans Verkuil wrote:
> On 06/13/17 12:06, Jose Abreu wrote:
>> Hi Hans,
>>
>>
>> On 13-06-2017 11:01, Jose Abreu wrote:
>>
>> [snip]
>>> Changes from RFC:
>>> 	- Added support for HDCP 1.4
>>
>> [snip]
>>> +
>>> +/* HDCP 1.4 */
>>> +#define DW_HDMI_HDCP14_BKSV_SIZE	2
>>> +#define DW_HDMI_HDCP14_KEYS_SIZE	(2 * 40)
>>> +
>>> +struct dw_hdmi_hdcp14_key {
>>> +	u32 seed;
>>> +	u32 bksv[DW_HDMI_HDCP14_BKSV_SIZE];
>>> +	u32 keys[DW_HDMI_HDCP14_KEYS_SIZE];
>>> +	bool keys_valid;
>>> +};
>>> +
>>> +struct dw_hdmi_rx_pdata {
>>> +	/* Controller configuration */
>>> +	unsigned int iref_clk; /* MHz */
>>> +	struct dw_hdmi_hdcp14_key hdcp14_keys;
>>> +	/* 5V sense interface */
>>> +	bool (*dw_5v_status)(void __iomem *regs, int input);
>>> +	void (*dw_5v_clear)(void __iomem *regs);
>>> +	void __iomem *dw_5v_arg;
>>> +	/* Zcal interface */
>>> +	void (*dw_zcal_reset)(void __iomem *regs);
>>> +	bool (*dw_zcal_done)(void __iomem *regs);
>>> +	void __iomem *dw_zcal_arg;
>>> +};
>>> +
>>> +#endif /* __DW_HDMI_RX_PDATA_H__ */
>>
>> I now have support for HDCP 1.4 in this driver. Can you send me
>> the patches about HDCP that you mentioned a while ago?
> 
> This is what I have:
> 
> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=hdcp
> 
> This is very old and somewhat messy.
> 
> It uses ioctls for the bksv's, but I wonder if array/compound controls
> wouldn't be more appropriate (those didn't exist when this was written
> originally).
> 
> It also needs to be checked against HDCP 2 so it can support that as well

That's HDCP 2.2, of course.

> (or at least be easily extended for that).

Just a follow-up: I would really appreciated it if someone (you?) could get
this finalized. The code in the branch above worked for us, but was never
actually used in any product. It was internal test code only. It also is
HDCP 1.4 only.

For a proper API we should think about HDCP 1.4 and 2.2 support, and also
look at how this works for DisplayPort. Hmm, looks like DP supports HDCP 1.3
and 2.2. I'm not sure what the differences are (if any) between 1.3 and 1.4.

Regards,

	Hans
