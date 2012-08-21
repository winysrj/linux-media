Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43505 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2HUJNc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 05:13:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.7] uvcvideo patches
Date: Tue, 21 Aug 2012 11:13:52 +0200
Message-ID: <1561599.3DnS2US7L9@avalon>
In-Reply-To: <2583529.5y4fYzNJ2T@avalon>
References: <2583529.5y4fYzNJ2T@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sunday 12 August 2012 17:25:05 Laurent Pinchart wrote:
> Hi Mauro,
> 
> The following changes since commit 518c267f4ca4c45cc51bd582b4aef9f0b9f01eba:
> 
>   [media] saa7164: use native print_hex_dump() instead of custom one
> (2012-08-12 07:58:54 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next
> 
> Jayakrishnan Memana (1):
>       uvcvideo: Reset the bytesused field when recycling an erroneous buffer

This patch made it to your media-next tree, but not to the main media tree, 
while the other three patches in this pull request did. Is there a specific 
reason for that ?

> Laurent Pinchart (2):
>       uvcvideo: Support super speed endpoints
>       uvcvideo: Add support for Ophir Optronics SPCAM 620U cameras
> 
> Stefan Muenzel (1):
>       uvcvideo: Support 10bit, 12bit and alternate 8bit greyscale formats
> 
>  drivers/media/video/uvc/uvc_driver.c |   28 ++++++++++++++++++++++++++--
>  drivers/media/video/uvc/uvc_queue.c  |    1 +
>  drivers/media/video/uvc/uvc_video.c  |   30 ++++++++++++++++++++++++------
>  drivers/media/video/uvc/uvcvideo.h   |    9 +++++++++
>  4 files changed, 60 insertions(+), 8 deletions(-)

-- 
Regards,

Laurent Pinchart

