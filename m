Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2813 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0KPVmf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:42:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Ellingsworth <david@identd.dyndns.org>
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
Date: Tue, 16 Nov 2010 22:42:02 +0100
Cc: Andy Walls <awalls@md.metrocast.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <cover.1289740431.git.hverkuil@xs4all.nl> <201011162210.18000.hverkuil@xs4all.nl> <AANLkTikXkEZELQSEa6eQLobK7gpDe=_7+AawuxT3tjd5@mail.gmail.com>
In-Reply-To: <AANLkTikXkEZELQSEa6eQLobK7gpDe=_7+AawuxT3tjd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011162242.02446.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, November 16, 2010 22:32:57 David Ellingsworth wrote:
> Hans,
> 
> I've had some patches pending for a while now that affect the dsbr100
> driver. The patches can be seen here:
> http://desource.dyndns.org/~atog/gitweb/?p=linux-media.git in the
> dsbr100 branch. The first patch in the series fixes locking issues
> throughout the driver and converts it to use the unlocked ioctl. The
> series is a bit old, so it doesn't make use of the v4l2 core assisted
> locking; but that is trivial to implement after this patch.

Would it be a problem for you if for 2.6.37 I just replace .ioctl by
.unlocked_ioctl? And do the full conversion for 2.6.38? That way the
2.6.37 patches remain small.

Regards.

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
