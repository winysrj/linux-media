Return-path: <mchehab@localhost>
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:34720 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab1GKLQd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 07:16:33 -0400
Message-ID: <4E1ADB90.8050305@cam.ac.uk>
Date: Mon, 11 Jul 2011 12:16:32 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Error routes through omap3isp ccdc.
References: <4E1AD36D.4030702@cam.ac.uk> <201107111254.43151.laurent.pinchart@ideasonboard.com> <201107111257.24089.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201107111257.24089.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On 07/11/11 11:57, Laurent Pinchart wrote:
> On Monday 11 July 2011 12:54:42 Laurent Pinchart wrote:
>> On Monday 11 July 2011 12:41:49 Jonathan Cameron wrote:
> 
> [snip]
> 
>> I think we should try to fix it in ispvideo.c instead. You could add a
>> check to isp_video_validate_pipeline() to make sure that the pipeline has
>> a video source.
> 
> And I forgot to mention, I can send a patch if you don't want to write it.
> 
Given I can't quite see why the validate_pipeline code would ever want to break
on source pad being null (which I think is what it is currently doing),
I'll leave it to you.  Really don't know this code well enough!

Thanks.

Jonathan
