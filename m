Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:35413 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602Ab2FINf7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jun 2012 09:35:59 -0400
Received: by lahi5 with SMTP id i5so1843309lah.28
        for <linux-media@vger.kernel.org>; Sat, 09 Jun 2012 06:35:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACSP8SgrB2YxsvUx6y-EomgJhupb3uVmF_hH0Sd-PG6G6G9Cfg@mail.gmail.com>
References: <4fbf6893.a709d80a.4f7b.0e0eSMTPIN_ADDED@mx.google.com>
	<CACSP8SgSi+v70+-r1wR1hM0rDzmJK0g20i0fxRePLPuTXqrxuA@mail.gmail.com>
	<CAO8GWq=UYWTuJ=V6Luh4z49=og2X2wrHzVNYvbK7Tnw2zgzNeA@mail.gmail.com>
	<CACSP8Sgog0cDtxG+JsWQ=aYyiXtEr-N7+xPPRsAjwt3LAYC+uw@mail.gmail.com>
	<CAO8GWqnVN3tVp2chzsYKjhfzoupxsWwUT_LojzJ7kYWPRdZYJw@mail.gmail.com>
	<CACSP8SiVYiEg8BY9gvmbqiKNXEwEjHa+vxOvXpEgr+W-Wd5+rg@mail.gmail.com>
	<4fd09200.830ed80a.24f9.1a54SMTPIN_ADDED@mx.google.com>
	<CACSP8SgrB2YxsvUx6y-EomgJhupb3uVmF_hH0Sd-PG6G6G9Cfg@mail.gmail.com>
Date: Sat, 9 Jun 2012 08:35:56 -0500
Message-ID: <CAO8GWqkxfbm28DLVA9psBME6JZckwmGb-Awmafupxm=B2UbmeA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC] Synchronizing access to buffers shared with
 dma-buf between drivers/devices
From: "Clark, Rob" <rob@ti.com>
To: Erik Gilling <konkers@android.com>
Cc: Tom Cooksey <tom.cooksey@arm.com>, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 8, 2012 at 3:56 PM, Erik Gilling <konkers@android.com> wrote:
>> I guess my other thought is that implicit vs explicit is not
>> mutually exclusive, though I'd guess there'd be interesting
>> deadlocks to have to debug if both were in use _at the same
>> time_. :-)
>
> I think this is an approach worth investigating.  I'd like a way to
> either opt out of implicit sync or have a way to check if a dma-buf
> has an attached fence and detach it.  Actually, that could work really
> well. Consider:
>
> * Each dma_buf has a single fence "slot"
> * on submission
>   * the driver will extract the fence from the dma_buf and queue a wait on it.
>   * the driver will replace that fence with it's own complettion
> fence before the job submission ioctl returns.
> * dma_buf will have two userspace ioctls:
>   * DETACH: will return the fence as an FD to userspace and clear the
> fence slot in the dma_buf
>   * ATTACH: takes a fence FD from userspace and attaches it to the
> dma_buf fence slot.  Returns an error if the fence slot is non-empty.
>
> In the android case, we can do a detach after every submission and an
> attach right before.

btw, I like this idea for implicit and explicit sync to coexist

BR,
-R
