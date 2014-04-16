Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60925 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaDPSVx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 14:21:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH v3 00/11] Timestamp source and mem-to-mem device support
Date: Wed, 16 Apr 2014 20:21:54 +0200
Message-ID: <3531905.nrTue8ouRr@avalon>
In-Reply-To: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
References: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patches.

On Saturday 12 April 2014 16:23:52 Sakari Ailus wrote:
> Hi,
> 
> This is the third version of the timestamp source and mem-to-mem device
> support patchset.
> 
> Change since v2:
> 
> - struct device type remains enum v4l2_buf_type
> 
> - Added a struct which contains the 1:1 mapping between V4L2 buffer type,
>   verbose textual representation of it (which already existed), and a
>   command line option. A function for converting the former to the first is
>   provided as well.
> 
> - struct device is no longer manipulated in main(), with the few exceptions
>   that existed before the patchset. Instead, functions are provided to
>   access it.
> 
> - -Q (--queue-type) has been replaced with -B (--buffer-type).
> 
> - Added a patch to shorten the timestamp type names.
> 
> - Added another patch to shorten the string printed for each dequeued
>   buffer.
> 
> - Invalid buffer types are rejected now by yavta.
> 
> - Removed useless use of else.

Applied with whitespace fixes and the following change to 07/11.

@@ -867,6 +868,9 @@ static int video_queue_buffer(struct device *dev,
 	buf.type = dev->type;
 	buf.memory = dev->memtype;
 
-	if (dev->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	if (video_is_output(dev))
 		buf.flags = dev->buffer_output_flags;
 
 	if (video_is_mplane(dev)) {

-- 
Regards,

Laurent Pinchart

