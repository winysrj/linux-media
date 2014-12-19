Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:50070 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbaLSLGR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 06:06:17 -0500
Message-ID: <549406A4.3090707@xs4all.nl>
Date: Fri, 19 Dec 2014 12:06:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Nikhil Devshatwar <nikhil.nd@ti.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] videobuf-dma-contig: NULL check for vb2_plane_cookie
References: <1418303242-8513-1-git-send-email-nikhil.nd@ti.com> <20141211145606.GS15559@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141211145606.GS15559@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nikhil,

On 12/11/2014 03:56 PM, Sakari Ailus wrote:
> Hi Nikhil,
> 
> On Thu, Dec 11, 2014 at 06:37:22PM +0530, Nikhil Devshatwar wrote:
>> vb2_plane_cookie can return NULL if the plane no is greater than
>> total no of planes or when mem_ops are absent.
>>
>> Add NULL check to avoid NULL pointer crash in the kernel.
>>
>> Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
>> ---
>>  include/media/videobuf2-dma-contig.h |    5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
>> index 8197f87..5efc56e 100644
>> --- a/include/media/videobuf2-dma-contig.h
>> +++ b/include/media/videobuf2-dma-contig.h
>> @@ -21,7 +21,10 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>>  {
>>  	dma_addr_t *addr = vb2_plane_cookie(vb, plane_no);
>>  
>> -	return *addr;
>> +	if (addr == NULL)
>> +		return addr;
>> +	else
>> +		return *addr;

How about:

	return addr ? *addr : NULL;

Much better.

>>  }
>>  
>>  void *vb2_dma_contig_init_ctx(struct device *dev);
> 
> Should this happen? Wouldn't it be a bug somewhere, quite possibly the driver?
> 

I agree with Sakari: could this ever happen in practice unless it is a driver bug?

If you can provide an example, then that would help.

Regards,

	Hans
