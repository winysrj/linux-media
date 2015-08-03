Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:49563 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbbHCC4s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2015 22:56:48 -0400
Message-ID: <55BED85D.4090905@atmel.com>
Date: Mon, 3 Aug 2015 10:56:29 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/4] atmel-isi: Remove platform data support
References: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent

On 8/1/2015 5:22 PM, Laurent Pinchart wrote:
> Hello,
>
> While reviewing patches for the atmel-isi I noticed a couple of small issues
> with the driver. Here's a patch series to fix them, the main change being the
> removal of platform data support now that all users have migrated to DT.

Thanks for the patches. It's perfectly make sense.
>
> The patches have been compile-tested only. Josh, would you be able to test
> them on hardware ?

For the whole series, here is my:

Acked-by: Josh Wu <josh.wu@atmel.com>
Tested-by: Josh Wu <josh.wu@atmel.com>

Best Regards,
Josh Wu

>
> Laurent Pinchart (4):
>    v4l: atmel-isi: Simplify error handling during DT parsing
>    v4l: atmel-isi: Remove unused variable
>    v4l: atmel-isi: Remove support for platform data
>    v4l: atmel-isi: Remove unused platform data fields
>
>   drivers/media/platform/soc_camera/atmel-isi.c |  40 ++------
>   drivers/media/platform/soc_camera/atmel-isi.h | 126 +++++++++++++++++++++++++
>   include/media/atmel-isi.h                     | 131 --------------------------
>   3 files changed, 136 insertions(+), 161 deletions(-)
>   create mode 100644 drivers/media/platform/soc_camera/atmel-isi.h
>   delete mode 100644 include/media/atmel-isi.h
>

