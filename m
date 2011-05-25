Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab1EYXeS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 19:34:18 -0400
Message-ID: <4DDD91F2.5070801@redhat.com>
Date: Wed, 25 May 2011 20:34:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <201105240027.37467.laurent.pinchart@ideasonboard.com> <4DDBBCED.7090102@redhat.com> <201105260120.54392.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105260120.54392.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 25-05-2011 20:20, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> Thanks for applying the patches. For the record, the compromise was to 
> implement XU controls filtering to make sure that userspace applications won't 
> have access to potentially dangerous controls, and to push vendors to properly 
> document their XUs.

Ok, thanks!

>>> Some XU controls are variable-size binary chunks of data. We can't expose
>>> that as V4L2 controls, which is why I expose them using a documented UVC
>>> API.
>>
>> The V4L2 API allows string controls.
> 
> Hans was very much against using string controls to pass raw binary data.

Pass raw binary data is bad when we know nothing about what's passing there.
A "firmware update" control-type however, is a different thing, as we really
don't care about what's there. Yet, I agree that this may not be the best
way of doing it.

>>> Why would there be no applications using it ? The UVC H.264 XUs are
>>> documented in the above spec, so application can use them.
>>
>> The Linux kernel were designed to abstract hardware differences. We should
>> not move this task to userspace.
> 
> I agree in principle, but we will have to rethink this at some point in the 
> future. I don't think it will always be possible to handle all hardware 
> abstractions in the kernel. Some hardware require floating point operations in 
> their drivers for instance.

I talked with Linus some years ago about float point ops in Kernel. He said he was
not against that, but there are some issues, as float point processors are
arch-dependent, and kernel doesn't save FP registers. So, if a driver really needs
to use it, extra care should be taken. That's said, some drivers use fixed point
operations for some specific usages.

> There's an industry trend there, and we need to think about solutions now 
> otherwise we will be left without any way forward when too many devices will 
> be impossible to support from kernelspace (OMAP4 is a good example there, some 
> device drivers require communication with other cores, and the communication 
> API is implemented in userspace).
 
Needing to go to userspace to allow inter-core communication seems very bad.
I seriously doubt that this is a trend. It seems more like a broken-by-design
type of architecture.

Mauro.
