Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:35636 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbcFPRn3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 13:43:29 -0400
Received: by mail-qg0-f66.google.com with SMTP id t106so4357542qgt.2
        for <linux-media@vger.kernel.org>; Thu, 16 Jun 2016 10:43:29 -0700 (PDT)
Message-ID: <1466099005.11108.15.camel@gmail.com>
Subject: Re: [PATCH 00/38] i.MX5/6 Video Capture
From: Nicolas Dufresne <nicolas.dufresne@gmail.com>
Reply-To: nicolas@ndufresne.ca
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Jack Mitchell <ml@embed.me.uk>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
Date: Thu, 16 Jun 2016 13:43:25 -0400
In-Reply-To: <5762DB8A.8090906@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <64c29bbc-2273-2a9d-3059-ab8f62dc531b@embed.me.uk>
 <576202D0.6010608@mentor.com>
 <597d73df-0fa0-fa8d-e0e5-0ad8b2c49bcf@embed.me.uk>
	 <5762DB8A.8090906@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 16 juin 2016 à 10:02 -0700, Steve Longerbeam a écrit :
> I found the cause at least in my case. After enabling dynamic debug in
> videobuf2-dma-contig.c, "v4l2-ctl -d/dev/video0 --stream-user=8" gives
> me
> 
> [  468.826046] user data must be aligned to 64 bytes
> 
> 
> 
> But even getting past that alignment issue, I've only tested userptr (in mem2mem
> driver) by giving the driver a user address of a mmap'ed kernel contiguous
> buffer. A true discontiguous user buffer may not work, the IPU DMA does not
> support scatter-gather.

If it's dma-contig, you'll need page aligned and contiguous memory.
What some test application do when testing their driver with that, is
to allocate memory using another device, or m2m device, that uses the
same allocator.

regards,
Nicolas
