Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46966 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753442AbcIMXdq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:33:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [v4l-utils PATCH 1/2] media-ctl: Split off printing information related to a single entity
Date: Wed, 14 Sep 2016 02:34:27 +0300
Message-ID: <3090324.sTi32lg0EZ@avalon>
In-Reply-To: <1473755296-14109-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1473755296-14109-1-git-send-email-sakari.ailus@linux.intel.com> <1473755296-14109-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 13 Sep 2016 11:28:15 Sakari Ailus wrote:
> As a result, a function that can be used to print information on a given
> entity only is provided.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  utils/media-ctl/media-ctl.c | 93 +++++++++++++++++++++---------------------
>  1 file changed, 49 insertions(+), 44 deletions(-)

-- 
Regards,

Laurent Pinchart

