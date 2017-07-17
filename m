Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.102]:16467 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750715AbdGQEBR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 00:01:17 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 69E7A8620CA
        for <linux-media@vger.kernel.org>; Sun, 16 Jul 2017 23:01:17 -0500 (CDT)
Subject: Re: [PATCH] stm32-dcmi: constify vb2_ops structure
To: Hugues FRUCHET <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>
References: <20170706200517.GA5886@embeddedgus>
 <d6b36309-2152-a55e-f160-ed43fdc3791c@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <52e9bcd7-6a85-4200-4418-83e3de547643@embeddedor.com>
Date: Sun, 16 Jul 2017 23:01:16 -0500
MIME-Version: 1.0
In-Reply-To: <d6b36309-2152-a55e-f160-ed43fdc3791c@st.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 07/07/2017 09:33 AM, Hugues FRUCHET wrote:
> Acked-by: Hugues Fruchet <hugues.fruchet@st.com>

Thank you, Hugues.

> On 07/06/2017 10:05 PM, Gustavo A. R. Silva wrote:
>> Check for vb2_ops structures that are only stored in the ops field of a
>> vb2_queue structure. That field is declared const, so vb2_ops structures
>> that have this property can be declared as const also.
>>
>> This issue was detected using Coccinelle and the following semantic patch:
>>
>> @r disable optional_qualifier@
>> identifier i;
>> position p;
>> @@
>> static struct vb2_ops i@p = { ... };
>>
>> @ok@
>> identifier r.i;
>> struct vb2_queue e;
>> position p;
>> @@
>> e.ops = &i@p;
>>
>> @bad@
>> position p != {r.p,ok.p};
>> identifier r.i;
>> struct vb2_ops e;
>> @@
>> e@i@p
>>
>> @depends on !bad disable optional_qualifier@
>> identifier r.i;
>> @@
>> static
>> +const
>> struct vb2_ops i = { ... };
>>
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>> ---
>>    drivers/media/platform/stm32/stm32-dcmi.c | 2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
>> index 83d32a5..24ef888 100644
>> --- a/drivers/media/platform/stm32/stm32-dcmi.c
>> +++ b/drivers/media/platform/stm32/stm32-dcmi.c
>> @@ -662,7 +662,7 @@ static void dcmi_stop_streaming(struct vb2_queue *vq)
>>    		dcmi->errors_count, dcmi->buffers_count);
>>    }
>>    
>> -static struct vb2_ops dcmi_video_qops = {
>> +static const struct vb2_ops dcmi_video_qops = {
>>    	.queue_setup		= dcmi_queue_setup,
>>    	.buf_init		= dcmi_buf_init,
>>    	.buf_prepare		= dcmi_buf_prepare,

-- 
Gustavo A. R. Silva
