Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46869 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3LLBYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 20:24:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Bhupesh SHARMA <bhupesh.sharma@st.com>
Subject: Re: [PATCH 0/4] Bugfixes for UVC gadget test application
Date: Thu, 12 Dec 2013 02:24:33 +0100
Message-ID: <6701425.xIhpkQYXWr@avalon>
In-Reply-To: <1386675637-18243-1-git-send-email-r.baldyga@samsung.com>
References: <1386675637-18243-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Tuesday 10 December 2013 12:40:33 Robert Baldyga wrote:
> Hello,
> 
> This patchset fixes UVC gadget test application, created by Laurent Pinchart
> (git tree available here: git://git.ideasonboard.org/uvc-gadget.git), with
> applied patches created by Bhupesh Sharma (which can be found here:
> http://www.spinics.net/lists/linux-usb/msg84376.html).
> 
> It improves video-capture device handling, and adds few other fixes.
> More details can be found in commit messages.

Thank you for the patches. This is a nice reminder that I still haven't 
reviewed Bhupesh's patches. I've tried to get back to them, but the size of 
the first patch makes it too complex to review for the limited time I have 
now. Unless the "UVC gadget: Add support for integration with a video-capture 
device and other fixes" patch gets split in smaller chunks I won't have time 
to handle it before February at the earliest.

> Best regards
> Robert Baldyga
> Samsung R&D Institute Poland
> 
> Robert Baldyga (4):
>   closing uvc file when init fails
>   remove set_format from uvc_events_process_data
>   fix v4l2 stream handling
>   remove flooding debugs
> 
>  uvc-gadget.c |   68  +++++++++---------------------------------------------
>  1 file changed, 10 insertions(+), 58 deletions(-)

-- 
Regards,

Laurent Pinchart

