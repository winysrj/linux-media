Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:37096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab0JGPrH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 11:47:07 -0400
Message-ID: <4CADEB76.1030601@redhat.com>
Date: Thu, 07 Oct 2010 12:47:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] V4L/DVB: videobuf-dma-sg: Use min_t(size_t, PAGE_SIZE
 ..)
References: <20101007094543.47b77328@pedra> <201010071546.30191.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201010071546.30191.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-10-2010 10:46, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Thursday 07 October 2010 14:45:43 Mauro Carvalho Chehab wrote:
>> As pointed by Laurent:
>>
>> I think min_t(size_t, PAGE_SIZE, size) is the preferred way.
>>
>> Thanks-to: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/video/videobuf-dma-sg.c
>> b/drivers/media/video/videobuf-dma-sg.c index 7153e44..20f227e 100644
>> --- a/drivers/media/video/videobuf-dma-sg.c
>> +++ b/drivers/media/video/videobuf-dma-sg.c
>> @@ -116,8 +116,8 @@ static struct scatterlist *videobuf_pages_to_sg(struct
>> page **pages, goto nopage;
>>  		if (PageHighMem(pages[i]))
>>  			goto highmem;
>> -		sg_set_page(&sglist[i], pages[i], min((unsigned)PAGE_SIZE, size), 0);
>> -		size -= min((unsigned)PAGE_SIZE, size);
>> +		sg_set_page(&sglist[i], pages[i], min_t(size_t, PAGE_SIZE, size), 0);
> 
> This won't pass checkpatch.pl (line > 80 characters long).

Yes, but the 80 char-long is not a hard limit. In this case, it seemed better to just
have a longer line.

> Beside, this patch applies on top of the previous one whereas I suppose you'd 
> want to replace the previous one.

I'll eventually merge the two patches when sending upstream.

>> +		size -= min_t(size_t, PAGE_SIZE, size);
>>  	}
>>  	return sglist;
> 

Cheers,
Mauro.
