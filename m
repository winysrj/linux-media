Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:56167 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751534AbeCMTW7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 15:22:59 -0400
Subject: Re: [PATCH] media: dvb-usb-v2: stop using coherent memory for URBs
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <6a131c6ca8afe5d000b9cbfadff96ea72f200852.1520536139.git.mchehab@s-opensource.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <28084fba-62ba-6f1a-28fb-1aabbb92d4e5@iki.fi>
Date: Tue, 13 Mar 2018 21:22:55 +0200
MIME-Version: 1.0
In-Reply-To: <6a131c6ca8afe5d000b9cbfadff96ea72f200852.1520536139.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/2018 09:09 PM, Mauro Carvalho Chehab wrote:
> There's no need to use coherent buffers there. So, let the
> DVB core do the allocation. That should give some performance
> gain outside x86.

Hello! I am not familiar with that change, but I think you know what you 
do. Feel free to apply!

regards
Antti


> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>   drivers/media/usb/dvb-usb-v2/usb_urb.c | 17 ++++-------------
>   1 file changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/usb_urb.c b/drivers/media/usb/dvb-usb-v2/usb_urb.c
> index dce2b97efce4..b0499f95ec45 100644
> --- a/drivers/media/usb/dvb-usb-v2/usb_urb.c
> +++ b/drivers/media/usb/dvb-usb-v2/usb_urb.c
> @@ -155,8 +155,7 @@ static int usb_urb_alloc_bulk_urbs(struct usb_data_stream *stream)
>   				stream->props.u.bulk.buffersize,
>   				usb_urb_complete, stream);
>   
> -		stream->urb_list[i]->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
> -		stream->urb_list[i]->transfer_dma = stream->dma_addr[i];
> +		stream->urb_list[i]->transfer_flags = URB_FREE_BUFFER;
>   		stream->urbs_initialized++;
>   	}
>   	return 0;
> @@ -187,13 +186,12 @@ static int usb_urb_alloc_isoc_urbs(struct usb_data_stream *stream)
>   		urb->complete = usb_urb_complete;
>   		urb->pipe = usb_rcvisocpipe(stream->udev,
>   				stream->props.endpoint);
> -		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
> +		urb->transfer_flags = URB_ISO_ASAP | URB_FREE_BUFFER;
>   		urb->interval = stream->props.u.isoc.interval;
>   		urb->number_of_packets = stream->props.u.isoc.framesperurb;
>   		urb->transfer_buffer_length = stream->props.u.isoc.framesize *
>   				stream->props.u.isoc.framesperurb;
>   		urb->transfer_buffer = stream->buf_list[i];
> -		urb->transfer_dma = stream->dma_addr[i];
>   
>   		for (j = 0; j < stream->props.u.isoc.framesperurb; j++) {
>   			urb->iso_frame_desc[j].offset = frame_offset;
> @@ -212,11 +210,7 @@ static int usb_free_stream_buffers(struct usb_data_stream *stream)
>   	if (stream->state & USB_STATE_URB_BUF) {
>   		while (stream->buf_num) {
>   			stream->buf_num--;
> -			dev_dbg(&stream->udev->dev, "%s: free buf=%d\n",
> -				__func__, stream->buf_num);
> -			usb_free_coherent(stream->udev, stream->buf_size,
> -					  stream->buf_list[stream->buf_num],
> -					  stream->dma_addr[stream->buf_num]);
> +			stream->buf_list[stream->buf_num] = NULL;
>   		}
>   	}
>   
> @@ -236,9 +230,7 @@ static int usb_alloc_stream_buffers(struct usb_data_stream *stream, int num,
>   			__func__,  num * size);
>   
>   	for (stream->buf_num = 0; stream->buf_num < num; stream->buf_num++) {
> -		stream->buf_list[stream->buf_num] = usb_alloc_coherent(
> -				stream->udev, size, GFP_ATOMIC,
> -				&stream->dma_addr[stream->buf_num]);
> +		stream->buf_list[stream->buf_num] = kzalloc(size, GFP_ATOMIC);
>   		if (!stream->buf_list[stream->buf_num]) {
>   			dev_dbg(&stream->udev->dev, "%s: alloc buf=%d failed\n",
>   					__func__, stream->buf_num);
> @@ -250,7 +242,6 @@ static int usb_alloc_stream_buffers(struct usb_data_stream *stream, int num,
>   				__func__, stream->buf_num,
>   				stream->buf_list[stream->buf_num],
>   				(long long)stream->dma_addr[stream->buf_num]);
> -		memset(stream->buf_list[stream->buf_num], 0, size);
>   		stream->state |= USB_STATE_URB_BUF;
>   	}
>   
> 

-- 
http://palosaari.fi/
