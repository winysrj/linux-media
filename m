Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:40542 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032236Ab2CPAZo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 20:25:44 -0400
Message-ID: <4F628886.3050009@ukfsn.org>
Date: Fri, 16 Mar 2012 00:25:42 +0000
From: Andy Furniss <andyqos@ukfsn.org>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	dheitmueller@kernellabs.com
Subject: Re: [PATCH] em28xx: pre-allocate DVB isoc transfer buffers
References: <1329155962-22896-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1329155962-22896-1-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gianluca Gennari wrote:
> (was: Re: PCTV 290e page allocation failure)
>
> On MIPS/ARM set-top-boxes, as well as old x86 PCs, memory allocation failures
> in the em28xx driver are common, due to memory fragmentation over time, that
> makes impossible to allocate large chunks of coherent memory.
> A typical system with 256/512 MB of RAM fails after just 1 day of uptime (see
> the old thread for detailed reports and crashlogs).
>
> In fact, the em28xx driver allocates memory for USB isoc transfers at runtime,
> as opposite to the dvb-usb drivers that allocates the USB buffers when the
> device is initialized, and frees them when the device is disconnected.
>
> Moreover, in digital mode the USB isoc transfer buffers are freed, allocated
> and cleared every time the user selects a new channel, wasting time and
> resources.

Does this patch have a chance of getting in?

I am still having to flush caches before use. If you want more testing I 
can give it a go. I didn't earlier as I didn't have a git to apply it to 
and thought it was going to get in anyway.

