Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53961 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2GOMHM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jul 2012 08:07:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [Regression 3.1->3.2, bisected] UVC-webcam: kernel panic when starting capturing
Date: Sun, 15 Jul 2012 14:07:15 +0200
Message-ID: <11675039.R7p149JEZD@avalon>
In-Reply-To: <4FFF208C.5030306@googlemail.com>
References: <4FFF208C.5030306@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

Thanks for the report.

On Thursday 12 July 2012 21:07:56 Frank Schäfer wrote:
> Hi,
> 
> when I start capturing from the UVC-webcam 2232:1005 ("WebCam
> SCB-0385N") of my netbook, I get a kernel panic.
> You can find a screenshot of the backtrace here:
> 
> http://imageshack.us/photo/my-images/9/img125km.jpg/
> 
> 
> This is a regression which has been introduced between kernel 3.2-rc2
> and 3.2-rc3 with the following commit:
> 
> 
> 3afedb95858bcc117b207a7c0a6767fe891bdfe9 is the first bad commit
> commit 3afedb95858bcc117b207a7c0a6767fe891bdfe9
> Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Date:   Thu Nov 3 07:24:34 2011 -0300
> 
>     [media] uvcvideo: Don't skip erroneous payloads
> 
>     Instead of skipping the payload completely, which would make the
>     resulting image corrupted anyway, store the payload normally and mark
>     the buffer as erroneous. If the no_drop module parameter is set to 1 the
> buffer will then be passed to userspace, and tt will then be up to the
> application to decide what to do with the buffer.
> 
>     Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

I'm puzzled. Your screenshot shows the uvc_video_stats_decode() function in 
the stack trace, but that function wasn't present in 
3afedb95858bcc117b207a7c0a6767fe891bdfe9. Could you please send me a stack 
trace corresponding to 3afedb95858bcc117b207a7c0a6767fe891bdfe9 ?

Your stack trace looks similar to the problem reported in 
https://bugzilla.redhat.com/show_bug.cgi?id=836742. 
3afedb95858bcc117b207a7c0a6767fe891bdfe9 might have introduced a different 
bug, possibly fixed in a later commit.

-- 
Regards,

Laurent Pinchart

