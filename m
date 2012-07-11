Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33953 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2GKXoY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 19:44:24 -0400
Received: by weyx8 with SMTP id x8so1296559wey.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 16:44:23 -0700 (PDT)
Message-ID: <4FFE0FD3.7020604@gmail.com>
Date: Thu, 12 Jul 2012 01:44:19 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, sy0816.kang@samsung.com,
	s.nawrocki@samsung.com, posciak@google.com, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com, ameersk@gmail.com
Subject: Re: [PATCH v2 01/01] media: gscaler: Add new driver for generic scaler
References: <1341484061-10914-1-git-send-email-shaik.ameer@samsung.com> <1341484061-10914-2-git-send-email-shaik.ameer@samsung.com> <4FFE00B2.2040906@gmail.com>
In-Reply-To: <4FFE00B2.2040906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/12/2012 12:39 AM, Sylwester Nawrocki wrote:
>> +int gsc_hw_get_input_buf_mask_status(struct gsc_dev *dev)
>> +{
>> +	u32 cfg, status, bits = 0;
>> +
>> +	cfg = readl(dev->regs + GSC_IN_BASE_ADDR_Y_MASK);

	return hweight32(cfg & GSC_IN_BASE_ADDR_MASK);

>> +	status = cfg&   GSC_IN_BASE_ADDR_MASK;
>> +	while (status) {
>> +		status = status&   (status - 1);
>> +		bits++;
>> +	}
>> +	return bits;
>> +}
[...]
>> +
>> +int gsc_hw_get_nr_unmask_bits(struct gsc_dev *dev)
>> +{
>> +	u32 bits = 0;
>> +	u32 mask_bits = readl(dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
>
> Care to add an empty line? It might also look better to order
> declarations in decending line order.
>
>> +	mask_bits&= GSC_OUT_BASE_ADDR_MASK;
>> +
>> +	while (mask_bits) {
>> +		mask_bits = mask_bits&   (mask_bits - 1);
>> +		bits++;
>> +	}

It seems you are computing a Hamming weight here, then it could
be simplified to a built-in function:

	bits = hweight32(mask_bits);

But it's not quite clear to me, why you're subtracting it
from 16 ?

>> +	bits = 16 - bits;
>
> return 16 - bits;
>
>> +
>> +	return bits;
>> +}
