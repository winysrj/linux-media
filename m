Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1896 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0ISVSV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 17:18:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: RFC: BKL, locking and ioctls
Date: Sun, 19 Sep 2010 23:17:57 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <201009191229.35800.hverkuil@xs4all.nl> <4C967082.3040405@redhat.com> <1284930151.2079.156.camel@morgan.silverblock.net>
In-Reply-To: <1284930151.2079.156.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009192317.57761.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, September 19, 2010 23:02:31 Andy Walls wrote:
> Hans,
> 
> On an somewhat related note, but off-topic: what is the proper way to
> implement VIDIOC_QUERYCAP for a driver that implements read()
> on /dev/video0 (MPEG) and mmap() streaming on /dev/video32 (YUV)?
> 
> I'm assuming the right way is for VIDIOC_QUERYCAP to return different
> caps based on which device node was queried.

The spec is not really clear about this. It would be the right thing to do
IMHO, but the spec would need a change.

The caps that are allowed to change between device nodes would have to be
clearly documented. Basically only the last three in the list, and the phrase
'The device supports the...' should be replaced with 'The device node supports
the...'.

It would need some analysis and an RFC as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
