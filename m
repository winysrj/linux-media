Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.49.180]:19409 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751260AbdKVOVx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 09:21:53 -0500
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id E44EC52CEE
        for <linux-media@vger.kernel.org>; Wed, 22 Nov 2017 08:21:05 -0600 (CST)
Subject: Re: [PATCH] c8sectpfe: fix potential NULL pointer dereference in
 c8sectpfe_timer_interrupt
To: Patrice CHOTARD <patrice.chotard@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20171120140055.GA728@embeddedor.com>
 <dbd98a18-6d11-bc4e-de44-a04383bb3ade@st.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <88bb41ea-8973-0be4-fcdd-84f23c5d2117@embeddedor.com>
Date: Wed, 22 Nov 2017 08:21:04 -0600
MIME-Version: 1.0
In-Reply-To: <dbd98a18-6d11-bc4e-de44-a04383bb3ade@st.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 11/21/2017 02:22 AM, Patrice CHOTARD wrote:
> Hi Gustavo
>
> On 11/20/2017 03:00 PM, Gustavo A. R. Silva wrote:
>> _channel_ is being dereferenced before it is null checked, hence there is a
>> potential null pointer dereference. Fix this by moving the pointer dereference
>> after _channel_ has been null checked.
>>
>> This issue was detected with the help of Coccinelle.
>>
>> Fixes: c5f5d0f99794 ("[media] c8sectpfe: STiH407/10 Linux DVB demux support")
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>> ---
>>    drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 4 +++-
>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
>> index 59280ac..23d0ced 100644
>> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
>> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
>> @@ -83,7 +83,7 @@ static void c8sectpfe_timer_interrupt(unsigned long ac8sectpfei)
>>    static void channel_swdemux_tsklet(unsigned long data)
>>    {
>>    	struct channel_info *channel = (struct channel_info *)data;
>> -	struct c8sectpfei *fei = channel->fei;
>> +	struct c8sectpfei *fei;
>>    	unsigned long wp, rp;
>>    	int pos, num_packets, n, size;
>>    	u8 *buf;
>> @@ -91,6 +91,8 @@ static void channel_swdemux_tsklet(unsigned long data)
>>    	if (unlikely(!channel || !channel->irec))
>>    		return;
>>    
>> +	fei = channel->fei;
>> +
>>    	wp = readl(channel->irec + DMA_PRDS_BUSWP_TP(0));
>>    	rp = readl(channel->irec + DMA_PRDS_BUSRP_TP(0));
>>    
>>
> Acked-by: Patrice Chotard <patrice.chotard@st.com>
>
> Thanks

Thank you, Patrice.

--
Gustavo A. R. Silva
