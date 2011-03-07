Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:56794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab1CGL5k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2011 06:57:40 -0500
Message-ID: <4D74C82A.9050406@redhat.com>
Date: Mon, 07 Mar 2011 08:57:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <201103051402.34416.laurent.pinchart@ideasonboard.com> <4D727F64.7040805@redhat.com> <201103052148.06603.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103052148.06603.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-03-2011 17:48, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Saturday 05 March 2011 19:22:28 Mauro Carvalho Chehab wrote:
>> Em 05-03-2011 10:02, Laurent Pinchart escreveu:
>>> Hi Mauro,
>>>
>>> Thanks for the review. Let me address all your concerns in a single mail.
>>>
>>> - ioctl numbers
>>>
>>> I'll send you a patch that reserves a range in Documentation/ioctl/ioctl-
>>> number.txt and update include/linux/media.h accordingly.
>>
>> Ok, thanks.
> 
> "media: Pick a free ioctls range" at the top of the 
> http://git.linuxtv.org/pinchartl/media.git?a=shortlog;h=refs/heads/media-2.6.39-0005-
> omap3isp branch

Added in the end of my quilt series.
> 
>>> - private ioctls
>>>
>>> As already explained by David, the private ioctls are used to control
>>> advanced device features that can't be handled by V4L2 controls at the
>>> moment (such as setting a gamma correction table). Using those ioctls is
>>> not mandatory, and the device will work correctly without them (albeit
>>> with a non optimal image quality).
>>>
>>> David said he will submit a patch to document the ioctls.
>>
>> Ok.
> 
> Working on that.

Laurent/David, any news on that?

>>> - media bus formats
>>>
>>> As Hans explained, there's no 1:1 relationship between media bus formats
>>> and pixel formats.
>>
>> Yet, there are some relationship between them. See my comments on my
>> previous email.
> 
> Let's continue the discussion in the mail thread.
> 
>>> - FOURCC and media bus codes documentation
>>>
>>> I forgot to document some of them. I'll send a new patch that adds the
>>> missing documentation.
>>
>> Ok.
> 
> "v4l: Add documentation for the 12 bits bayer pixel formats"
> "v4l: Fix 12 bits bayer media bus format documentation"
> 
> in the 
> http://git.linuxtv.org/pinchartl/media.git?a=shortlog;h=refs/heads/media-2.6.39-0004-
> v4l-misc branch.
> 
>>> Is there any other issue I need to address ?
>>
>> Nothing else, in the patches I've analysed so far. I'll take a look at the
>> remaining omap3isp after receiving the documentation for the private
>> ioctl's.
>>
>>> My understanding is that there's
>>> no need to rebase the existing patches, is that correct ?
>>
>> Yes, it is correct. Just send the new patches to be applied at the end of
>> the series. I'll eventually reorder them if needed to avoid breaking git
>> bisect.
> 
> Please squash "v4l: Add documentation for the 12 bits bayer pixel formats" 
> with "v4l: Add 12 bits bayer pixel formats" and "v4l: Fix 12 bits bayer media 
> bus format documentation" with "v4l: Add missing 12 bits bayer media bus 
> formats" when applying to keep the history clean. You can discard the commit 
> message of the two new patches.

Added both patches and folded them as requested, and added the remaining
patches after my review. The new tree is at:

http://git.linuxtv.org/mchehab/experimental.git?a=shortlog;h=refs/heads/media_controller

The pending issues for merging it to the main devel branch are:
	- omap3isp private control description;
	- a chapter describing how *MBUS* and fourcc formats are related;
	- a description about how to lock between MBUS/fourcc get/set format;
	- a renaming patch to make directory name and file names consistent.

Thanks,
Mauro.
