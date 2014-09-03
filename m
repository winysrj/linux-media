Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:49449 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286AbaICL6K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 07:58:10 -0400
Message-ID: <54070228.2000007@cisco.com>
Date: Wed, 03 Sep 2014 13:57:28 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, stoth@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 15/20] cx23885: convert to vb2
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl> <1408010045-24016-16-git-send-email-hverkuil@xs4all.nl> <20140903083251.5c5f286c.m.chehab@samsung.com>
In-Reply-To: <20140903083251.5c5f286c.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 09/03/14 13:32, Mauro Carvalho Chehab wrote:
> Em Thu, 14 Aug 2014 11:54:00 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> As usual, this patch is very large due to the fact that half a vb2 conversion
>> isn't possible. And since this affects 417, alsa, core, dvb, vbi and video the
>> changes are all over.
>>
>> What made this more difficult was the peculiar way the risc program was setup.
>> The driver allowed for running out of buffers in which case the DMA would stop
>> and restart when the next buffer was queued. There was also a complicated
>> timeout system for when buffers weren't filled. This was replaced by a much
>> simpler scheme where there is always one buffer around and the DMA will just
>> cycle that buffer until a new buffer is queued. In that case the previous
>> buffer will be chained to the new buffer. An interrupt is generated at the
>> start of the new buffer telling the driver that the previous buffer can be
>> passed on to userspace.
>>
>> Much simpler and more robust. The old code seems to be copied from the
>> cx88 driver. But it didn't fit the vb2 ops very well and replacing it with
>> the new scheme made the code easier to understand. Not to mention that this
>> patch removes 600 lines of code.
> 
> Great job!

Thank you.

> Still, there are some issue. In special, the RISC changes should go
> to a separate patch, as such changes have the potential of causing
> some regressions. See below.

I tried (I mentioned that in my git pull request), but I was not able
to separate the two. I couldn't make the risc changes to work with vb1,
and the reverse would be equally painful. Not only that, but I would
have to test this twice (once with just the risc changes or vb2 changes,
and again when both are in place).

I can try to do the vb2 conversion first and the risc changes second, but
this too might be too complicated to get to work.

<snip>

>> @@ -1320,7 +1373,6 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>>  				struct v4l2_format *f)
>>  {
>>  	struct cx23885_dev *dev = video_drvdata(file);
>> -	struct cx23885_fh  *fh  = file->private_data;
>>  
>>  	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
>>  	f->fmt.pix.bytesperline = 0;
>> @@ -1329,9 +1381,9 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>>  	f->fmt.pix.colorspace   = 0;
>>  	f->fmt.pix.width        = dev->ts1.width;
>>  	f->fmt.pix.height       = dev->ts1.height;
>> -	f->fmt.pix.field        = fh->mpegq.field;
>> -	dprintk(1, "VIDIOC_G_FMT: w: %d, h: %d, f: %d\n",
>> -		dev->ts1.width, dev->ts1.height, fh->mpegq.field);
>> +	f->fmt.pix.field        = V4L2_FIELD_INTERLACED;
> 
> Why? There are other supported formats, right?

Not for the compressed video node. Only MPEG is supported there.

> 
>> +	dprintk(1, "VIDIOC_G_FMT: w: %d, h: %d\n",
>> +		dev->ts1.width, dev->ts1.height);
>>  	return 0;
>>  }
>>  
>> @@ -1339,15 +1391,15 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>>  				struct v4l2_format *f)
>>  {
>>  	struct cx23885_dev *dev = video_drvdata(file);
>> -	struct cx23885_fh  *fh  = file->private_data;
>>  
>>  	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
>>  	f->fmt.pix.bytesperline = 0;
>>  	f->fmt.pix.sizeimage    =
>>  		dev->ts1.ts_packet_size * dev->ts1.ts_packet_count;
>>  	f->fmt.pix.colorspace   = 0;
>> -	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d, f: %d\n",
>> -		dev->ts1.width, dev->ts1.height, fh->mpegq.field);
>> +	f->fmt.pix.field        = V4L2_FIELD_INTERLACED;
> 
> Why? There are other supported formats, right?

Ditto.

> 
>> +	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d\n",
>> +		dev->ts1.width, dev->ts1.height);
>>  	return 0;
>>  }
>>  

<snip>

>>  
>>  int cx23885_sram_channel_setup(struct cx23885_dev *dev,
>> @@ -482,8 +466,8 @@ int cx23885_sram_channel_setup(struct cx23885_dev *dev,
>>  		lines = 6;
>>  	BUG_ON(lines < 2);
>>  
>> -	cx_write(8 + 0, RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
>> -	cx_write(8 + 4, 8);
>> +	cx_write(8 + 0, RISC_JUMP | RISC_CNT_RESET);
>> +	cx_write(8 + 4, 12);
> 
> The above doesn't sound as being a pure vb2 conversion, and might cause
> regressions, as we're changing the channel setups. I would very much
> prefer to have such changes on a separate changeset, as it makes easier
> to do bisect if ever needed.

See my comment at the top.

> 
>>  	cx_write(8 + 8, 0);
>>  
>>  	/* write CDT */
>> @@ -699,10 +683,6 @@ static int get_resources(struct cx23885_dev *dev)
>>  	return -EBUSY;
>>  }
>>  
>> -static void cx23885_timeout(unsigned long data);
>> -int cx23885_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
>> -				u32 reg, u32 mask, u32 value);
>> -
>>  static int cx23885_init_tsport(struct cx23885_dev *dev,
>>  	struct cx23885_tsport *port, int portno)
>>  {
>> @@ -719,11 +699,6 @@ static int cx23885_init_tsport(struct cx23885_dev *dev,
>>  	port->nr = portno;
>>  
>>  	INIT_LIST_HEAD(&port->mpegq.active);
>> -	INIT_LIST_HEAD(&port->mpegq.queued);
>> -	port->mpegq.timeout.function = cx23885_timeout;
>> -	port->mpegq.timeout.data = (unsigned long)port;
>> -	init_timer(&port->mpegq.timeout);
>> -
>>  	mutex_init(&port->frontends.lock);
>>  	INIT_LIST_HEAD(&port->frontends.felist);
>>  	port->frontends.active_fe_id = 0;
>> @@ -776,9 +751,6 @@ static int cx23885_init_tsport(struct cx23885_dev *dev,
>>  		BUG();
>>  	}
>>  
>> -	cx23885_risc_stopper(dev->pci, &port->mpegq.stopper,
>> -		     port->reg_dma_ctl, port->dma_ctl_val, 0x00);
>> -
>>  	return 0;
>>  }
>>  
>> @@ -1089,11 +1061,18 @@ static void cx23885_dev_unregister(struct cx23885_dev *dev)
>>  static __le32 *cx23885_risc_field(__le32 *rp, struct scatterlist *sglist,
>>  			       unsigned int offset, u32 sync_line,
>>  			       unsigned int bpl, unsigned int padding,
>> -			       unsigned int lines,  unsigned int lpi)
>> +			       unsigned int lines,  unsigned int lpi, bool jump)
>>  {
>>  	struct scatterlist *sg;
>>  	unsigned int line, todo, sol;
>>  
>> +
>> +	if (jump) {
>> +		*(rp++) = cpu_to_le32(RISC_JUMP);
>> +		*(rp++) = cpu_to_le32(0);
>> +		*(rp++) = cpu_to_le32(0); /* bits 63-32 */
>> +	}
>> +
> 
> Here it seem clear: you're now adding a code to support different
> frame interlacing layouts, but the best is to have such changes on
> a separate changeset, as this is one thing that we may have troubles
> in the future.
> 
> The way I see is that we might start having a flood of complains about
> regressions, and all of them will point to this single patch, making
> really hard to identify what part of the change broke it.
> 
> So, let's split those risc changes on a pre (or post) patch, making
> easier if someone needs to report an issue, for us to track what
> patch broke it.
> 
>>  	/* sync instruction */
>>  	if (sync_line != NO_SYNC_LINE)
>>  		*(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
>> @@ -1168,7 +1147,7 @@ int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>>  	/* write and jump need and extra dword */
>>  	instructions  = fields * (1 + ((bpl + padding) * lines)
>>  		/ PAGE_SIZE + lines);
>> -	instructions += 2;
>> +	instructions += 5;
>>  	rc = btcx_riscmem_alloc(pci, risc, instructions*12);
>>  	if (rc < 0)
>>  		return rc;
>> @@ -1177,10 +1156,10 @@ int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>>  	rp = risc->cpu;
>>  	if (UNSET != top_offset)
>>  		rp = cx23885_risc_field(rp, sglist, top_offset, 0,
>> -					bpl, padding, lines, 0);
>> +					bpl, padding, lines, 0, true);
>>  	if (UNSET != bottom_offset)
>>  		rp = cx23885_risc_field(rp, sglist, bottom_offset, 0x200,
>> -					bpl, padding, lines, 0);
>> +					bpl, padding, lines, 0, UNSET == top_offset);
>>  
>>  	/* save pointer to jmp instruction address */
>>  	risc->jmp = rp;
>> @@ -1204,7 +1183,7 @@ int cx23885_risc_databuffer(struct pci_dev *pci,
>>  	   than PAGE_SIZE */
>>  	/* Jump and write need an extra dword */
>>  	instructions  = 1 + (bpl * lines) / PAGE_SIZE + lines;
>> -	instructions += 1;
>> +	instructions += 4;
>>  
>>  	rc = btcx_riscmem_alloc(pci, risc, instructions*12);
>>  	if (rc < 0)
>> @@ -1213,7 +1192,7 @@ int cx23885_risc_databuffer(struct pci_dev *pci,
>>  	/* write risc instructions */
>>  	rp = risc->cpu;
>>  	rp = cx23885_risc_field(rp, sglist, 0, NO_SYNC_LINE,
>> -				bpl, 0, lines, lpi);
>> +				bpl, 0, lines, lpi, lpi == 0);
>>  
>>  	/* save pointer to jmp instruction address */
>>  	risc->jmp = rp;
>> @@ -1243,7 +1222,7 @@ int cx23885_risc_vbibuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>>  	/* write and jump need and extra dword */
>>  	instructions  = fields * (1 + ((bpl + padding) * lines)
>>  		/ PAGE_SIZE + lines);
>> -	instructions += 2;
>> +	instructions += 5;
>>  	rc = btcx_riscmem_alloc(pci, risc, instructions*12);
>>  	if (rc < 0)
>>  		return rc;
>> @@ -1253,12 +1232,12 @@ int cx23885_risc_vbibuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>>  	/* Sync to line 6, so US CC line 21 will appear in line '12'
>>  	 * in the userland vbi payload */
>>  	if (UNSET != top_offset)
>> -		rp = cx23885_risc_field(rp, sglist, top_offset, 6,
>> -					bpl, padding, lines, 0);
>> +		rp = cx23885_risc_field(rp, sglist, top_offset, 0,
>> +					bpl, padding, lines, 0, true);
>>  
>>  	if (UNSET != bottom_offset)
>> -		rp = cx23885_risc_field(rp, sglist, bottom_offset, 0x207,
>> -					bpl, padding, lines, 0);
>> +		rp = cx23885_risc_field(rp, sglist, bottom_offset, 0x200,
>> +					bpl, padding, lines, 0, UNSET == top_offset);
> 
> Why to change the 4th argument of cx23885_risc_field() call?

This was a bug. Hmm, perhaps that should be moved to a separate patch.
The VBI offset was wrong without this.

> 
>>  
>>  
>>  
>> @@ -1269,38 +1248,10 @@ int cx23885_risc_vbibuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>>  }
>>  
>>  
>> -int cx23885_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
>> -				u32 reg, u32 mask, u32 value)
> 
> What happened with this function?

No longer needed after the risc changes.

Regards,

	Hans
