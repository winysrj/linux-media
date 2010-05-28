Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:33069 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750701Ab0E1EFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 00:05:38 -0400
Message-ID: <4BFF40A5.2090109@arcor.de>
Date: Fri, 28 May 2010 06:03:49 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 5/5] tm6000: rewrite copy_streams
References: <1274639505-2674-1-git-send-email-stefan.ringel@arcor.de>	<1274639505-2674-2-git-send-email-stefan.ringel@arcor.de> <20100527182313.70ccc509@pedra>
In-Reply-To: <20100527182313.70ccc509@pedra>
Content-Type: multipart/mixed;
 boundary="------------000205050403060506080102"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000205050403060506080102
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Am 27.05.2010 23:23, schrieb Mauro Carvalho Chehab:
> Em Sun, 23 May 2010 20:31:45 +0200
> stefan.ringel@arcor.de escreveu:
>
>   
>> From: Stefan Ringel <stefan.ringel@arcor.de>
>>
>> fusion function copy streams and copy_packets to new function copy_streams.
>>
>> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>> ---
>>  drivers/staging/tm6000/tm6000-usb-isoc.h |    5 +-
>>  drivers/staging/tm6000/tm6000-video.c    |  337 +++++++++++-------------------
>>  2 files changed, 127 insertions(+), 215 deletions(-)
>>
>> diff --git a/drivers/staging/tm6000/tm6000-usb-isoc.h b/drivers/staging/tm6000/tm6000-usb-isoc.h
>> index 5a5049a..138716a 100644
>> --- a/drivers/staging/tm6000/tm6000-usb-isoc.h
>> +++ b/drivers/staging/tm6000/tm6000-usb-isoc.h
>> @@ -39,7 +39,7 @@ struct usb_isoc_ctl {
>>  	int				pos, size, pktsize;
>>  
>>  		/* Last field: ODD or EVEN? */
>> -	int				field;
>> +	int				vfield;
>>  
>>  		/* Stores incomplete commands */
>>  	u32				tmp_buf;
>> @@ -47,7 +47,4 @@ struct usb_isoc_ctl {
>>  
>>  		/* Stores already requested buffers */
>>  	struct tm6000_buffer    	*buf;
>> -
>> -		/* Stores the number of received fields */
>> -	int				nfields;
>>  };
>> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
>> index 2a61cc3..31c574f 100644
>> --- a/drivers/staging/tm6000/tm6000-video.c
>> +++ b/drivers/staging/tm6000/tm6000-video.c
>> @@ -186,234 +186,153 @@ const char *tm6000_msg_type[] = {
>>  /*
>>   * Identify the tm5600/6000 buffer header type and properly handles
>>   */
>> -static int copy_packet(struct urb *urb, u32 header, u8 **ptr, u8 *endp,
>> -			u8 *out_p, struct tm6000_buffer **buf)
>> -{
>> -	struct tm6000_dmaqueue  *dma_q = urb->context;
>> -	struct tm6000_core *dev = container_of(dma_q, struct tm6000_core, vidq);
>> -	u8 c;
>> -	unsigned int cmd, cpysize, pktsize, size, field, block, line, pos = 0;
>> -	int rc = 0;
>> -	/* FIXME: move to tm6000-isoc */
>> -	static int last_line = -2, start_line = -2, last_field = -2;
>> -
>> -	/* FIXME: this is the hardcoded window size
>> -	 */
>> -	unsigned int linewidth = (*buf)->vb.width << 1;
>> -
>> -	if (!dev->isoc_ctl.cmd) {
>> -		c = (header >> 24) & 0xff;
>> -
>> -		/* split the header fields */
>> -		size  = ((header & 0x7e) << 1);
>> -
>> -		if (size > 0)
>> -			size -= 4;
>> -
>> -		block = (header >> 7) & 0xf;
>> -		field = (header >> 11) & 0x1;
>> -		line  = (header >> 12) & 0x1ff;
>> -		cmd   = (header >> 21) & 0x7;
>> -
>> -		/* Validates header fields */
>> -		if(size > TM6000_URB_MSG_LEN)
>> -			size = TM6000_URB_MSG_LEN;
>> -
>> -		if (cmd == TM6000_URB_MSG_VIDEO) {
>> -			if ((block+1)*TM6000_URB_MSG_LEN>linewidth)
>> -				cmd = TM6000_URB_MSG_ERR;
>> -
>> -			/* FIXME: Mounts the image as field0+field1
>> -			 * It should, instead, check if the user selected
>> -			 * entrelaced or non-entrelaced mode
>> -			 */
>> -			pos= ((line<<1)+field)*linewidth +
>> -				block*TM6000_URB_MSG_LEN;
>> -
>> -			/* Don't allow to write out of the buffer */
>> -			if (pos+TM6000_URB_MSG_LEN > (*buf)->vb.size) {
>> -				dprintk(dev, V4L2_DEBUG_ISOC,
>> -					"ERR: size=%d, num=%d, line=%d, "
>> -					"field=%d\n",
>> -					size, block, line, field);
>> -
>> -				cmd = TM6000_URB_MSG_ERR;
>> -			}
>> -		} else {
>> -			pos=0;
>> -		}
>> -
>> -		/* Prints debug info */
>> -		dprintk(dev, V4L2_DEBUG_ISOC, "size=%d, num=%d, "
>> -				" line=%d, field=%d\n",
>> -				size, block, line, field);
>> -
>> -		if ((last_line!=line)&&(last_line+1!=line) &&
>> -		    (cmd != TM6000_URB_MSG_ERR) )  {
>> -			if (cmd != TM6000_URB_MSG_VIDEO)  {
>> -				dprintk(dev, V4L2_DEBUG_ISOC,  "cmd=%d, "
>> -					"size=%d, num=%d, line=%d, field=%d\n",
>> -					cmd, size, block, line, field);
>> -			}
>> -			if (start_line<0)
>> -				start_line=last_line;
>> -			/* Prints debug info */
>> -			dprintk(dev, V4L2_DEBUG_ISOC, "lines= %d-%d, "
>> -					"field=%d\n",
>> -					start_line, last_line, field);
>> -
>> -			if ((start_line<6 && last_line>200) &&
>> -				(last_field != field) ) {
>> -
>> -				dev->isoc_ctl.nfields++;
>> -				if (dev->isoc_ctl.nfields>=2) {
>> -					dev->isoc_ctl.nfields=0;
>> -
>> -					/* Announces that a new buffer were filled */
>> -					buffer_filled (dev, dma_q, *buf);
>> -					dprintk(dev, V4L2_DEBUG_ISOC,
>> -							"new buffer filled\n");
>> -					get_next_buf (dma_q, buf);
>> -					if (!*buf)
>> -						return rc;
>> -					out_p = videobuf_to_vmalloc(&((*buf)->vb));
>> -					if (!out_p)
>> -						return rc;
>> -
>> -					pos = dev->isoc_ctl.pos = 0;
>> -				}
>> -			}
>> -
>> -			start_line=line;
>> -			last_field=field;
>> -		}
>> -		if (cmd == TM6000_URB_MSG_VIDEO)
>> -			last_line = line;
>> -
>> -		pktsize = TM6000_URB_MSG_LEN;
>> -	} else {
>> -		/* Continue the last copy */
>> -		cmd = dev->isoc_ctl.cmd;
>> -		size= dev->isoc_ctl.size;
>> -		pos = dev->isoc_ctl.pos;
>> -		pktsize = dev->isoc_ctl.pktsize;
>> -	}
>> -
>> -	cpysize = (endp-(*ptr) > size) ? size : endp - *ptr;
>> -
>> -	if (cpysize) {
>> -		/* handles each different URB message */
>> -		switch(cmd) {
>> -		case TM6000_URB_MSG_VIDEO:
>> -			/* Fills video buffer */
>> -			memcpy(&out_p[pos], *ptr, cpysize);
>> -			break;
>> -		case TM6000_URB_MSG_PTS:
>> -			break;
>> -		case TM6000_URB_MSG_AUDIO:
>> -			/* Need some code to process audio */
>> -			printk ("%ld: cmd=%s, size=%d\n", jiffies,
>> -				tm6000_msg_type[cmd],size);
>> -			break;
>> -		case TM6000_URB_MSG_VBI:
>> -			break;
>> -		default:
>> -			dprintk (dev, V4L2_DEBUG_ISOC, "cmd=%s, size=%d\n",
>> -						tm6000_msg_type[cmd],size);
>> -		}
>> -	}
>> -	if (cpysize<size) {
>> -		/* End of URB packet, but cmd processing is not
>> -		 * complete. Preserve the state for a next packet
>> -		 */
>> -		dev->isoc_ctl.pos = pos+cpysize;
>> -		dev->isoc_ctl.size= size-cpysize;
>> -		dev->isoc_ctl.cmd = cmd;
>> -		dev->isoc_ctl.pktsize = pktsize-cpysize;
>> -		(*ptr)+=cpysize;
>> -	} else {
>> -		dev->isoc_ctl.cmd = 0;
>> -		(*ptr)+=pktsize;
>> -	}
>> -
>> -	return rc;
>> -}
>> -
>>  static int copy_streams(u8 *data, unsigned long len,
>>  			struct urb *urb)
>>  {
>>  	struct tm6000_dmaqueue  *dma_q = urb->context;
>>  	struct tm6000_core *dev= container_of(dma_q,struct tm6000_core,vidq);
>> -	u8 *ptr=data, *endp=data+len;
>> +	u8 *ptr=data, *endp=data+len, c;
>>  	unsigned long header=0;
>>  	int rc=0;
>> -	struct tm6000_buffer *buf;
>> -	char *outp = NULL;
>> -
>> -	get_next_buf(dma_q, &buf);
>> -	if (buf)
>> -		outp = videobuf_to_vmalloc(&buf->vb);
>> +	unsigned int cmd, cpysize, pktsize, size, field, block, line, pos = 0;
>> +	struct tm6000_buffer *vbuf;
>> +	char *voutp = NULL;
>> +	unsigned int linewidth;
>>  
>> -	if (!outp)
>> +	/* get video buffer */
>> +	get_next_buf (dma_q, &vbuf);
>> +	if (!vbuf)
>> +		return rc;
>> +	voutp = videobuf_to_vmalloc(&vbuf->vb);
>> +	if (!voutp)
>>  		return 0;
>>  
>> -	for (ptr=data; ptr<endp;) {
>> +	for (ptr = data; ptr < endp;) {
>>  		if (!dev->isoc_ctl.cmd) {
>> -			u8 *p=(u8 *)&dev->isoc_ctl.tmp_buf;
>> -			/* FIXME: This seems very complex
>> -			 * It just recovers up to 3 bytes of the header that
>> -			 * might be at the previous packet
>> -			 */
>> -			if (dev->isoc_ctl.tmp_buf_len) {
>> -				while (dev->isoc_ctl.tmp_buf_len) {
>> -					if ( *(ptr+3-dev->isoc_ctl.tmp_buf_len) == 0x47) {
>> -						break;
>> -					}
>> -					p++;
>> -					dev->isoc_ctl.tmp_buf_len--;
>> -				}
>> -				if (dev->isoc_ctl.tmp_buf_len) {
>> -					memcpy(&header, p,
>> -						dev->isoc_ctl.tmp_buf_len);
>> -					memcpy((u8 *)&header +
>> +			/* Header */
>> +			if (dev->isoc_ctl.tmp_buf_len > 0) {
>> +				/* from last urb or packet */
>> +				header = dev->isoc_ctl.tmp_buf;
>> +				if (4 - dev->isoc_ctl.tmp_buf_len > 0)
>> +					memcpy ((u8 *)&header +
>>  						dev->isoc_ctl.tmp_buf_len,
>>  						ptr,
>>  						4 - dev->isoc_ctl.tmp_buf_len);
>>  					ptr += 4 - dev->isoc_ctl.tmp_buf_len;
>> -					goto HEADER;
>>  				}
>> +				dev->isoc_ctl.tmp_buf_len = 0;
>> +			} else {
>> +				if (ptr + 3 >= endp) {
>> +					/* have incomplete header */
>> +					dev->isoc_ctl.tmp_buf_len = endp - ptr;
>> +					memcpy (&dev->isoc_ctl.tmp_buf, ptr,
>> +						dev->isoc_ctl.tmp_buf_len);
>> +					return rc;
>> +				}
>> +				/* Seek for sync */
>> +				for (; ptr < endp - 3; ptr++) {
>> +					if (ptr < endp - 187) {
>> +						if (*(ptr + 3) == 0x47 &&
>> +							(*(ptr + 187) == 0x47)
>> +							break;
>>     
> Hmm... are you sure you need to do this? Just checking for the current sync seems
> to be enough, except if the URB is corrupted. In the latter case, it would be better
> to do the opposite: test for the sync at either ptr or ptr + 187:
>
> 		if (*(ptr + 3) == 0x47 || (*(ptr + 187) == 0x47)
>   
Yes 0x47 can be both
1. data
2. sync byte
or will you that it sync into data? It can ignored copy data and lose
data (2 blocks)

for example:

                                    block 1                    block 2
                                 it are cmd 1            it are cmd 1
 norm.          :              header data             header data
                                |          |                       |   
    |
 0x47 is data :                            header  data
                                                    |        |
                                                  
> I don't like the above neither, but this device requires so many workarounds to work
> with a bad hardware/firmware that one more hack wouldn't hurt, but, if this is really
> needed, a proper comment explaining the reason for the hack should be added.
>
>   
>> +					} else {
>> +						if (*(ptr + 3) == 0x47)
>> +							break;
>> +					}
>> +					if (ptr + 3 >= endp)
>> +						return rc;
>>     
> Huh? This test look strange: if ptr + 3 >= endp, the loop would be end before
> calling this code. So, it seems to be a dead code.
>
>   
for example:
it goes with 6 into for ... and doesn't found a sync byte so it must
return from this function and not go out from for ... -> it's not sync
and going to lose data blocks.
>> +				}
>> +				/* Get message header */
>> +				header = *(unsigned long *)ptr;
>> +				ptr += 4;
>>  			}
>>     
>   


-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------000205050403060506080102
Content-Type: text/x-vcard; charset=utf-8;
 name="stefan_ringel.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="stefan_ringel.vcf"

begin:vcard
fn:Stefan Ringel
n:Ringel;Stefan
email;internet:stefan.ringel@arcor.de
note:web: www.stefanringel.de
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------000205050403060506080102--
