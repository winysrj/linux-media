Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40170 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbZBPMDG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 07:03:06 -0500
Message-ID: <499956FB.4040505@redhat.com>
Date: Mon, 16 Feb 2009 13:07:23 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
References: <44220.62.70.2.252.1234782074.squirrel@webmail.xs4all.nl>
In-Reply-To: <44220.62.70.2.252.1234782074.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> Hi Hans,
> 

<snip>

> Case 3 *is* pivoting. That's a separate piece of information from the
> mount position. All I want is that that is administrated in separate bits.
> And if we do this, do it right and support the reporting of 0, 90, 180 and
> 270 degrees. No one expects libv4l to handle the portrait modes, and apps
> that can handle this will probably not use libv4l at all.
> 
>> Now can we please stop this color of the bikeshed discussion, add the 2
>> damn
>> flags and move forward?
> 
> Anyone can add an API in 5 seconds. It's modifying or removing a bad API
> that worries me as that can take years.

I understand.

> If you want to add two bits with
> mount information, feel free. But don't abuse them for pivot information.
> If you want that, then add another two bits for the rotation:
> 
> #define V4L2_BUF_FLAG_VFLIP     0x0400
> #define V4L2_BUF_FLAG_HFLIP     0x0800
> 
> #define V4L2_BUF_FLAG_PIVOT_0   0x0000
> #define V4L2_BUF_FLAG_PIVOT_90  0x1000
> #define V4L2_BUF_FLAG_PIVOT_180 0x2000
> #define V4L2_BUF_FLAG_PIVOT_270 0x3000
> #define V4L2_BUF_FLAG_PIVOT_MSK 0x3000
> 

Ok, this seems good. But if we want to distinguish between static sensor mount 
information, and dynamic sensor orientation changing due to pivotting, then I 
think we should only put the pivot flags in the buffer flags, and the static 
flags should be in the VIDIOC_QUERYCAP capabilities flag, what do you think of 
that?

Regards,

Hans
