Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:51237 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932066AbbELF5h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 01:57:37 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id F32802A008D
	for <linux-media@vger.kernel.org>; Tue, 12 May 2015 07:57:27 +0200 (CEST)
Message-ID: <55519647.5010007@xs4all.nl>
Date: Tue, 12 May 2015 07:57:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: ATI TV Wonder regression since at least 3.19.6
References: <20150511161203.GG3206@ptaff.ca>
In-Reply-To: <20150511161203.GG3206@ptaff.ca>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrice,

On 05/11/2015 06:12 PM, Patrice Levesque wrote:
> 
> Hi,
> 
> 	my wonderfully old ATI TV Wonder (PCI ID 14f1:8800, module cx8800)
> 	does not behave properly since I upgraded from Linux-3.18.6 to
> 	Linux-3.19.6 (Gentoo builds).
> 
> 	I usually spawn MPlayer to use that device; when I use it under
> 	3.19.6, I get an image like the one that's attached and the usual
> 	sound loopback that goes from the TV card to my sound card does not
> 	seem to be functioning.  Booting with 3.18.6 makes everything work
> 	again.
> 
> 	After a cold boot, with 3.18.6, the first use of the TV card seems
> 	to provoke some kind of initialization (image takes like 0.5 seconds
> 	to settle), with 3.19.6, I immediately get the broken image.
> 
> 	Nothing in `dmesg` would indicate something's horribly broken.
> 
> 	What kind of debugging output would be useful to you guys so we can
> 	identify the issue?

Can you go back to kernel 3.18 and make a small change to the cx88 driver:
edit drivers/media/pci/cx88/cx88-video.c, search for the function restart_video_queue()
(around line 469) and add this line:

	printk("restart_video_queue\n");

to the start of the function:

static int restart_video_queue(struct cx8800_dev    *dev,
                               struct cx88_dmaqueue *q)
{
        struct cx88_core *core = dev->core;
        struct cx88_buffer *buf, *prev;

	printk("restart_video_queue\n");
        if (!list_empty(&q->active)) {
                buf = list_entry(q->active.next, struct cx88_buffer, vb.queue);

Compile and test your card, and then mail the dmesg output.

I'd also like to know the exact model of your board. If the 'restart_video_queue'
message appears in the kernel log, then I want to see if I can find this card
on ebay so I can try to reproduce it myself.

Regards,

	Hans
