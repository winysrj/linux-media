Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35450 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab0LNKy0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 05:54:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
Date: Tue, 14 Dec 2010 11:55:20 +0100
Cc: linux-media@vger.kernel.org
References: <201011291115.11061.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201011291115.11061.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012141155.20714.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

Please don't forget this pull request for 2.6.37.

On Monday 29 November 2010 11:15:10 Laurent Pinchart wrote:
> Hi Mauro,
> 
> The following changes since commit
> c796e203229c8c08250f9d372ae4e10c466b1787:
> 
>   [media] kconfig: add an option to determine a menu's visibility
> (2010-11-22 10:37:56 -0200)
> 
> are available in the git repository at:
>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable
> 
> They complete the BKL removal from the uvcvideo driver. Feedback received
> from Hans during review has been integrated.
> 
> Laurent Pinchart (5):
>       uvcvideo: Lock controls mutex when querying menus
>       uvcvideo: Move mutex lock/unlock inside uvc_free_buffers
>       uvcvideo: Move mmap() handler to uvc_queue.c
>       uvcvideo: Lock stream mutex when accessing format-related information
>       uvcvideo: Convert to unlocked_ioctl
> 
>  drivers/media/video/uvc/uvc_ctrl.c  |   48 +++++++++-
>  drivers/media/video/uvc/uvc_queue.c |  133 +++++++++++++++++++++-----
>  drivers/media/video/uvc/uvc_v4l2.c  |  185
> +++++++++++----------------------- drivers/media/video/uvc/uvc_video.c |  
>  3 -
>  drivers/media/video/uvc/uvcvideo.h  |   10 ++-
>  5 files changed, 222 insertions(+), 157 deletions(-)

-- 
Regards,

Laurent Pinchart
