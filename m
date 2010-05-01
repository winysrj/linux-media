Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:64849 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0EAKr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 May 2010 06:47:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 0/5] Pushdown bkl from v4l ioctls
Date: Sat, 1 May 2010 12:47:44 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	John Kacur <jkacur@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Blunck <jblunck@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg KH <gregkh@suse.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org> <201004290910.43412.laurent.pinchart@ideasonboard.com> <201005011155.37057.hverkuil@xs4all.nl>
In-Reply-To: <201005011155.37057.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201005011247.45273.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 01 May 2010 11:55:37 Hans Verkuil wrote:
> However, I do think it would be better to
> create a video_ioctl2_bkl rather than add a video_ioctl2_unlocked. The current
> video_ioctl2 function is already unlocked. So you are subtle changing the
> behavior of video_ioctl2. Not a good idea IMHO. And yes, grepping for
> video_ioctl2_bkl is also easy to do and makes it more obvious that the BKL is
> used in drivers that call this.

Yes, that makes sense. It also allows working towards a goal of 'removing
video_ioctl2_bkl', which is easier to understand than 'converting video_ioctl2
users to video_ioctl2_unlocked and later renaming that'.

	Arnd
