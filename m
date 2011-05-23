Return-path: <mchehab@pedra>
Received: from mailfe04.c2i.net ([212.247.154.98]:55226 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755479Ab1EWOxJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 10:53:09 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH] FE_GET_PROPERTY should be _IOW, because the associated structure is transferred from userspace to kernelspace. Keep the old ioctl around for compatibility so that existing code is not broken.
Date: Mon, 23 May 2011 16:51:55 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201105231558.13084.hselasky@c2i.net> <4DDA711E.3030301@linuxtv.org>
In-Reply-To: <4DDA711E.3030301@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231651.55945.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 23 May 2011 16:37:18 Andreas Oberritter wrote:
> On 05/23/2011 03:58 PM, Hans Petter Selasky wrote:
> > From be7d0f72ebf4d945cfb2a5c9cc871707f72e1e3c Mon Sep 17 00:00:00 2001
> > From: Hans Petter Selasky <hselasky@c2i.net>
> > Date: Mon, 23 May 2011 15:56:31 +0200
> > Subject: [PATCH] FE_GET_PROPERTY should be _IOW, because the associated
> > structure is transferred from userspace to kernelspace. Keep the old
> > ioctl around for compatibility so that existing code is not broken.
> 

Hi,

> Good catch, but I think _IOWR would be right, because the result gets
> copied from kernelspace to userspace.

Those flags are only for the IOCTL associated structure itself. The V4L DVB 
kernel only reads the dtv_properties structure in either case and does not 
write any data back to it. That's why only _IOW is required.

I checked somewhat and the R/W bits in the IOCTL command does not appear do be 
matched to the R/W permissions you have on the file handle? Or am I mistaken?

In other words the IOCTL R/W (_IOC_READ, _IOC_WRITE) bits should not reflect 
what the IOCTL actually does, like modifying indirect data?

> 
> It would be nice if you could send future patches inline rather than
> attached. I'd suggest using git format-patch and git send-email.

I will try to have a look at that. I'm waiting for the 16 patches I've 
submitted today to get reviewed and committed, before I start the next batch.

Thank you!

--HPS
