Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35492 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754622AbdDGJ5Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 05:57:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 8/8] v4l: Remove V4L2 OF framework in favour of V4L2 fwnode framework
Date: Fri, 07 Apr 2017 12:58:01 +0300
Message-ID: <2097657.y1FbEyaKry@avalon>
In-Reply-To: <1491484330-12040-9-git-send-email-sakari.ailus@linux.intel.com>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com> <1491484330-12040-9-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Thursday 06 Apr 2017 16:12:10 Sakari Ailus wrote:
> All drivers have been converted from V4L2 OF to V4L2 fwnode. The V4L2 OF
> framework is now unused. Remove it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/Makefile  |   3 -
>  drivers/media/v4l2-core/v4l2-of.c | 327 -----------------------------------
>  include/media/v4l2-of.h           | 128 ---------------
>  3 files changed, 458 deletions(-)
>  delete mode 100644 drivers/media/v4l2-core/v4l2-of.c
>  delete mode 100644 include/media/v4l2-of.h

-- 
Regards,

Laurent Pinchart
