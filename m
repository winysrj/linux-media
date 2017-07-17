Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.160.12]:11516 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751093AbdGQEXL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 00:23:11 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 08ABC34CB
        for <linux-media@vger.kernel.org>; Sun, 16 Jul 2017 22:58:39 -0500 (CDT)
Subject: Re: [PATCH] st-delta: constify vb2_ops structures
To: Hugues FRUCHET <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20170706201423.GA7477@embeddedgus>
 <c5f76510-00e6-2a41-2ce3-b3836f2be9e6@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <d9274661-6ab0-5ce1-414d-e729b533b951@embeddedor.com>
Date: Sun, 16 Jul 2017 22:58:38 -0500
MIME-Version: 1.0
In-Reply-To: <c5f76510-00e6-2a41-2ce3-b3836f2be9e6@st.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you, Hugues.


On 07/07/2017 09:33 AM, Hugues FRUCHET wrote:
> Acked-by: Hugues Fruchet <hugues.fruchet@st.com>
>
> On 07/06/2017 10:14 PM, Gustavo A. R. Silva wrote:
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
>>    drivers/media/platform/sti/delta/delta-v4l2.c | 4 ++--
>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
>> index c6f2e24..ff9850e 100644
>> --- a/drivers/media/platform/sti/delta/delta-v4l2.c
>> +++ b/drivers/media/platform/sti/delta/delta-v4l2.c
>> @@ -1574,7 +1574,7 @@ static void delta_vb2_frame_stop_streaming(struct vb2_queue *q)
>>    }
>>    
>>    /* VB2 queue ops */
>> -static struct vb2_ops delta_vb2_au_ops = {
>> +static const struct vb2_ops delta_vb2_au_ops = {
>>    	.queue_setup = delta_vb2_au_queue_setup,
>>    	.buf_prepare = delta_vb2_au_prepare,
>>    	.buf_queue = delta_vb2_au_queue,
>> @@ -1584,7 +1584,7 @@ static struct vb2_ops delta_vb2_au_ops = {
>>    	.stop_streaming = delta_vb2_au_stop_streaming,
>>    };
>>    
>> -static struct vb2_ops delta_vb2_frame_ops = {
>> +static const struct vb2_ops delta_vb2_frame_ops = {
>>    	.queue_setup = delta_vb2_frame_queue_setup,
>>    	.buf_prepare = delta_vb2_frame_prepare,
>>    	.buf_finish = delta_vb2_frame_finish,

-- 
Gustavo A. R. Silva
