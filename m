Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:51298 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdFPPxD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 11:53:03 -0400
Subject: Re: [PATCH v2 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <cover.1497607315.git.joabreu@synopsys.com>
 <b4e209f41cc25285eb547cbd65f8fc6bf2a039cb.1497607315.git.joabreu@synopsys.com>
 <25d20060-f6b7-3a37-0509-39a734e6660a@xs4all.nl>
 <3a1abd40-4503-44f1-7cc5-ad757a7c5572@synopsys.com>
 <0ebac69e-8de3-e65e-d6f5-dfb4fed3585c@xs4all.nl>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <900bfa50-2cc3-2b33-8531-2c65ebd3a981@synopsys.com>
Date: Fri, 16 Jun 2017 16:52:57 +0100
MIME-Version: 1.0
In-Reply-To: <0ebac69e-8de3-e65e-d6f5-dfb4fed3585c@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 16-06-2017 14:44, Hans Verkuil wrote:
>
>>> <snip>
>>>
>>>> +	/* CEC */
>>>> +	dw_dev->cec_adap = cec_allocate_adapter(&dw_hdmi_cec_adap_ops,
>>>> +			dw_dev, dev_name(dev), CEC_CAP_TRANSMIT |
>>>> +			CEC_CAP_PHYS_ADDR | CEC_CAP_LOG_ADDRS,
>>> Add CEC_CAP_RC and CEC_CAP_PASSTHROUGH.
>>>
>>> I'm not sure about CEC_CAP_PHYS_ADDR. The problem here is that this driver
>>> doesn't handle the EDID, but without that it doesn't know what physical
>>> address to use.
>>>
>>> I wonder if the cec-notifier can be used for this, possibly with adaptations.
>>> Relying on users to set the physical address is a last resort since it is very
>>> painful to do so. cec-notifier was specifically designed to solve this.
>> Yes, EDID ROM is not integrated into the controller so I can't
>> add the code. How exactly can I use cec-notifier here?
> drivers/media/platform/sti/cec/stih-cec.c is a good example. The notifier is
> called by drivers/gpu/drm/sti/sti_hdmi.c.

Done! Implemented and working :) I'm wondering if you want me to
wait some more time for other comments or just send the v3 now? I
also added support for SCDC read request (its a matter of
activating a bit).

BTW, I used the DT node name "hdmi-phandle" but I don't know if
it is the best because it can cause confusion about the
hdmi-phandle that you documented in media/cec.txt

Best regards,
Jose Miguel Abreu

>
> Regards,
>
> 	Hans
>
