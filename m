Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:58464 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbbBSXdd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 18:33:33 -0500
Received: by mail-ob0-f179.google.com with SMTP id wp4so20819115obc.10
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2015 15:33:32 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 19 Feb 2015 23:33:32 +0000
Message-ID: <CAJ+AEyMT6etRK6cj6s2iwNHW3QG4mh7TVdPeNvVKKSBAJU9ztA@mail.gmail.com>
Subject: DVBSky T982 (Si2168) Questions/Issues/Request
From: Eponymous - <the.epon@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

I have a couple of issues with the si2168.c dvb-frontend in kernel v
3.19.0. To get the firnware to load I've had to increase the #define
TIMEOUT to 150 from 50. I read another post
(http://www.spinics.net/lists/linux-media/msg84198.html) where another
user had to do the same modification.

@ Antti Palosaari: Since the 50ms value you came up with was just
based on some "trail and error", would it be possible to submit a
change upstream to increase this timeout since it's likely others are
going to encounter this issue?

The second issue I have is that where I am based (UK) we have both
DVB-T and DVB-T2 muxes and I can't get a single tuner to be able to
tune to both transports, but looking through the Si2168.c code, I'm
having trouble working out how (if at all) this is achieved?

It's not the case where we can only tune to DVB-T OR DVB-T2 is it? If
so, that's far from ideal...

Are there any workarounds if true?

Best regards.

Sean.
