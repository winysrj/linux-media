Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3099 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544Ab0DARhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 13:37:11 -0400
Received: from tschai.localnet (cm-84.208.87.21.getinternet.no [84.208.87.21])
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id o31Hb9Ju036619
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 1 Apr 2010 19:37:09 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC] Serialization flag example
Date: Thu, 1 Apr 2010 19:37:39 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011937.39331.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I made a quick implementation which is available here:

http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-serialize

It's pretty easy to use and it also gives you a very simple way to block
access to the video device nodes until all have been allocated by simply
taking the serialization lock and holding it until we are done with the
initialization.

I converted radio-mr800.c and ivtv.

That said, almost all drivers that register multiple device nodes probably
suffer from a race condition when one of the device node registrations
returns an error and all devices have to be unregistered and the driver
needs to release all resources.

Currently most if not all drivers just release resources and free the memory.
But if an application managed to open one device before the driver removes it
again, then we have almost certainly a crash.

It is possible to do this correctly in the driver, but it really needs core
support where a release callback can be installed in v4l2_device that is
called when the last video_device is closed by the application.

We already can cleanup correctly after the last close of a video_device, but
there is no top-level release yet.


Anyway, I tried to use the serialization flag in bttv as well, but I ran into
problems with videobuf. Basically when you need to wait for some event you
should release the serialization lock and grab it after the event arrives.

Unfortunately videobuf has no access to v4l2_device at the moment. If we would
have that, then videobuf can just release the serialization lock while waiting
for something to happen.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
