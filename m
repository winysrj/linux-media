Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab1HDVtp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2011 17:49:45 -0400
Message-ID: <4E3B13E9.1060108@redhat.com>
Date: Thu, 04 Aug 2011 18:49:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	workshop-2011@linuxtv.org
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com> <Pine.LNX.4.64.1108042052070.31239@axis700.grange> <4E3B0237.7010209@redhat.com> <201108042238.22487.linux@baker-net.org.uk>
In-Reply-To: <201108042238.22487.linux@baker-net.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-08-2011 18:38, Adam Baker escreveu:
> On Thursday 04 August 2011, Mauro Carvalho Chehab wrote:
>>> That'd also be my understanding. There are already several standard ways 
>>> to access data on still cameras: mass-storage, PTP, MTP, why invent Yet 
>>> Another One? "Just" learn to share a device between several existing 
>>> drivers.
>>
>> For those that can export data into some fs-like way, this may be the
>> better way. It seems that gvfs does something like that. I've no idea how
>> easy or difficult would be to write Kernel driver for it.
> 
> As I understand it gvfs uses libgphoto2 and fuse and it is the interface 
> libghoto2 that is the problem. libgphoto2 contains lots of the same sort of 
> code to handle strange data formats from the camera as libv4l so I don't think 
> we want to be moving that code back into the kernel.(The old out of kernel 
> driver for sq905 before Theodore and I rewrote it contained code to do Bayer 
> decoding and gamma correction that was copied from libgphoto2).

I don't think we should move the entire libgphoto2 to kernel. For sure, format
conversions don't belong to Kernelspace. We just need to move the file handling
(e. g. PTP/MTP) to a kernel driver. Something might be needed for libgphoto2
to know what is the format of the images inside the filesystem, but this could
be just mapped as a file extension.
> 
> Regards
> 
> Adam Baker

