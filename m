Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:51654 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab1EWPca (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 11:32:30 -0400
Message-ID: <4DDA7E07.7070907@linuxtv.org>
Date: Mon, 23 May 2011 17:32:23 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FE_GET_PROPERTY should be _IOW, because the associated
 structure is transferred from userspace to kernelspace. Keep the old ioctl
 around for compatibility so that existing code is not broken.
References: <201105231558.13084.hselasky@c2i.net> <4DDA711E.3030301@linuxtv.org> <201105231651.55945.hselasky@c2i.net>
In-Reply-To: <201105231651.55945.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/23/2011 04:51 PM, Hans Petter Selasky wrote:
> On Monday 23 May 2011 16:37:18 Andreas Oberritter wrote:
>> On 05/23/2011 03:58 PM, Hans Petter Selasky wrote:
>>> From be7d0f72ebf4d945cfb2a5c9cc871707f72e1e3c Mon Sep 17 00:00:00 2001
>>> From: Hans Petter Selasky <hselasky@c2i.net>
>>> Date: Mon, 23 May 2011 15:56:31 +0200
>>> Subject: [PATCH] FE_GET_PROPERTY should be _IOW, because the associated
>>> structure is transferred from userspace to kernelspace. Keep the old
>>> ioctl around for compatibility so that existing code is not broken.
>>
> 
> Hi,
> 
>> Good catch, but I think _IOWR would be right, because the result gets
>> copied from kernelspace to userspace.
> 
> Those flags are only for the IOCTL associated structure itself. The V4L DVB 
> kernel only reads the dtv_properties structure in either case and does not 
> write any data back to it. That's why only _IOW is required.

I see.

> I checked somewhat and the R/W bits in the IOCTL command does not appear do be 
> matched to the R/W permissions you have on the file handle? Or am I mistaken?

You're right. There's no direct relationship between them, at least not
within dvb-core.

> In other words the IOCTL R/W (_IOC_READ, _IOC_WRITE) bits should not reflect 
> what the IOCTL actually does, like modifying indirect data?

I'm not sure. Your patch is certainly doing the right thing for the
current implementation of dvb_usercopy, which however wasn't designed
with variable length arrays in mind.

Taking dvb_usercopy aside, my interpretation of the ioctl bits was:
- _IOC_READ is required if copy_to_user/put_user needs to be used during
the ioctl.
- _IOC_WRITE is required if copy_from_user/get_user needs to be used
during the ioctl.

Whether that's limited to the structure directly encoded in the ioctl or
not is unclear to me. Maybe someone at LKML can shed some light on that.

Regards,
Andreas
