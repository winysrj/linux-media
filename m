Return-path: <linux-media-owner@vger.kernel.org>
Received: from woodbine.london.02.net ([87.194.255.145]:53827 "EHLO
	woodbine.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1HDVi1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 17:38:27 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
Date: Thu, 4 Aug 2011 22:38:22 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	workshop-2011@linuxtv.org
References: <4E398381.4080505@redhat.com> <Pine.LNX.4.64.1108042052070.31239@axis700.grange> <4E3B0237.7010209@redhat.com>
In-Reply-To: <4E3B0237.7010209@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108042238.22487.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 04 August 2011, Mauro Carvalho Chehab wrote:
> > That'd also be my understanding. There are already several standard ways 
> > to access data on still cameras: mass-storage, PTP, MTP, why invent Yet 
> > Another One? "Just" learn to share a device between several existing 
> > drivers.
> 
> For those that can export data into some fs-like way, this may be the
> better way. It seems that gvfs does something like that. I've no idea how
> easy or difficult would be to write Kernel driver for it.

As I understand it gvfs uses libgphoto2 and fuse and it is the interface 
libghoto2 that is the problem. libgphoto2 contains lots of the same sort of 
code to handle strange data formats from the camera as libv4l so I don't think 
we want to be moving that code back into the kernel.(The old out of kernel 
driver for sq905 before Theodore and I rewrote it contained code to do Bayer 
decoding and gamma correction that was copied from libgphoto2).

Regards

Adam Baker
