Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:48809 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248Ab3AaI3W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 03:29:22 -0500
From: Albert Wang <twang13@marvell.com>
To: Albert Wang <twang13@marvell.com>, Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Thu, 31 Jan 2013 00:29:13 -0800
Subject: RE: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2
 parts for soc_camera support
Message-ID: <477F20668A386D41ADCC57781B1F70430D14255139@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-11-git-send-email-twang13@marvell.com>
	<20121216093717.4be8feff@hpe.lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8CCE4@SC-VEXCH1.marvell.com>
	<20121217082832.7f363d05@lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8D0E3@SC-VEXCH1.marvell.com>
 <20121218121508.7a4de314@lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan

As you know, we are working on adding B_DMA_SG support on soc_camera mode.

We found there is some code we can't understand in irq handler:
>>>>>>
if (handled == IRQ_HANDLED) {
	set_bit(CF_DMA_ACTIVE, &cam->flags);
	if (cam->buffer_mode == B_DMA_sg)
		mcam_ctlr_stop(cam);
}
<<<<<<

The question is why we need stop ccic in irq handler when buffer mode is B_DMA_sg?
>>>
	if (cam->buffer_mode == B_DMA_sg)
		mcam_ctlr_stop(cam);
<<<

Currently we tested B_DMA_sg mode on our platform, and this buffer mode can work only if we comment these 2 lines.

Could you please help us take a look if you have time?

Thank you very much for your help! :)


Thanks
Albert Wang
86-21-61092656

>-----Original Message-----
>From: Albert Wang
>Sent: Wednesday, 19 December, 2012 04:48
>To: 'Jonathan Corbet'
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: RE: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2 parts for
>soc_camera support
>
>Hi, Jonathan
>
>
>>-----Original Message-----
>>From: Jonathan Corbet [mailto:corbet@lwn.net]
>>Sent: Wednesday, 19 December, 2012 03:15
>>To: Albert Wang
>>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>>Subject: Re: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2 parts for
>>soc_camera support
>>
>>On Mon, 17 Dec 2012 19:04:26 -0800
>>Albert Wang <twang13@marvell.com> wrote:
>>
>>> [Albert Wang] So if we add B_DMA_SG and B_VMALLOC support and OLPC XO 1.0
>>support in soc_camera mode.
>>> Then we can just remove the original mode and only support soc_camera mode in
>>marvell-ccic?
>>
>>That is the idea, yes.  Unless there is some real value to supporting both
>>modes (that I've not seen), I think it's far better to support just one of
>>them.  Trying to support duplicated modes just leads to pain in the long
>>run, in my experience.
>>
>[Albert Wang] OK, we will update and submit the remained patches except for the 3
>patches related with soc_camera support as the first part.
>Then we will submit the soc_camera support patches after we rework the patches and add
>B_DMA_SG and B_VMALLOC support and OLPC XO 1.0 support.
>
>>I can offer to *try* to find time to help with XO 1.0 testing when the
>>time comes.
>>
>[Albert Wang] Thank you very much! We were worried about how to get the OLPC XO 1.0
>HW. That would be a great help! :)
>
>>Thanks,
>>
>>jon
>
>
>Thanks
>Albert Wang
>86-21-61092656
