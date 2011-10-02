Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:47561 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753522Ab1JBQ6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Oct 2011 12:58:35 -0400
Message-ID: <4E889839.30005@xenotime.net>
Date: Sun, 02 Oct 2011 09:58:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: 3.1-rc8 still references 2.6.42 when ioctls will be removed
References: <alpine.DEB.2.02.1110020640390.3972@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1110020640390.3972@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/11 03:41, Justin Piszcz wrote:
> Hi,
> 
> FYI--
> 
> [   48.519528] uvcvideo: Deprecated UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET} ioctls will be removed in 2.6.42.
> 
> $ grep 2.6.42 -r /usr/src/linux/*
> 
> /usr/src/linux/drivers/media/video/uvc/uvc_v4l2.c:                 "ioctls will be removed in 2.6.42.\n");

Let's tell the linux-media & Laurent.

But linux-next does not contain that line nor that function.
I guess something in linux-next needs to be merged into mainline.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
