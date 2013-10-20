Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64100 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3JTJyO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Oct 2013 05:54:14 -0400
Received: from [192.168.0.103] ([93.218.112.150]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0M9s8K-1VRBsq3rcu-00B0w6 for
 <linux-media@vger.kernel.org>; Sun, 20 Oct 2013 11:54:13 +0200
Message-ID: <5263A842.4000508@rempel-privat.de>
Date: Sun, 20 Oct 2013 11:54:10 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Peter Ross <pross@xvid.org>, linux-uvc-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [linux-uvc-devel] [PATCH 0/2] uvcvideo: Support Logitech RGB
 Bayer formats
References: <cover.1357039246.git.pross@xvid.org> <20130102090346.GA2243@b9d1a1848204a80b27c5d574b483f38a> <50E4110B.5080905@fisher-privat.net> <2056413.0Wge1Fvauc@avalon>
In-Reply-To: <2056413.0Wge1Fvauc@avalon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 07.01.2013 23:45, schrieb Laurent Pinchart:
> Hi Oleksij,
> 
> (CC'ing linux-media)
> 
> On Wednesday 02 January 2013 11:50:51 Oleksij Rempel wrote:
>> Am 02.01.2013 10:03, schrieb Peter Ross:
>>> On Tue, Jan 01, 2013 at 05:16:44PM +0100, Oleksij Rempel wrote:
> 
> One could argue that an application that explicitly disables processing would 
> be able to handle that. However, I agree that point 1 is problematic, and 
> point 2 is definitely not clean.
> 
>>> Some of this has been discussed previously, see
>>> <http://article.gmane.org/gmane.linux.drivers.uvc.devel/3061/>.
>>>
>>> The patch tries to solve both of these problems: 1) making uvcvideo aware
>>> of the Logitech controls and recalculating the expected frame sizes, and
>>> 2) presenting the RGB Bayer formats through the V4L2 interface, so user
>>> application can request them.
>>
>> If, the problem seems to be bigger.
>> We have:
>> 1. Formats provided by usb descriptor and controlled over uvc protocol.
>> 2. Formats provided by usb descriptor and controlled over XU
> 
> Do we really have devices that expose formats through the standard UVC 
> descriptors but require XU access to select them ?
> 
>> 3. Formats controlled over XU and provided by documentation other kind
>> of knowledge.
>>
>> Last case in not properly handled by uvcvideo.ko, but IMHO it is not good
>> way to have all possible XU in driver.
>> Both problems you described should be fixed, but not in this way. If it
>> is possible - uvcdynctl should provide/update format descriptor over
>> uvc_xu_control_query interface or some other way.
>>
>> Beside, i was working on kernel space plugin system for uvcvideo driver,
>> which was probably not the best idea. How about to do some part of it in
>> userspace? For example, uvcdynctl can provide bandwidth information too.
>> This way we can fix many buggy cams without needing to permanently
>> update kernel driver.
>> Laurent?
> 
> I'm really undecided here.
> 
> On one hand I agree with you, from a theoretical point of view the driver 
> should not know about all possible XUs. This just can't scale.
> 
> On the other hand, it's pretty clear that we don't need to scale. We only have 
> a single public dynamic controls XML file, and looking at the descriptors of 
> most devices it's pretty clear that they reuse the same XUs, as they are based 
> on only a dozen or so different chips.
> 
> The dynamic controls API brings additional complexity to the driver, and I 
> think that it was a good design decision. However, in some cases, the 
> implications of changing an XU control value go well beyond what is usually 
> expected of a control. I'm thus tempted to allow handling of XU controls in 
> the kernel when there's a good reason to do so. Of course I want the code to 
> be clean, without lots of hooks all over the place that would make the driver 
> sources impossible to read and understand :-)
> 
> Comments and thoughts will be appreciated.
> 

Hello Peter, Laurent,

Peter do have time to update this patches for latest kernel? Laurent
would you accept them?

-- 
Regards,
Oleksij
