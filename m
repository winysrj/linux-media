Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50283 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab2CVOlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 10:41:00 -0400
Received: by yhmm54 with SMTP id m54so1780143yhm.19
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2012 07:41:00 -0700 (PDT)
Date: Thu, 22 Mar 2012 07:40:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bhupesh Sharma <bhupesh.sharma@st.com>
Cc: linux-usb@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	spear-devel@list.st.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] usb: gadget/uvc: Remove non-required locking from
 'uvc_queue_next_buffer' routine
Message-ID: <20120322144056.GG19835@kroah.com>
References: <4cead89e45e3e31fccae5bb6fbfb72b2ce1b8cd5.1332391406.git.bhupesh.sharma@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cead89e45e3e31fccae5bb6fbfb72b2ce1b8cd5.1332391406.git.bhupesh.sharma@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 22, 2012 at 10:20:37AM +0530, Bhupesh Sharma wrote:
> This patch removes the non-required spinlock acquire/release calls on
> 'queue_irqlock' from 'uvc_queue_next_buffer' routine.
> 
> This routine is called from 'video->encode' function (which translates to either
> 'uvc_video_encode_bulk' or 'uvc_video_encode_isoc') in 'uvc_video.c'.
> As, the 'video->encode' routines are called with 'queue_irqlock' already held,
> so acquiring a 'queue_irqlock' again in 'uvc_queue_next_buffer' routine causes
> a spin lock recursion.
> 
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/usb/gadget/uvc_queue.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)

Please use scripts/get_maintainer.pl to determine who to send this to
(hint, it's not me...)

greg k-h
