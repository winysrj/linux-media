Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:59995 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbZETLsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 07:48:06 -0400
Received: by wf-out-1314.google.com with SMTP id 26so131414wfd.4
        for <linux-media@vger.kernel.org>; Wed, 20 May 2009 04:48:08 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 May 2009 20:48:08 +0900
Message-ID: <5e9665e10905200448n1ffc9d8s20317bbbba745e6a@mail.gmail.com>
Subject: About VIDIOC_G_OUTPUT/S_OUTPUT ?
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"dongsoo45.kim@samsung.com" <dongsoo45.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

Doing a new camera interface driver job of new AP from Samsung, a
single little question doesn't stop making me confused.
The camera IP in Samsung application processor supports for two of
output paths, like "to memory" and "to LCD FIFO".
It seems to be VIDIOC_G_OUTPUT/S_OUTPUT which I need to use (just
guessing), but according to Hans's ivtv driver the "output" of
G_OUTPUT/S_OUTPUT is supposed to mean an actually and physically
separated real output path like Composite, S-Video and so on.

Do you think that memory or LCD FIFO can be an "output" device in this
case? Because in earlier version of my driver, I assumed that the "LCD
FIFO" is a kind of "OVERLAY" device, so I didn't even need to use
G_OUTPUT and S_OUTPUT to route output device. I'm just not sure about
which idea makes sense. or maybe both of them could make sense
indeed...
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
