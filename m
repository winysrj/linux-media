Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933698Ab0BGMui (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2010 07:50:38 -0500
Message-ID: <4B6EB714.505@redhat.com>
Date: Sun, 07 Feb 2010 10:50:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Muralidharan Karicheri <mkaricheri@gmail.com>
CC: linux-media@vger.kernel.org, khilman@deeprootsystems.com,
	hverkuil@xs4all.nl
Subject: Re: [GIT PATCHES FOR 2.6.34] Support for vpfe-capture on DM365
References: <55a3e0ce1002050945k7595d541lb04976344ff91431@mail.gmail.com>	 <4B6C931D.9020208@redhat.com> <55a3e0ce1002052126j2f6332bbw490f4d14e2cbbe16@mail.gmail.com>
In-Reply-To: <55a3e0ce1002052126j2f6332bbw490f4d14e2cbbe16@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Muralidharan Karicheri wrote:
> Mauro,
>> +       ret = copy_from_user(isif_raw_params,

>> It seems that you're defining some undocumented new userspace API here.
>>
> Yes. This supports an experimental, but necessary API that configures
> the ISIF (Image sensor Interface) image tuning parameters from
> User Space. These parameters are used when converting Bayer RGB image
> to UYVY format when capturing from sensors such as MT9T031.
> For SoCs like TI's DMxxx series, the user needs to have full control
> over these parameters to get desired image quality.
> This had been discussed during the initial version of vpfe-capture
> driver discussion and it was decided to keep them as experimental. So
> no
> documentation is provided at this time. The ioctls are defined in the
> vpfe_capture.h header file and the user space structures are under
> ccdc.h and isif.h under include/media/davinci and are marked as
> experimental.  This was also discussed  in this mailing list before
> and the decision taken at that time was to do it properly as part of
> media soc framework. In this framework, isif and other similar SoC
> hardware IPs will have a device node to configure these parameters
> and therefore will have to be re-worked once media soc framework is
> available.  Until then vpfe-capture users need to have a way to
> configure the ISIF or such hardware IPs.

So, it is not an experimental but a temporary API. We shouldn't add any
driver with temporary API's under /drivers, since API's are forever.
So, or submit it with the proper media soc framework or add the driver
at /staging.

Cheers,
Mauro
