Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc2-s9.bay0.hotmail.com ([65.54.190.84]:60221 "EHLO
	bay0-omc2-s9.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756581AbaDHJzM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Apr 2014 05:55:12 -0400
Message-ID: <BAY176-W115A9DC75C5AD0915C2AEEA96B0@phx.gbl>
From: Divneil Wadhawan <divneil@outlook.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: videobuf2-vmalloc suspect for corrupted data
Date: Tue, 8 Apr 2014 15:25:11 +0530
In-Reply-To: <53429F53.7050005@xs4all.nl>
References: <BAY176-W225B62F958527124202669A9680@phx.gbl>,<CAMm-=zDKUoFN7OiGpL3c=7KCkmYNhiyns20t8H7Pz_=qgaeHMw@mail.gmail.com>,<BAY176-W524A762315BE245FCCD5DCA9680@phx.gbl>,<53428483.7060107@xs4all.nl>,<BAY176-W91C143782DF21AB7ACEC8A9680@phx.gbl>,<53429F53.7050005@xs4all.nl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> That should be new enough, I see no important differences between 3.4
> and 3.14 in this respect. But really, 3.4?
We are moving to 3.10 shortly.

> Question: if you use MEMORY_MMAP instead of USERPTR, does that work?
Unfortunately, this activity is pending (need to get it pushed in plan). I need to port driver and app to do that.

> Have you tried to stream with v4l2-ctl? It's available here:
No, need to see.


Read a bit about vm_map_ram(), it gives a kernel vaddr for user pages in which the user vaddr are residing.
Can the virtually indexed D-cache be an issue here, or am I too paranoid?


I just checked on some webpage probably arm center, that D-caches are physically tagged, so, the above could be ruled out.

What about the architectures?


I will look into the driver more thoroughly, because, for kernel.org code, I am least skeptical.


Regards,
Divneil 		 	   		  