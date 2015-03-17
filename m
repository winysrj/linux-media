Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:36650 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932265AbbCQW5o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2015 18:57:44 -0400
Message-ID: <5508B15A.2050900@logicpd.com>
Date: Tue, 17 Mar 2015 17:57:30 -0500
From: Tim Nordell <tim.nordell@logicpd.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>
CC: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 25/26] omap3isp: Move to videobuf2
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com> <1398083352-8451-26-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-26-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi -

On 04/21/14 07:29, Laurent Pinchart wrote:
> Replace the custom buffers queue implementation with a videobuf2 queue.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I realize this is late (it's in the kernel now), but I'm noticing that 
this does not appear to properly support the scatter-gather buffers that 
were previously supported as far as I recall (and can tell with what was 
removed with this patch), especially when using USERPTR.  You can 
observe this using "yavta" with the -u parameter.  Can you confirm if 
this works for you?  I get the following output from the kernel when 
attempting to stream a 640x480 UYVY framebuffer:

[  111.381256] contiguous mapping is too small 589824/614400

- Tim

