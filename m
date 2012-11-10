Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:34742 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751666Ab2KJNtY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Nov 2012 08:49:24 -0500
Message-ID: <509E5B58.1020108@gmx.net>
Date: Sat, 10 Nov 2012 14:49:12 +0100
From: Andreas Nagel <andreasnagel@gmx.net>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: OMAP3 ISP: VIDIOC_STREAMON and VIDIOC_QBUF calls fail
References: <5097DF9F.6080603@gmx.net> <20121106215153.GE25623@valkosipuli.retiisi.org.uk> <509A4473.3080506@gmx.net> <4541060.0oGRVnU8K8@avalon> <20121108092905.GF25623@valkosipuli.retiisi.org.uk>
In-Reply-To: <20121108092905.GF25623@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus schrieb am 08.11.2012 10:29:
> On Thu, Nov 08, 2012 at 10:26:11AM +0100, Laurent Pinchart wrote:
>> media-ctl doesn't show pad formats, that's a bit weird. Are you using a recent
>> version ?
> This could as well be an issue with the kernel API --- I think that kernel
> has a version which isn't in mainline. So the IOCTL used to access the media
> bus formats are quite possibly different.
>
> Regards,
>

Hi Sakari,
hi Laurent,


first, I could resolve my issues.

When I allocated buffers with the CMEM library from TI (provides aligned 
and contiguous memory buffers), I was able to use user pointers. And 
VIDIOC_STREAMON just failed because of a wrong but similar written 
pixelformat. Since yesterday, I am now able to capture frames and save 
them as YUV data in a file.

My Technexion kernel is based on the TI linux kernel and they 
(Technexion) probably backported some version of Media Controller into 
that kernel. In order to build Laurents media-ctl application, I had to 
rename all MEDIA_* constants in the source files (e.g. MEDIA_PAD_FL_SINK 
into MEDIA_PAD_FLAG_INPUT).
It's probably true, that this implementation is quite different from the 
one in mainline or other kernels. That might also be the reason, why 
media-ctl -p does not print pad formats.
But as long as Technexion keep board support for themselves, I cannot 
use another kernel. I already tried that with some mainline and 
linux-omap versions(3.2, 3.4, 3.6). They don't boot, or if they actually 
do, I don't see anything because network and tty is not available.

Lastly, the TVP5146 indeed generates interlaced frames.

All the best,
Andreas
