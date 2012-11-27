Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:39382 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755959Ab2K0Pcj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 10:32:39 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Tue, 27 Nov 2012 07:24:04 -0800
Subject: RE: [PATCH 10/15] [media] marvell-ccic: split mcam core into 2
 parts for soc_camera support
Message-ID: <477F20668A386D41ADCC57781B1F70430D1367C905@SC-VEXCH1.marvell.com>
References: <1353677652-24288-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271405340.22273@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211271405340.22273@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Tuesday, 27 November, 2012 22:13
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH 10/15] [media] marvell-ccic: split mcam core into 2 parts for
>soc_camera support
>
>On Fri, 23 Nov 2012, Albert Wang wrote:
>
>> This patch splits mcam core into 2 parts to prepare for soc_camera support.
>>
>> The first part remains in mcam-core. This part includes the HW
>> operations and vb2 callback functions.
>>
>> The second part is moved to mcam-core-standard.c. This part is
>> relevant with the implementation of using v4l2.
>>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> ---
>>  drivers/media/platform/marvell-ccic/Makefile       |    4 +-
>>  .../platform/marvell-ccic/mcam-core-standard.c     |  767 +++++++++++++++++
>>  .../platform/marvell-ccic/mcam-core-standard.h     |   28 +
>>  drivers/media/platform/marvell-ccic/mcam-core.c    |  873 +-------------------
>>  drivers/media/platform/marvell-ccic/mcam-core.h    |   45 +
>>  5 files changed, 883 insertions(+), 834 deletions(-)  create mode
>> 100644 drivers/media/platform/marvell-ccic/mcam-core-standard.c
>>  create mode 100644
>> drivers/media/platform/marvell-ccic/mcam-core-standard.h
>
>Nice :-) I hope, you'll excuse me, that I won't be verifying this patch thoroughly, instead,
>I'll trust you to move the code around without actually changing anything in it. Actually,
>you did change a couple of things - like replaced printk() with cam_err(), and actually
>here:
>
>> +		cam_err(cam, "marvell-cam: Cafe can't do S/G I/O," \
>> +			"attempting vmalloc mode instead\n");
>
>and here
>
>> +			cam_warn(cam, "Unable to alloc DMA buffers at load" \
>> +					"will try again later\n");
>
>the backslashes are not needed... Also in these declarations:
>
Sorry, I have to clarify it. :)
I replaced printk() and add backslashes just because the tool scripts/checkpatch.pl.
It will report error when remove the blackslash and report warning when using printk().
But these errors and warnings will be reported only in latest kernel code. :)

If you think we can ignore these errors and warnings, I'm OK to get back to the original code. :)

>> -static inline int mcam_alloc_dma_bufs(struct mcam_camera *cam, int
>> loadtime)
>> +inline int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
>>  {
>>  	return 0;
>>  }
>>
>> -static inline void mcam_free_dma_bufs(struct mcam_camera *cam)
>> +inline void mcam_free_dma_bufs(struct mcam_camera *cam)
>>  {
>>  	return;
>>  }
>>
>> -static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
>> +inline int mcam_check_dma_buffers(struct mcam_camera *cam)
>>  {
>>  	return 0;
>>  }
>
>please also remove "inline." Yet another hunk:
>
It looks this is the bug in original code.
OK, I can remove "inline" key word.

>> -static void mcam_ctlr_stop(struct mcam_camera *cam)
>> +void mcam_ctlr_stop(struct mcam_camera *cam)
>
>doesn't seem to be needed. In the header:
>
I will re-check it.

>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core-standard.h
>> b/drivers/media/platform/marvell-ccic/mcam-core-standard.h
>> new file mode 100644
>> index 0000000..148a1a1
>> --- /dev/null
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core-standard.h
>> @@ -0,0 +1,28 @@
>> +/*
>> + * Marvell camera core structures.
>> + *
>> + * Copyright 2011 Jonathan Corbet corbet@lwn.net  */ extern bool
>> +alloc_bufs_at_read; extern int n_dma_bufs; extern int buffer_mode;
>> +extern const struct vb2_ops mcam_vb2_sg_ops; extern const struct
>> +vb2_ops mcam_vb2_ops;
>
>Do all these variables really have to be exported? If yes - please prefix them all with
>"mcam_..." to avoid polluting the kernel name-space. You don't want to make a symbol
>named like "n_dma_bufs" or "buffer_mode" be visible to the entire kernel;-) In function
>declarations:
>
>> +extern void mcam_ctlr_stop_dma(struct mcam_camera *cam); extern int
>> +mcam_config_mipi(struct mcam_camera *mcam, int enable); extern void
>> +mcam_ctlr_power_up(struct mcam_camera *cam); extern void
>> +mcam_ctlr_power_down(struct mcam_camera *cam); extern void
>> +mcam_ctlr_init(struct mcam_camera *cam); extern int
>> +mcam_cam_init(struct mcam_camera *cam); extern void
>> +mcam_free_dma_bufs(struct mcam_camera *cam); extern void
>> +mcam_ctlr_dma_sg(struct mcam_camera *cam); extern void
>> +mcam_dma_sg_done(struct mcam_camera *cam, int frame); extern int
>> +mcam_check_dma_buffers(struct mcam_camera *cam); extern void
>> +mcam_set_config_needed(struct mcam_camera *cam, int needed); extern
>> +int __mcam_cam_reset(struct mcam_camera *cam); extern int
>> +mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime); extern
>> +void mcam_ctlr_dma_contig(struct mcam_camera *cam); extern void
>> +mcam_dma_contig_done(struct mcam_camera *cam, int frame); extern void
>> +mcam_ctlr_dma_vmalloc(struct mcam_camera *cam); extern void
>> +mcam_vmalloc_done(struct mcam_camera *cam, int frame);
>
>the keyword "extern" isn't needed.
OK, we will re-check it and remove the unnecessary extern variable.
Add mcam_ prefix for necessary extern variable

For function declaration, I will remove it in next version.


Thanks
Albert Wang
86-21-61092656
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer http://www.open-technology.de/
