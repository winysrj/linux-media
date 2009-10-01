Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:34144 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbZJANlb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2009 09:41:31 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KQU000FZ8P78X91@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 01 Oct 2009 09:41:32 -0400 (EDT)
Date: Thu, 01 Oct 2009 09:41:32 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: BUG: cx23885_video_register() uninitialized value passed to
 v4l2_subdev_call()
In-reply-to: <4AC454E1.9070104@gmail.com>
To: "David T. L. Wong" <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Message-id: <4AC4B18C.9090402@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <4AC454E1.9070104@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/1/09 3:06 AM, David T. L. Wong wrote:
> Hi all,
>
> A potential bug is found in cx23885_video_register().
>
> A tuner_setup struct is passed to v4l2_subdev_call(),
> but that struct is not fully initialized, especially for tuner_callback
> member, and eventually tuner_s_type_addr() copy that wrong pointer.
> It would particularly cause seg. fault for xc5000 tuner for analog
> frontend when it calls fe->callback at xc5000_TunerReset().

Thanks for raising this.

I also discovered this last Saturday. I have a patch for this which I expect to 
merge shortly.

Regards,

Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
