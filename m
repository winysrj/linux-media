Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:49635 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933068Ab0EDPk2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 May 2010 11:40:28 -0400
Message-ID: <4BE03F8D.1050905@arcor.de>
Date: Tue, 04 May 2010 17:38:53 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 calculating urb buffer
References: <4BDB067E.4070501@arcor.de> <4BDB3017.9070101@arcor.de>
In-Reply-To: <4BDB3017.9070101@arcor.de>
Content-Type: multipart/mixed;
 boundary="------------030209060503070904090007"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030209060503070904090007
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Am 30.04.2010 21:31, schrieb Stefan Ringel:
> Am 30.04.2010 18:34, schrieb Stefan Ringel:
>   
>> Hi Mauro,
>>
>> Today I'm writing directly to you, because it doesn't work the mailing
>> list. I thought over the calculating urb buffer and I have follow idea:
>>
>> buffer = endpoint fifo size (3072 Bytes) * block size (184 Bytes)
>>
>> The actually calculating is a video frame size (image = width * hight *
>> 2 Bytes/Pixel), so that this buffer has to begin and to end an
>> uncomplete block. followed blocks are setting the logic to an err_mgs
>> block, so that going to lost frames.
>>
>>   
>>     
> I forgot a log with old calculating.
>
>   


-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------030209060503070904090007
Content-Type: text/plain;
 name="datagram_urb_to_videobuf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="datagram_urb_to_videobuf"

tm6000

datagram from urb to videobuf

urb           copy to     temp         copy to         1. videobuf
                         buffer                        2. audiobuf
                                                       3. vbi
184 Packets   ------->   184 * 3072    ---------->     4. etc.
a 3072 bytes               bytes
               184 *                   3072 *
             3072 bytes              180 bytes
                                (184 bytes - 4 bytes
                                    header )
                                    
                                    
step 1

copy from urb to temp buffer

snip
----
for (i = 0; i < urb->number_of_packets; i++) {
	int status = urb->iso_frame_desc[i].status;
	
	if (status<0) {
		print_err_status (dev,i,status);
		continue;
	}

	len=urb->iso_frame_desc[i].actual_length;

	memcpy (t_buf[i*len], urb->transfer_buffer[i*len], len);
	copied += len;
	if (copied >= size || !buf)
		break;

}

if (!urb->iso_frame_desc[i].status) {
	if ((buf->fmt->fourcc)==V4L2_PIX_FMT_TM6000) {
		rc=copy_multiplexed(t_buf, outp, len, urb, &buf);
		if (rc<=0)
			return rc;
	} else {
		copy_streams(t_buf, outp, len, urb, &buf);
	}
}
---
snip

step 2

copy from temp buffer into videobuffer

snip
---

for (i=0;i<3072;i++) {
	switch(cmd) {
		case TM6000_URB_MSG_VIDEO:
			/* Fills video buffer */
			memcpy(&out_p[(line << 1 + field) * block * 180],
				ptr[(i*184)+4], 180);
			printk (KERN_INFO "cmd=%s, size=%d\n",
			tm6000_msg_type[cmd],size);
			break;
		case TM6000_URB_MSG_PTS:
			printk (KERN_INFO "cmd=%s, size=%d\n",
			tm6000_msg_type[cmd],size);
			break;
		case TM6000_URB_MSG_AUDIO:
			/* Need some code to process audio */
			printk ("%ld: cmd=%s, size=%d\n", jiffies,
			tm6000_msg_type[cmd],size);
			break;
		default:
			dprintk (dev, V4L2_DEBUG_ISOC, "cmd=%s, size=%d\n",
			printk (KERN_INFO "cmd=%s, size=%d\n",
			tm6000_msg_type[cmd],size);
		}
	}
}

---
snip

This is a schemata to copy in videobuf.

temp_buf = fifo size * block size

viodeobuf = hight * wight * 2


Questions

1. Is it right if I copy the block without header to videobufer?
2. Can I full the videobuffer have more temp_bufs?
3. How are the actually data schema from urb to videobuffer?

--------------030209060503070904090007--
