Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:44484 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbZFDLOu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 07:14:50 -0400
Received: by pxi12 with SMTP id 12so676231pxi.33
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2009 04:14:51 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 4 Jun 2009 20:14:51 +0900
Message-ID: <5e9665e10906040414v1a78b1d0x480b82d2235c75ba@mail.gmail.com>
Subject: What alternative way could be possible for initializing sensor
	rigistors?
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	=?EUC-KR?B?uc66tMij?= <bhmin@samsung.com>,
	=?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

In subdev framework, we already have "init" API  but not recommended
for new drivers to use this. But I'm so frustrated for the absence of
that kind of API.

I'm working on camera driver which needs to programme registors
through I2C bus and just stuck figuring out how to make it programmed
in device open (in this case, camera interface should be opened)
procedure. So, if I have no chance to use "init" API with implementing
my driver, which API should be used? Actually without "init" API, I
should make my driver to programme initializing registors in s_fmt or
s_parm sort of APIs.

Any other alternative API is served in subdev framework? Please let me
know if there is something I missed. BTW, subdev framework is really
cool. Totally arranged and easy to use.
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
