Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:13810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab1EYXuP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 19:50:15 -0400
Message-ID: <4DDD95AF.4010004@redhat.com>
Date: Wed, 25 May 2011 20:50:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <201105260120.54392.laurent.pinchart@ideasonboard.com> <4DDD91F2.5070801@redhat.com> <201105260143.35396.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105260143.35396.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 25-05-2011 20:43, Laurent Pinchart escreveu:

> Issues arise when devices have floating point registers. And yes, that 
> happens, I've learnt today about an I2C sensor with floating point registers 
> (in this specific case it should probably be put in the broken design 
> category, but it exists :-)).

Huh! Yeah, an I2C sensor with FP registers sound weird. We need more details
in order to address those.

>>> There's an industry trend there, and we need to think about solutions now
>>> otherwise we will be left without any way forward when too many devices
>>> will be impossible to support from kernelspace (OMAP4 is a good example
>>> there, some device drivers require communication with other cores, and
>>> the communication API is implemented in userspace).
>>
>> Needing to go to userspace to allow inter-core communication seems very
>> bad. I seriously doubt that this is a trend. It seems more like a
>> broken-by-design type of architecture.
> 
> I'm inclined to agree with you, but we should address these issues now, while 
> we have relatively few devices impacted by them. I fear that ignoring the 
> problem and hoping it will go away by itself will bring us to a difficult 
> position in the future. We should show the industry in which direction we 
> would like it to go.

I'm all about showing the industry in with direction we would like it to go.
We want that all Linux-supported architectures/sub-architectures support 
inter-core communications in kernelspace, in a more efficient way
that it would happen if such communication would happen in userspace.

Thanks,
Mauro.
