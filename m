Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39593 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab1KDNXM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Nov 2011 09:23:12 -0400
Message-ID: <4EB3E733.4000406@iki.fi>
Date: Fri, 04 Nov 2011 15:22:59 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 3.2-rc1] media updates part 2
References: <4EB3D7FC.7030507@redhat.com>
In-Reply-To: <4EB3D7FC.7030507@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Could you still try PULL some rather small Anysee changes for 3.2 I have 
requested two weeks ago?
http://patchwork.linuxtv.org/patch/8182/

Those are Common Interface support and new board layout for Anysee E7 T2C.


Antti


On 11/04/2011 02:18 PM, Mauro Carvalho Chehab wrote:
> Hi Linus,
>
> Please pull from:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
>
> For:
> 	- move cx25821 out of staging;
> 	  (acked by Greg KH)
> 	- move the remaining media staging drivers to drivers/staging/media;
> 	  (acked by Greg KH)
> 	- a new staging driver at drivers/staging/media: as102;
> 	- a huge pile of patches that will allow soc_camera sensors to be re-used by
> 	  other drivers;
> 	- a new driver for MaxLinear MxL111SF DVB-T devices;
> 	- A new Exynos4 driver (s5k6aa);
> 	- some other random driver fixes, board additions;
> 	- Support for single ITE 9135 devices;
> 	- a few minor improvements needed by some drivers (like adding support for devices
> 	  capable of auto-detecting illumination blinking frequency);
>
> Thanks!
> Mauro

-- 
http://palosaari.fi/
