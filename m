Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:57587 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933172Ab1CXH2d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 03:28:33 -0400
Message-ID: <4D8AF29F.9010409@matrix-vision.de>
Date: Thu, 24 Mar 2011 08:28:31 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Lo=EFc_Akue?= <akue.loic@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: Re: [PATCH] omap3isp: implement ENUM_FMT
References: <4D889C61.905@matrix-vision.de> <4D89C2ED.5080803@maxwell.research.nokia.com> <4D89D460.7000808@matrix-vision.de> <201103231316.46934.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103231316.46934.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On 03/23/2011 01:16 PM, Laurent Pinchart wrote:
> Hi Michael,
> 
[snip]
>>
>> Is there a policy decision that in the future, apps will be required to
>> use libv4l to get images from the ISP?  Are we not intending to support
>> using e.g. media-ctl + some v4l2 app, as I'm currently doing during
>> development?
> 
> Apps should be able to use the V4L2 API directly. However, we can't implement 
> all that API, as most calls don't make sense for the OMA3 ISP driver. Which 
> calls need to be implemented is a grey area at the moment, as there's no 
> detailed semantics on how subdev-level configuration and video device 
> configuration should interact.
> 
> Your implementation of ENUM_FMT looks correct to me, but the question is 
> whether ENUM_FMT should be implemented. I don't think ENUM_FMT is a required 
> ioctl, so maybe v4l2src shouldn't depend on it. I'm interesting in getting 
> Hans' opinion on this.
> 

I only implemented it after I saw that ENUM_FMT _was_ required by V4L2.
 From http://v4l2spec.bytesex.org/spec/x1859.htm#AEN1894 :
"The VIDIOC_ENUM_FMT ioctl must be supported by all drivers exchanging
image data with applications."

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
