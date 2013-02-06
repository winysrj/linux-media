Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:49441 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab3BFD0V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Feb 2013 22:26:21 -0500
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Tue, 5 Feb 2013 19:21:39 -0800
Subject: RE: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2
 parts for soc_camera support
Message-ID: <477F20668A386D41ADCC57781B1F70430D1432FB96@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-11-git-send-email-twang13@marvell.com>
	<20121216093717.4be8feff@hpe.lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8CCE4@SC-VEXCH1.marvell.com>
	<20121217082832.7f363d05@lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8D0E3@SC-VEXCH1.marvell.com>
	<20121218121508.7a4de314@lwn.net>
	<477F20668A386D41ADCC57781B1F70430D14255139@SC-VEXCH1.marvell.com>
 <20130204201416.23485c28@lwn.net>
In-Reply-To: <20130204201416.23485c28@lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan

Thanks a lot for explaining it. :)


>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Tuesday, 05 February, 2013 11:14
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2 parts for
>soc_camera support
>
>My apologies for the slow response...I'm running far behind.
>
>On Thu, 31 Jan 2013 00:29:13 -0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> As you know, we are working on adding B_DMA_SG support on soc_camera mode.
>>
>> We found there is some code we can't understand in irq handler:
>> >>>>>>
>> if (handled == IRQ_HANDLED) {
>> 	set_bit(CF_DMA_ACTIVE, &cam->flags);
>> 	if (cam->buffer_mode == B_DMA_sg)
>> 		mcam_ctlr_stop(cam);
>> }
>> <<<<<<
>>
>> The question is why we need stop ccic in irq handler when buffer mode is B_DMA_sg?
>
>That's actually intended to be addressed by this comment in the DMA setup
>code:
>
>/*
> * Frame completion with S/G is trickier.  We can't muck with
> * a descriptor chain on the fly, since the controller buffers it
> * internally.  So we have to actually stop and restart; Marvell
> * says this is the way to do it.
> *
>
>...and, indeed, at the time, I was told by somebody at Marvell that I
>needed to stop the controller before I could store a new descriptor into
>the chain.  I don't see how it could work otherwise, really?
>
[Albert Wang] Em.., maybe I guess there was some flaw in old version.
We indeed can work on current platform without the code.

>I'd be happy to see this code go, it always felt a bit hacky.  But the
>controller buffers the descriptor chain deep inside its unreachable guts,
>so one has to mess with it carefully.
>
[Albert Wang] I suppose your platform should work with the original code.
So how do you think this time we will keep the original code in the patches?
If there is something wrong with it when you test the patches on your platform, maybe we can try to change it. :


>Thanks,
>
>jon

Thanks
Albert Wang
86-21-61092656
