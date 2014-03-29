Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:49990 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaC2F2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 01:28:08 -0400
Received: by mail-lb0-f178.google.com with SMTP id s7so4321508lbd.37
        for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 22:28:05 -0700 (PDT)
Message-ID: <533659E2.4010001@t-25.ru>
Date: Sat, 29 Mar 2014 09:28:02 +0400
From: Anton Leontiev <bunder@t-25.ru>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] uvcvideo: Fix marking buffer erroneous in case
 of FID toggling
References: <1395722457-28080-1-git-send-email-bunder@t-25.ru> <1462972.4R5jTG4a0F@avalon> <5334F348.6070308@t-25.ru> <1459346.J1YUbuH55p@avalon>
In-Reply-To: <1459346.J1YUbuH55p@avalon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

28.03.2014 20:12, Laurent Pinchart пишет:
>>>> + * Set error flag for incomplete buffer.
>>>> + */
>>>> +static void uvc_buffer_check_bytesused(const struct uvc_streaming *const
>>>> stream,
> 
> No need for the second const keyword here.
> 
> I would have used "uvc_video_" as a prefix, to be in sync with the surrounding 
> functions. What would you think of uvc_video_validate_buffer() ?
> 
>>>> +	struct uvc_buffer *const buf)
> 
> And no need for const at all here.
> 
>>>> +{
>>>> +	if (buf->length != buf->bytesused &&
>>>> +			!(stream->cur_format->flags & UVC_FMT_FLAG_COMPRESSED))
> 
> The indentation is wrong here, the ! on the second line should be aligned to 
> the first 'buf' of the first line.
> 
> If you agree with these changes I can perform them while applying, there's no 
> need to resubmit the patch.
> 

Thank you for reviewing my first patch to Linux kernel. I completely
agree with your changes.

Just want to ask why there is no need for the second 'const' after
pointer character '*'? I thought it marks pointer itself as constant for
type-checking opposite to first 'const', which marks memory it points to
as constant for type-checking. I understand that the function is simple
enough to verify it by hand but it's better to add more information for
automatic checking.

Is there any guidelines on 'const' keyword usage in Linux kernel code?

Regards,

-- 
Anton Leontiev
