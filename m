Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757663Ab0DAQoi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 12:44:38 -0400
Message-ID: <4BB4B15B.2040302@redhat.com>
Date: Thu, 01 Apr 2010 11:44:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl> <201004011411.02344.laurent.pinchart@ideasonboard.com> <4BB4A9E2.9090706@redhat.com> <201004011630.06159.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201004011630.06159.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:

>> One typical problem that I see is that some drivers register too soon: they
>> first register, then initialize some things. I've seen (and fixed) some
>> race conditions due to that. Just moving the register to the end solves
>> this issue.
> 
> That's right, devices should not be registered until they are ready to be 
> opened by userspace. However, I don't see how that's related to the BKL.

Before the BKL changes, open were allowed only after the full module loading.

>> One (far from perfect) solution, would be to add a mutex protecting the
>> entire ioctl loop inside the drivers, and the open/close methods. This can
>> later be optimized by a mutex that will just protect the operations that
>> can actually cause problems if happening in parallel.
> 
> The BKL protects both open() and ioctl(), but the ioctl operation can't be 
> called before open succeeds anyway, so I'm not sure we have a problem there.

You may have, as one file handler may be doing an ioctl, while another application
opens or closes another file handler. Depending on what the driver have on the open
handler, it might interfere on the ioctl.

> The real problem is that most drivers rely on ioctls being serialized by the 
> BKL. The drivers need to be fixed on a case by case basis, but we could 
> already drop the BKL there by using a V4L-specific lock to serialize ioctl 
> calls.

Yes, that's my point. It is not hard to write such patch, moving from BKL to an
ioctl/open/close mutex, and it should be safe, provided that it doesn't introduce
any dead lock with some existing mutexes.

-- 

Cheers,
Mauro
