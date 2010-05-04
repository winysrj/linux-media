Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428Ab0EDS0P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 May 2010 14:26:15 -0400
Message-ID: <4BE066B7.2050704@redhat.com>
Date: Tue, 04 May 2010 15:25:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 calculating urb buffer
References: <4BDB067E.4070501@arcor.de> <4BDB3017.9070101@arcor.de> <4BE03F8D.1050905@arcor.de>
In-Reply-To: <4BE03F8D.1050905@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

Stefan Ringel wrote:
> Am 30.04.2010 21:31, schrieb Stefan Ringel:
>> Am 30.04.2010 18:34, schrieb Stefan Ringel:
>>   
>>> Hi Mauro,
>>>
>>> Today I'm writing directly to you, because it doesn't work the mailing
>>> list. I thought over the calculating urb buffer and I have follow idea:
>>>
>>> buffer = endpoint fifo size (3072 Bytes) * block size (184 Bytes)
>>>
>>> The actually calculating is a video frame size (image = width * hight *
>>> 2 Bytes/Pixel), so that this buffer has to begin and to end an
>>> uncomplete block. followed blocks are setting the logic to an err_mgs
>>> block, so that going to lost frames.
>>>
>>>   
>>>     
>> I forgot a log with old calculating.
>>
>>   
> 
> 
> 
> datagram from urb to videobuf
> 
> urb           copy to     temp         copy to         1. videobuf
>                          buffer                        2. audiobuf
>                                                        3. vbi
> 184 Packets   ------->   184 * 3072    ---------->     4. etc.
> a 3072 bytes               bytes
>                184 *                   3072 *
>              3072 bytes              180 bytes
>                                 (184 bytes - 4 bytes
>                                     header )

In order to receive 184 packets with 3072 bytes each, the USB code will
try to allocate the next power-of-two memory block capable of receiving
such data block. As: 184 * 3072 = 565248, the kernel allocator will seek
for a continuous block of 1 MB, that can do DMA transfers (required by
ehci driver). On a typical machine, due to memory fragmentation,
in general, there aren't many of such blocks. So, this will increase the
probability of not having any such large block available, causing an horrible
dump at kernel, plus a -ENOMEM on the driver, generally requiring a reboot
if you want to run the driver again.

>                                     
>
> step 1
> 
> copy from urb to temp buffer

Why do you want to do triple buffering? This is a very bad idea.
If you do it at the wrong way, by handling the copy at interrupt time, 
you're eating more power (and batteries, on notebooks), and reducing 
the machine speed. If you split it into two halves, you'll need a larger 
buffer area, since kernel will eventually join a few consecutive workqueue tasks
into one, to avoid damaging other kernel process. Also, it will risk loosing
frames or introduce a high delay. 

It is already bad enough to have a double buffering with those usb devices. 
Just as an example, the last time I've measured em28xx driver performance, 
after doing lots of optimization at the code, it were still consuming 
about 30% of CPU time of the machine I used for test (a typical 
mono-core Intel CPU). 

I know that the code would be simpler if we use a temporary buffer,
but this way, we save CPU time. Also, if we do triple buffering, you'll
likely add some delay when syncing between audio and video, due to
the workqueue time.

So, in summary, what we need to do is to validate the code and simplify
it to be faster. If you take a look at tm6000-video.c, you'll see that I've
tried already some different approaches. The one that is currently working
is the first approach I did. As the newer solutions didn't solve the loss
of data, but introduced newer bugs, I did a rollback to the code. At the time
I stopped working on tm6000, I was about to write a new (simpler) approach,
but still avoiding the double buffering.

> 
> snip
> ----
> for (i = 0; i < urb->number_of_packets; i++) {
> 	int status = urb->iso_frame_desc[i].status;
> 	
> 	if (status<0) {
> 		print_err_status (dev,i,status);
> 		continue;
> 	}
> 
> 	len=urb->iso_frame_desc[i].actual_length;
> 
> 	memcpy (t_buf[i*len], urb->transfer_buffer[i*len], len);
> 	copied += len;
> 	if (copied >= size || !buf)
> 		break;
> 
> }
> 
> if (!urb->iso_frame_desc[i].status) {
> 	if ((buf->fmt->fourcc)==V4L2_PIX_FMT_TM6000) {
> 		rc=copy_multiplexed(t_buf, outp, len, urb, &buf);

copy_multiplexed() is about what you want: It just copies everything
(except for the URB headers), into a buffer, allowing decoding the
data on userspace. There's an userspace application that gets those
data, at v4l-utils tree. With this approach, you may add a decoder
at libv4l for TM6000 format, and let userspace to do the audio/video/TS
decoding.

> 		if (rc<=0)
> 			return rc;
> 	} else {
> 		copy_streams(t_buf, outp, len, urb, &buf);
> 	}
> }
> ---
> snip
> 
> step 2
> 
> copy from temp buffer into videobuffer
> 
> snip
> ---
> 
> for (i=0;i<3072;i++) {

Doesn't work: nothing warrants that the device will start with a frame.

> 	switch(cmd) {
> 		case TM6000_URB_MSG_VIDEO:
> 			/* Fills video buffer */
> 			memcpy(&out_p[(line << 1 + field) * block * 180],
> 				ptr[(i*184)+4], 180);
> 			printk (KERN_INFO "cmd=%s, size=%d\n",
> 			tm6000_msg_type[cmd],size);
> 			break;
> 		case TM6000_URB_MSG_PTS:
> 			printk (KERN_INFO "cmd=%s, size=%d\n",
> 			tm6000_msg_type[cmd],size);
> 			break;
> 		case TM6000_URB_MSG_AUDIO:
> 			/* Need some code to process audio */
> 			printk ("%ld: cmd=%s, size=%d\n", jiffies,
> 			tm6000_msg_type[cmd],size);
> 			break;
> 		default:
> 			dprintk (dev, V4L2_DEBUG_ISOC, "cmd=%s, size=%d\n",
> 			printk (KERN_INFO "cmd=%s, size=%d\n",
> 			tm6000_msg_type[cmd],size);
> 		}
> 	}
> }
> 
> ---
> snip
> 
> This is a schemata to copy in videobuf.
> 
> temp_buf = fifo size * block size
> 
> viodeobuf = hight * wight * 2
> 
> 
> Questions
> 
> 1. Is it right if I copy the block without header to videobufer?
> 2. Can I full the videobuffer have more temp_bufs?
> 3. How are the actually data schema from urb to videobuffer?


-- 

Cheers,
Mauro
