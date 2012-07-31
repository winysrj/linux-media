Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52804 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab2GaTqU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 15:46:20 -0400
Received: by gglu4 with SMTP id u4so6487943ggl.19
        for <linux-media@vger.kernel.org>; Tue, 31 Jul 2012 12:46:20 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 31 Jul 2012 16:46:19 -0300
Message-ID: <CALF0-+V3vsbByUobWLVKobDc0KPf6xVUktPk-U0e_87ifxk4pw@mail.gmail.com>
Subject: [Q] stk1160 on arm raspberrypi (but with issues)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I received some reports of stk1160 working on
the world famous ARM raspberrypi devices; with some changes to current code:

https://github.com/ezequielgarcia/stk1160-standalone/issues/5

This gently user did some changes on my suggestion and then could capture a png
with mplayer. However the image looks a little corrupted:

http://postimage.org/image/ksg9ji8d5/

1. I'd like to ask, if someone can (just looking at the capture)
guess the origin of the corruption: memory or bandwidth?

2. Also, I wonder if someone could explain me a bit, about DMA_NONCOHERENT
config.

I know you're probably very busy right now,
so I don't expect tons of answers;
but I'm sure many of you will be happy to know this is
(sort of) working on an ARM device.

Thanks,
Ezequiel.
