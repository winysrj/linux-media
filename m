Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38968 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab0EGCaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 22:30:17 -0400
Message-ID: <4BE37B31.5030907@infradead.org>
Date: Thu, 06 May 2010 23:30:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: wharms@bfs.de
CC: Dan Carpenter <error27@gmail.com>, Adams.xu@azwave.com.cn,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch -next 1/2] media/az6027: doing dma on the stack
References: <20100504121429.GW29093@bicker> <4BE02F66.8060300@bfs.de>
In-Reply-To: <4BE02F66.8060300@bfs.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

walter harms wrote:
> 
> Dan Carpenter schrieb:
>> I changed the dma buffers to use allocated memory instead of stack
>> memory.
>>
>> The reason for this is documented in Documentation/DMA-API-HOWTO.txt
>> under the section:  "What memory is DMA'able?"  That document was only
>> added a couple weeks ago and there are still lots of modules which
>> haven't been corrected yet.  Btw. Smatch includes a pretty good test to
>> find places which use stack memory as a dma buffer.  That's how I found
>> these.  (http://smatch.sf.net).
>>
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>>
>> diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
>> index 8934788..baaa301 100644
>> --- a/drivers/media/dvb/dvb-usb/az6027.c
>> +++ b/drivers/media/dvb/dvb-usb/az6027.c
>> @@ -417,11 +417,15 @@ static int az6027_ci_read_attribute_mem(struct dvb_ca_en50221 *ca,
>>  	u16 value;
>>  	u16 index;
>>  	int blen;
>> -	u8 b[12];
>> +	u8 *b;
>>  
>>  	if (slot != 0)
>>  		return -EINVAL;
>>  
>> +	b = kmalloc(12, GFP_KERNEL);
>> +	if (!b)
>> +		return -ENOMEM;
>> +
>>  	mutex_lock(&state->ca_mutex);
>>  
>>  	req = 0xC1;
> 
> 
> Hi Dan,
> i am not sure if that is the way to go.
> iff i understand the code correctly the b[12] seems to overcommit  only
> blen bytes (not 12) is needed. There must be a cheaper way to send a few bytes
> of space to send a command to a device. Perhaps gregKH has a hint ?

There is: you can add an array on a device private structure to hold
those memory transfers. For now, I'll add this patch, as it corrects
a real bug.

Cheers,
Mauro
