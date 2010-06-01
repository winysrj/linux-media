Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:56462 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750731Ab0FAEEo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 00:04:44 -0400
Message-ID: <4C0486BF.1000904@arcor.de>
Date: Tue, 01 Jun 2010 06:04:15 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH] tm6000: rewrite copy_streams
References: <1275319534-8616-1-git-send-email-stefan.ringel@arcor.de> <4C043386.3070805@redhat.com>
In-Reply-To: <4C043386.3070805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Am 01.06.2010 00:09, schrieb Mauro Carvalho Chehab:
> Em 31-05-2010 12:25, stefan.ringel@arcor.de escreveu:
>> From: Stefan Ringel <stefan.ringel@arcor.de>
>>
>> fusion function copy streams and copy_packets to new function
copy_streams.
>
>
> There's something wrong with this patch:
>
> $ patch -p1 -i /tmp/tm6000\:\ rewrite\ copy_streams.eml -l
> (Stripping trailing CRs from patch.)
> patching file drivers/staging/tm6000/tm6000-usb-isoc.h
> (Stripping trailing CRs from patch.)
> patching file drivers/staging/tm6000/tm6000-video.c
> Hunk #1 FAILED at 186.
> Hunk #2 FAILED at 439.
> Hunk #3 FAILED at 451.
> 3 out of 6 hunks FAILED -- saving rejects to file
drivers/staging/tm6000/tm6000-video.c.rej
>
> Please rebase it against git branch "devel/for_v2.6.35" of my
v4l-dvb.git tree.
>
Thanks, I rebase it and send it new today.
>
>
>>
>>  static int copy_streams(u8 *data, unsigned long len,
>>              struct urb *urb)
>>  {
>>      struct tm6000_dmaqueue  *dma_q = urb->context;
>>      struct tm6000_core *dev= container_of(dma_q,struct tm6000_core,vidq);
>> -    u8 *ptr=data, *endp=data+len;
>> +    u8 *ptr=data, *endp=data+len, c;
>>      unsigned long header=0;
>>      int rc=0;
>> -    struct tm6000_buffer *buf;
>> -    char *outp = NULL;
>> -
>> -    get_next_buf(dma_q, &buf);
>> -    if (buf)
>> -        outp = videobuf_to_vmalloc(&buf->vb);
>> +    unsigned int cmd, cpysize, pktsize, size, field, block, line, pos
= 0;
>> +    struct tm6000_buffer *vbuf;
>> +    char *voutp = NULL;
>> +    unsigned int linewidth;
>> 
>> -    if (!outp)
>> +    /* get video buffer */
>> +    get_next_buf (dma_q, &vbuf);
>> +    if (!vbuf)
>> +        return rc;
>> +    voutp = videobuf_to_vmalloc(&vbuf->vb);
>> +    if (!voutp)
>>          return 0;
>> 
>> -    for (ptr=data; ptr<endp;) {
>> +    for (ptr = data; ptr < endp;) {
>>          if (!dev->isoc_ctl.cmd) {
>> -            u8 *p=(u8 *)&dev->isoc_ctl.tmp_buf;
>> -            /* FIXME: This seems very complex
>> -             * It just recovers up to 3 bytes of the header that
>> -             * might be at the previous packet
>> -             */
>> -            if (dev->isoc_ctl.tmp_buf_len) {
>> -                while (dev->isoc_ctl.tmp_buf_len) {
>> -                    if ( *(ptr+3-dev->isoc_ctl.tmp_buf_len) == 0x47) {
>> -                        break;
>> -                    }
>> -                    p++;
>> -                    dev->isoc_ctl.tmp_buf_len--;
>> -                }
>> -                if (dev->isoc_ctl.tmp_buf_len) {
>> -                    memcpy(&header, p,
>> -                        dev->isoc_ctl.tmp_buf_len);
>> -                    memcpy((u8 *)&header +
>> +            /* Header */
>> +            if (dev->isoc_ctl.tmp_buf_len > 0) {
>> +                /* from last urb or packet */
>> +                header = dev->isoc_ctl.tmp_buf;
>> +                if (4 - dev->isoc_ctl.tmp_buf_len > 0) {
>> +                    memcpy ((u8 *)&header +
>>                          dev->isoc_ctl.tmp_buf_len,
>>                          ptr,
>>                          4 - dev->isoc_ctl.tmp_buf_len);
>>                      ptr += 4 - dev->isoc_ctl.tmp_buf_len;
>> -                    goto HEADER;
>>                  }
>> +                dev->isoc_ctl.tmp_buf_len = 0;
>> +            } else {
>> +                if (ptr + 3 >= endp) {
>> +                    /* have incomplete header */
>> +                    dev->isoc_ctl.tmp_buf_len = endp - ptr;
>> +                    memcpy (&dev->isoc_ctl.tmp_buf, ptr,
>> +                        dev->isoc_ctl.tmp_buf_len);
>> +                    return rc;
>> +                }
>> +                /* Seek for sync */
>> +                for (; ptr < endp - 3; ptr++) {
>> +                    if (*(ptr + 3) == 0x47)
>> +                        break;
>> +                }
>> +                /* Get message header */
>> +                header = *(unsigned long *)ptr;
>> +                ptr += 4;
>>              }
>> -            /* Seek for sync */
>> -            for (;ptr<endp-3;ptr++) {
>> -                if (*(ptr+3)==0x47)
>> -                    break;
>> +            /* split the header fields */
>> +            c = (header >> 24) & 0xff;
>> +            size = ((header & 0x7e) << 1);
>> +            if (size > 0)
>> +                size -= 4;
>> +            block = (header >> 7) & 0xf;
>> +            field = (header >> 11) & 0x1;
>> +            line  = (header >> 12) & 0x1ff;
>> +            cmd   = (header >> 21) & 0x7;
>> +            /* Validates haeder fields */
>> +            if (size > TM6000_URB_MSG_LEN)
>> +                size = TM6000_URB_MSG_LEN;
>> +            pktsize = TM6000_URB_MSG_LEN;
>> +            /* calculate position in buffer
>> +             * and change the buffer
>> +             */
>> +            switch (cmd) {
>> +            case TM6000_URB_MSG_VIDEO:
>> +                if ((dev->isoc_ctl.vfield != field) &&
>> +                    (field == 1)) {
>> +                    /* Announces that a new buffer
>> +                     * were filled
>> +                     */
>> +                    buffer_filled (dev, dma_q, vbuf);
>> +                    dprintk (dev, V4L2_DEBUG_ISOC,
>> +                            "new buffer filled\n");
>> +                    get_next_buf (dma_q, &vbuf);
>> +                    if (!vbuf)
>> +                        return rc;
>> +                    voutp = videobuf_to_vmalloc (&vbuf->vb);
>> +                    if (!voutp)
>> +                        return rc;
>> +                }
>> +                linewidth = vbuf->vb.width << 1;
>> +                pos = ((line << 1) - field - 1) * linewidth +
>> +                    block * TM6000_URB_MSG_LEN;
>> +                /* Don't allow to write out of the buffer */
>> +                if (pos + size > vbuf->vb.size)
>> +                    cmd = TM6000_URB_MSG_ERR;
>> +                dev->isoc_ctl.vfield = field;
>> +                break;
>> +            case TM6000_URB_MSG_AUDIO:
>> +            case TM6000_URB_MSG_VBI:
>> +            case TM6000_URB_MSG_PTS:
>> +                break;
>>              }
>> -
>> -            if (ptr+3>=endp) {
>> -                dev->isoc_ctl.tmp_buf_len=endp-ptr;
>> -                memcpy (&dev->isoc_ctl.tmp_buf,ptr,
>> -                    dev->isoc_ctl.tmp_buf_len);
>> -                dev->isoc_ctl.cmd=0;
>> -                return rc;
>> +        } else {
>> +            /* Continue the last copy */
>> +            cmd = dev->isoc_ctl.cmd;
>> +            size = dev->isoc_ctl.size;
>> +            pos = dev->isoc_ctl.pos;
>> +            pktsize = dev->isoc_ctl.pktsize;
>> +        }
>> +        cpysize = (endp - ptr > size) ? size : endp - ptr;
>> +        if (cpysize) {
>> +            /* copy data in different buffers */
>> +            switch (cmd) {
>> +            case TM6000_URB_MSG_VIDEO:
>> +                /* Fills video buffer */
>> +                if (vbuf)
>> +                    memcpy (&voutp[pos], ptr, cpysize);
>> +                break;
>> +            case TM6000_URB_MSG_AUDIO:
>> +                /* Need some code to copy audio buffer */
>> +                break;
>> +            case TM6000_URB_MSG_VBI:
>> +                /* Need some code to copy vbi buffer */
>> +                break;
>> +            case TM6000_URB_MSG_PTS:
>> +                /* Need some code to copy pts */
>> +                break;
>>              }
>> -
>> -            /* Get message header */
>> -            header=*(unsigned long *)ptr;
>> -            ptr+=4;
>>          }
>> -HEADER:
>> -        /* Copy or continue last copy */
>> -        rc=copy_packet(urb,header,&ptr,endp,outp,&buf);
>> -        if (rc<0) {
>> -            buf=NULL;
>> -            printk(KERN_ERR "tm6000: buffer underrun at %ld\n",
>> -                    jiffies);
>> -            return rc;
>> +        if (ptr + pktsize > endp) {
>> +            /* End of URB packet, but cmd processing is not
>> +             * complete. Preserve the state for a next packet
>> +             */
>> +            dev->isoc_ctl.pos = pos + cpysize;
>> +            dev->isoc_ctl.size = size - cpysize;
>> +            dev->isoc_ctl.cmd = cmd;
>> +            dev->isoc_ctl.pktsize = pktsize - (endp - ptr);
>> +            ptr += endp - ptr;
>> +        } else {
>> +            dev->isoc_ctl.cmd = 0;
>> +            ptr += pktsize;
>>          }
>> -        if (!*buf)
>> -            return 0;
>>      }
>> -
>>      return 0;
>>  }
>>  /*
>> @@ -439,7 +350,7 @@ static int copy_multiplexed(u8 *ptr, unsigned long
len,
>>      while (len>0) {
>>          cpysize=min(len,buf->vb.size-pos);
>>          //printk("Copying %d bytes (max=%lu) from %p to
%p[%u]\n",cpysize,(*buf)->vb.size,ptr,out_p,pos);
>> -        memcpy(&out_p[pos], ptr, cpysize);
>> +        memcpy(&outp[pos], ptr, cpysize);
>>          pos+=cpysize;
>>          ptr+=cpysize;
>>          len-=cpysize;
>> @@ -451,8 +362,8 @@ static int copy_multiplexed(u8 *ptr, unsigned long
len,
>>              get_next_buf (dma_q, &buf);
>>              if (!buf)
>>                  break;
>> -            out_p = videobuf_to_vmalloc(&(buf->vb));
>> -            if (!out_p)
>> +            outp = videobuf_to_vmalloc(&(buf->vb));
>> +            if (!outp)
>>                  return rc;
>>              pos = 0;
>>          }
>> @@ -510,7 +421,6 @@ static inline int tm6000_isoc_copy(struct urb *urb)
>>  {
>>      struct tm6000_dmaqueue  *dma_q = urb->context;
>>      struct tm6000_core *dev= container_of(dma_q,struct tm6000_core,vidq);
>> -    struct tm6000_buffer *buf;
>>      int i, len=0, rc=1, status;
>>      char *p;
>> 
>> @@ -585,7 +495,6 @@ static void tm6000_uninit_isoc(struct tm6000_core
*dev)
>>      struct urb *urb;
>>      int i;
>> 
>> -    dev->isoc_ctl.nfields = -1;
>>      dev->isoc_ctl.buf = NULL;
>>      for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
>>          urb=dev->isoc_ctl.urb[i];
>> @@ -610,8 +519,6 @@ static void tm6000_uninit_isoc(struct tm6000_core
*dev)
>>      dev->isoc_ctl.urb=NULL;
>>      dev->isoc_ctl.transfer_buffer=NULL;
>>      dev->isoc_ctl.num_bufs = 0;
>> -
>> -    dev->isoc_ctl.num_bufs=0;
>>  }
>> 
>>  /*
>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQEcBAEBAgAGBQJMBIa/AAoJEAWtPFjxMvFGCCkH/279v1htNxN02qmI3epHiPg7
SqBxo6n+GdKe6tb/UfgypRroKqiYUxXSY03zusTtOi9CmwbZ03KixNlT82VQlYul
x5pMu2uTgkGpUGPzgBR0Bw018eenWe6GDNcC0FSaLi6sWyBS+BBjUt7AUmdEYfPw
C2YwO1KGb/VEeZxfwzc4oWkLEfipoipTmfyC9jYgv8Cc/iBE4inG88jE9rASeyDF
70IbWpI53ez7zyt7zkZaQCfZ1gjxOfaUggS2ty+A16kHA4QF5rKMQl05oj/wUDl6
TUZcwuoQ9gZr8fyXIHTcvAD1Ir0Sas9F5dR+H9rHHkets+YTFpg7pvqBLGuP1GA=
=JIaH
-----END PGP SIGNATURE-----

