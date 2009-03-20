Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2814 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZCTHeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 03:34:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: vasaka@gmail.com
Subject: Re: Is v4l2 loopback needed in kernel? Invitation for code review
Date: Fri, 20 Mar 2009 08:35:05 +0100
Cc: Linux Media <linux-media@vger.kernel.org>
References: <36c518800903051313y184cc5e7i79deb2517fef61f7@mail.gmail.com>
In-Reply-To: <36c518800903051313y184cc5e7i79deb2517fef61f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903200835.05456.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vasily!

On Thursday 05 March 2009 22:13:24 vasaka@gmail.com wrote:
> Hello, my v4l2 loopback device is now at working state: it can do
> streaming and basic IO, works with Skype, luvcview and mplayer. next
> feature planned is allowing multiply readers.
> Benefits from having this driver are: video effects for video
> conferencing programms aware only about v4l, driver can serve as
> adapter between v4l1 and v4l2 and allow multiply readers for webcam.
>
> Is it worth to push this driver to kernel? I have already done some
> work to comply with kernel coding style, and need a code review to
> make shure if I managed to follow common practicies.
>
> current version is tested only with 2.6.26 kernel, I will add 2.6.28
> support(if any work needed) soon.
> code hosted on google code
> http://code.google.com/p/v4l2loopback/

This reply has been on my todo list for ages, but I finally gotten around to 
it :-)

Yes, I think it is useful to have this as part of the kernel. But the first 
step will have to be to make your code compile and work with the v4l-dvb 
master repository: http://linuxtv.org/hg/v4l-dvb/

See also:
http://www.linuxtv.org/wiki/index.php/Development:_How_to_submit_patches

Note that there have been a lot of changes lately, so you should use the 
master repository as the starting point for your driver.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
