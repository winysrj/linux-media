Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4389 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaENHMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 03:12:10 -0400
Message-ID: <5373172A.9070406@xs4all.nl>
Date: Wed, 14 May 2014 09:11:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
CC: k.debski@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: Re: [PATCH v5 0/2] Add resolution change event
References: <1400050783-2158-1-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400050783-2158-1-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2014 08:59 AM, Arun Kumar K wrote:
> This patchset adds a source_change event to the v4l2-events.
> This can be used for notifying the userspace about runtime
> format changes happening on video nodes / pads like resolution
> change in video decoder.

Looks good. I'll merge this after the weekend if there are no more comments.

Regards,

	Hans

> 
> Changes from v4
> --------------
> - Addressed comments from Hans
>   https://patchwork.linuxtv.org/patch/23892/
>   https://patchwork.linuxtv.org/patch/23893/
> 
> Changes from v3
> --------------
> - Addressed comments from Laurent / Hans
>   https://patchwork.kernel.org/patch/4135731/
> 
> Changes from v2
> ---------------
> - Event can be subscribed on specific pad / port as
>   suggested by Hans.
> 
> Changes from v1
> ---------------
> - Addressed review comments from Hans and Laurent
>   https://patchwork.kernel.org/patch/4000951/
> 
> Arun Kumar K (1):
>   [media] v4l: Add source change event
> 
> Pawel Osciak (1):
>   [media] s5p-mfc: Add support for resolution change event
> 
>  Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   33 ++++++++++++++++++
>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   20 +++++++++++
>  drivers/media/platform/s5p-mfc/s5p_mfc.c           |    8 +++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    2 ++
>  drivers/media/v4l2-core/v4l2-event.c               |   36 ++++++++++++++++++++
>  include/media/v4l2-event.h                         |    4 +++
>  include/uapi/linux/videodev2.h                     |    8 +++++
>  7 files changed, 111 insertions(+)
> 

