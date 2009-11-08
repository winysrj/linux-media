Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:57489 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbZKHUsn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 15:48:43 -0500
Message-ID: <4AF72EB1.1040404@web.de>
Date: Sun, 08 Nov 2009 21:48:49 +0100
From: Johann Friedrichs <johann.friedrichs@web.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: e9hack <e9hack@googlemail.com>, linux-media@vger.kernel.org,
	hunold@linuxtv.org
Subject: Re: bug in changeset 13239:54535665f94b ?
References: <4AEDB05E.1090704@googlemail.com> <20091107104113.0df4593b@pedra.chehab.org>
In-Reply-To: <20091107104113.0df4593b@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab schrieb:
> Hi Hartmut,
> 
> Em Sun, 01 Nov 2009 16:59:26 +0100
> e9hack <e9hack@googlemail.com> escreveu:
> 
>> Hi,
>>
>> something is wrong in changeset 13239:54535665f94b. After applying it, I get page faults
>> in various applications:
>> ...
>>
>> If I remove the call to release_all_pagetables() in buffer_release(), I don't see this
>> page faults.
> 
> 
> Em Mon, 2 Nov 2009 21:27:44 +0100
> e9hack@googlemail.com escreveu:
> 
>> the BUG is in vidioc_streamoff() for the saa7146. This function
>> releases all buffers first, and stops the capturing and dma tranfer of
>> the saa7146 as second. If the page table, which is currently used by
>> the saa7146, is modified by another thread, the saa7146 writes
>> anywhere to the physical RAM. IMHO vidioc_streamoff() must stop the
>> saa7146 first and may then release the buffers.
> 
> I agree. We need first to stop DMA activity, and then release the page tables.
> 
> Could you please test if the enclosed patch fixes the issue?
> 
> Cheers,
> Mauro
> 
> saa7146: stop DMA before de-allocating DMA scatter/gather page buffers
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/linux/drivers/media/common/saa7146_video.c b/linux/drivers/media/common/saa7146_video.c
> --- a/linux/drivers/media/common/saa7146_video.c
> +++ b/linux/drivers/media/common/saa7146_video.c
> @@ -1334,9 +1334,9 @@ static void buffer_release(struct videob
>  
>  	DEB_CAP(("vbuf:%p\n",vb));
>  
> +	saa7146_dma_free(dev,q,buf);
> +
>  	release_all_pagetables(dev, buf);
> -
> -	saa7146_dma_free(dev,q,buf);
>  }
>  
>  static struct videobuf_queue_ops video_qops = {
> 
Hi Mauro,
I cannot easily catch any memory overwriting done by 
saa7146-capture-dma, but Hartmut is right that there is quite a chance.
I would prefer calling video_end() before videobuf_streamoff() in 
vidioc_streamoff(), because this physically shuts down the capture 
immediately at the hardware source. By the way, this is done in the same 
sequence in video_close, where videobuf_stop (which calls 
videobuf_streamoff) also gets called after video_end.
I have no negative impact with your patch and it might shutdown the dma 
as well, but as said before, I don't see any immediate errors even with 
the released version.
Cheers
Johann
