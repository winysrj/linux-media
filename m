Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45274 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab1ELP5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 11:57:22 -0400
Received: from lancelot.localnet (unknown [91.178.194.193])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2FAA9359A1
	for <linux-media@vger.kernel.org>; Thu, 12 May 2011 15:57:21 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
Date: Thu, 12 May 2011 17:48:43 +0200
References: <201105121730.37321.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105121730.37321.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105121748.44346.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

On Thursday 12 May 2011 17:30:36 Laurent Pinchart wrote:
> Hi Mauro,
> 
> The following changes since commit
> f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:
> 
>   [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09
> 05:47:20 +0200)
> 
> are available in the git repository at:
>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next
> 
> Bob Liu (2):
>       Revert "V4L/DVB: v4l2-dev: remove get_unmapped_area"
>       uvcvideo: Add support for NOMMU arch
> 
> Hans de Goede (2):
>       v4l: Add M420 format definition

I forgot to add documentation for the new format. Please ignore the pull 
request, I'll resubmit it tomorrow.

>       uvcvideo: Add M420 format support
> 
> Laurent Pinchart (4):
>       v4l: Release module if subdev registration fails
>       uvcvideo: Register a v4l2_device
>       uvcvideo: Register subdevices for each entity
>       uvcvideo: Connect video devices to media entities
> 
>  drivers/media/video/uvc/Makefile     |    3 +
>  drivers/media/video/uvc/uvc_driver.c |   71 ++++++++++++++++++--
>  drivers/media/video/uvc/uvc_entity.c |  118
> ++++++++++++++++++++++++++++++++++
>  drivers/media/video/uvc/uvc_queue.c  |   34 ++++++++++-
>  drivers/media/video/uvc/uvc_v4l2.c   |   17 +++++
>  drivers/media/video/uvc/uvcvideo.h   |   27 ++++++++
>  drivers/media/video/v4l2-dev.c       |   18 +++++
>  drivers/media/video/v4l2-device.c    |    5 +-
>  include/linux/videodev2.h            |    1 +
>  include/media/v4l2-dev.h             |    2 +
>  10 files changed, 287 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/media/video/uvc/uvc_entity.c

-- 
Regards,

Laurent Pinchart
