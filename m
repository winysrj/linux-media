Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:53507 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbZFKGqC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 02:46:02 -0400
Received: by wf-out-1314.google.com with SMTP id 26so495673wfd.4
        for <linux-media@vger.kernel.org>; Wed, 10 Jun 2009 23:46:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Jun 2009 15:46:04 +0900
Message-ID: <5e9665e10906102346v377b0047k54c10bdf8f7b6c0c@mail.gmail.com>
Subject: About V4L2_MEMORY_OVERLAY
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: v4l2_linux <linux-media@vger.kernel.org>
Cc: mchehab@redhat.com, Hans Verkuil <hverkuil@xs4all.nl>,
	magnus.damm@gmail.com, Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

What I'm curious is about what is V4L2_MEMORY_OVERLAY for. Even though
I have been using overlay capability before, I always used
V4L2_MEMORY_MMAP instead of that. And our v4l2 api document tells
nothing about V4L2_MEMORY_MMAP (only [todo] is left..OMG ;-()

But looking into videobuf, I can see some codes implemented for
V4L2_MEMORY_OVERLAY. But I'm not sure about which point can make
driver available for V4L2_MEMORY_OVERLAY.

If the implementation of that method is still in progress, can I have
any information or chance to participate? Until then I might be using
V4L2_MEMORY_MMAP in my camera interface driver.
Cheers,

Nate



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
