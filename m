Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbbIHI73 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Sep 2015 04:59:29 -0400
Message-ID: <1441702684.26994.34.camel@suse.com>
Subject: Re: [PATCH v1] media: uvcvideo: handle urb completion in a work
 queue
From: Oliver Neukum <oneukum@suse.com>
To: Mian Yousaf Kaukab <yousaf.kaukab@intel.com>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, linux-usb@vger.kernel.org
Date: Tue, 08 Sep 2015 10:58:04 +0200
In-Reply-To: <1441643029-25341-1-git-send-email-yousaf.kaukab@intel.com>
References: <1441643029-25341-1-git-send-email-yousaf.kaukab@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2015-09-07 at 18:23 +0200, Mian Yousaf Kaukab wrote:
> urb completion callback is executed in host controllers interrupt
> context. To keep preempt disable time short, add urbs to a list on
> completion and schedule work to process the list.
> 
> Moreover, save timestamp and sof number in the urb completion callback
> to avoid any delays.
> 
> Signed-off-by: Mian Yousaf Kaukab <yousaf.kaukab@intel.com>
> ---
> History:
> v1:
>  - Use global work queue instead of creating ordered queue.

1. using a common queue for real-time work is probably not nice for
picture quality
2. it will deadlock under some conditions

The explanation is a bit long

Suppose we have a device with a camera and a storage device,
like an ordinary camera you can use as a video device which also
exports its memory card.

Now we assume that the storage part is suspended.

CPU A					CPU B
					work item scheduled
entering uvc_uninit_video()
					work item executed
					work item allocates memory
					write to storage interface
					storage interface being resumed
flush_work() - waiting for CPU B
					DEADLOCK


If you want to use flush_work() you must use a dedicated queue.

	Regards
		Oliver


