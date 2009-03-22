Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:57193 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbZCVPxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2009 11:53:23 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1780407ywb.1
        for <linux-media@vger.kernel.org>; Sun, 22 Mar 2009 08:53:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237425168.3303.94.camel@palomino.walls.org>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>
	 <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>
	 <63160.21731.qm@web56906.mail.re3.yahoo.com>
	 <1237251478.3303.37.camel@palomino.walls.org>
	 <954486.20343.qm@web56908.mail.re3.yahoo.com>
	 <1237425168.3303.94.camel@palomino.walls.org>
Date: Sun, 22 Mar 2009 11:53:20 -0400
Message-ID: <de8cad4d0903220853v4b871e91x7de6efebfb376034@mail.gmail.com>
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: Andy Walls <awalls@radix.net>
Cc: Corey Taylor <johnfivealive@yahoo.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 18, 2009 at 9:12 PM, Andy Walls <awalls@radix.net> wrote:

> 2.  Try modifying the enc_ts_bufsize module parameter from it's default
> of 32 k, down to 4 k or up to 128 k.  With a smaller size, the loss of
> any one buffer from the encoder will not have such a devastating effect
> on the MPEG TS, but interrupts will happen more frequently.  With a
> larger size, you're less likely to see the timeout errors in your logs,
> and the interrupt rate will be lower.
>
> Make sure you use enc_ts_bufs=64 when you set the buffer size small.
>

Andy,

I am noticing an improvement in pixelation by setting the bufsize to
64k. I will monitor over the next week and report back. I am running 3
HVR-1600s and the IRQs are coming up shared with the USB which also
supports my HD PVR capture device. Monday nights are usually one of
the busier nights for recording so I will know how well this holds up.

Thanks for the tip!

Brandon
