Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758501Ab0DAQj7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 12:39:59 -0400
Message-ID: <4BB4A7C6.40207@redhat.com>
Date: Thu, 01 Apr 2010 11:03:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl>
In-Reply-To: <201004011001.10500.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi all,
> 
> I just read on LWN that the core kernel guys are putting more effort into
> removing the BKL. We are still using it in our own drivers, mostly V4L.
> 
> I added a BKL column to my driver list:
> 
> http://www.linuxtv.org/wiki/index.php/V4L_framework_progress#Bridge_Drivers
> 
> If you 'own' one of these drivers that still use BKL, then it would be nice
> if you can try and remove the use of the BKL from those drivers.
> 
> The other part that needs to be done is to move from using the .ioctl file op
> to using .unlocked_ioctl. Very few drivers do that, but I suspect almost no
> driver actually needs to use .ioctl.

The removal of BKL is generally as simple as review the locks inside the driver,
being sure that an ioctl won't interfere on another ioctl, or on open/close ops.

> On the DVB side there seem to be only two sources that use the BKL:
> 
> linux/drivers/media/dvb/bt8xx/dst_ca.c: lock_kernel();
> linux/drivers/media/dvb/bt8xx/dst_ca.c: unlock_kernel();
> linux/drivers/media/dvb/dvb-core/dvbdev.c:      lock_kernel();
> linux/drivers/media/dvb/dvb-core/dvbdev.c:              unlock_kernel();
> linux/drivers/media/dvb/dvb-core/dvbdev.c:      unlock_kernel();
> 
> At first glance it doesn't seem too difficult to remove them, but I leave
> that to the DVB experts.

The main issue is at dvbdev, since it is used by all devices. We need to get rid
of it.

That's said, Stefan Richter sent a patch meant to reduce the issues with
DVB. Unfortunately, I haven't seen any comments on it. It would be really important
to test his approach. It will probably come a time where the drivers that still
uses BKL will stop working, as they will remove BKL. I remember that, during KS/2009, 
it was proposed by someone to just mark all drivers that use BKL as BROKEN. This
didn't happen (yet), but I don't doubt it will happen on the next few kernel versions.

-- 

Cheers,
Mauro
