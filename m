Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50516 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab1F0A7c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2011 20:59:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] Stop using linux/version.h on most drivers
Date: Mon, 27 Jun 2011 02:59:38 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	LKML <linux-kernel@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jesper Juhl <jj@chaosbits.net>, trivial@kernel.org,
	linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
	Sage Weil <sage@newdream.net>, Mike Isely <isely@isely.net>,
	Hans De Goede <hdegoede@redhat.com>,
	"Jean-Francois Moine" <moinejf@free.fr>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net> <201106251209.21228.hverkuil@xs4all.nl> <4E05D13A.6030209@redhat.com>
In-Reply-To: <4E05D13A.6030209@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106270259.38405.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Saturday 25 June 2011 14:14:50 Mauro Carvalho Chehab wrote:
> Em 25-06-2011 07:09, Hans Verkuil escreveu:
> > On Friday, June 24, 2011 20:25:26 Mauro Carvalho Chehab wrote:

[snip]

> 	- uvcvideo: not sure about its current status about its migration to
> video_ioctl2. If Laurent is not doing a migration to video_ioctl2 any time
> soon, a simple patch for it could make it act consistently. In any case, I
> don't think we should create a include/media/version.h just due to
> uvcvideo.

That's not on my todo-list for now, -EBUSY :-)

I bump the uvcvideo driver version whenever the userspace API changes. Using 
the kernel version number applications could find out whether the API they 
need is implemented, but detecting API changes would become more difficult. 
That might not be a real issue though, as applications usually don't care.

-- 
Regards,

Laurent Pinchart
