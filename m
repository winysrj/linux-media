Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4723 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZBVJ5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 04:57:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: kilgota@banach.math.auburn.edu
Subject: Re: RFCv1: v4l-dvb development models & old kernel support
Date: Sun, 22 Feb 2009 10:57:16 +0100
Cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org
References: <200902211200.45373.hverkuil@xs4all.nl> <200902212347.47109.linux@baker-net.org.uk> <alpine.LNX.2.00.0902211811500.10147@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0902211811500.10147@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902221057.17050.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 22 February 2009 02:15:51 kilgota@banach.math.auburn.edu wrote:
> >> Oldest supported Ubuntu kernel is 2.6.22 (7.10):
>
> This is a bit optimistic.
>
> Matter of fact, I just bought a brand new eeePC in January, on which Asus
> chose to install Xandros. The response to uname -r is (I put this on a
> separate line in order to highlight it)
>
> 2.6.21.4-eeepc
>
> Now, some might not think of Xandros as a leading distro. It certainly
> would not have been my first choice. The choice of such an old kernel
> confirms that impression. But the netbook hardware platform, I would say,
> is a rather important one. The point is, if one is going to start looking
> for kernels that are obviously too old to mess with but are in common use
> then one has to go back even beyond 2.6.22. If it were my choice, I
> wouldn't.

I don't think these netbooks are relevant for us for the simple fact that 
the main use case of v4l-dvb on devices like this is the webcam, and that 
will obviously be supported by whatever linux version the manufactorer has 
installed.

But it does raise the point that if we decide to drop support for kernels < 
2.6.22 then it is probably a good idea to make a snapshot first so people 
can still have the option to upgrade their v4l-dvb, even though that 
version isn't maintained anymore by us.

Thank you for your feedback!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
