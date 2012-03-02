Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50508 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759028Ab2CBSYy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 13:24:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: akpm@linux-foundation.org
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: + drivers-media-video-uvc-uvc_driverc-use-linux-atomich.patch added to -mm tree
Date: Fri, 02 Mar 2012 19:25:11 +0100
Message-ID: <1378885.UbegnO5uVP@avalon>
In-Reply-To: <20120301225629.4B64EA0313@akpm.mtv.corp.google.com>
References: <20120301225629.4B64EA0313@akpm.mtv.corp.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrew,

Thanks for the patch.

On Thursday 01 March 2012 14:56:29 akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: drivers/media/video/uvc/uvc_driver.c: use linux/atomic.h
> has been added to the -mm tree.  Its filename is
>      drivers-media-video-uvc-uvc_driverc-use-linux-atomich.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: drivers/media/video/uvc/uvc_driver.c: use linux/atomic.h
> 
> There's no known problem here, but this is one of only two non-arch files
> in the kernel which use asm/atomic.h instead of linux/atomic.h.
> 
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Applied to my tree (with a small change, I've ordered the #include statements 
alphabetically), pull request sent.

-- 
Regards,

Laurent Pinchart

