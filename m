Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6.versatel.nl ([62.58.50.97]:34560 "EHLO smtp6.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbZCPH7R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 03:59:17 -0400
Message-ID: <49BE0709.9060300@hhs.nl>
Date: Mon, 16 Mar 2009 09:00:09 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: linux-media@vger.kernel.org, kilgota@banach.math.auburn.edu,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC][PATCH 0/2] Sensor orientation reporting
References: <200903152224.29388.linux@baker-net.org.uk>
In-Reply-To: <200903152224.29388.linux@baker-net.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adam Baker wrote:
> Hi all,
> 
> I've finally got round to writing a sample patch to support the proposed 
> mechanism of reporting sensor orientation to user space. It is split into 2 
> parts, part 1 contains the kernel changes and part 2 the libv4l changes. In 
> order to keep the patch simple I haven't attempted to add support to libv4l 
> for HFLIP and VFLIP but just assumed for now that if a cam needs one then it 
> needs both. If the basic idea gets accepted then fixing that is purely a user 
> space change.
> 
> I also haven't provided an implementation of VIDIOC_ENUMINPUT in libv4l that 
> updates the flags to reflect what libv4l has done to the image. Hans Verkuil 
> originally said he wanted to leave the orientation information available to 
> the user app but I suspect that is actually undesirable. If an app is 
> designed to work without libv4l and to re-orient an image as required then if 
> someone runs it with the LD_PRELOAD capability of libv4l then correct 
> operation depends upon reporting the corrected orientation to the app, not 
> the original orientation.
> 

Thanks!

Both patches look good to me.

Regards,

Hans
