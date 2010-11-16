Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:52548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867Ab0KPPMl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 10:12:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
Date: Tue, 16 Nov 2010 16:13:12 +0100
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <cover.1289740431.git.hverkuil@xs4all.nl> <201011161522.19758.arnd@arndb.de> <b8ec38c9574d2b83b5e9bf9fd0bb45c1.squirrel@webmail.xs4all.nl>
In-Reply-To: <b8ec38c9574d2b83b5e9bf9fd0bb45c1.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011161613.12698.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 16 November 2010, Hans Verkuil wrote:
> A pointer to this struct is available in vdev->v4l2_dev. However, not all
> drivers implement struct v4l2_device. But on the other hand, most relevant
> drivers do. So as a fallback we would still need a static mutex.

Wouldn't that suffer the same problem as putting the mutex into videodev
as I suggested? You said that there are probably drivers that need to
serialize between multiple devices, so if we have a mutex per v4l2_device,
you can still get races between multiple ioctl calls accessing the same
per-driver data. To solve this, we'd have to put the lock into a per-driver
structure like v4l2_file_operations or v4l2_ioctl_ops, which would add
to the ugliness.

	Arnd
