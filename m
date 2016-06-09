Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35322 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661AbcFIRiY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2016 13:38:24 -0400
Received: by mail-pa0-f43.google.com with SMTP id hl6so15170613pac.2
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2016 10:38:23 -0700 (PDT)
Subject: Re: dvb-core: how should i2c subdev drivers be attached?
References: <52775753-47c4-bfdf-b8f5-48bdf8ceb6e5@gmail.com>
 <20160609122449.5cfc16cc@recife.lan>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
From: Akihiro TSUKADA <tskd08@gmail.com>
Message-ID: <7bad6df3-ae9b-2e2f-3718-830d59e12513@gmail.com>
Date: Fri, 10 Jun 2016 02:38:14 +0900
MIME-Version: 1.0
In-Reply-To: <20160609122449.5cfc16cc@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

thanks for the replys.

so, the new i2c "attach" helper code should
1. be usable for V4L2-DVB multi-functional(hybrid) tuner devices
   (or at least co-exist well with them),
2. properly ref-count driver module
   to prevent (accidental) 'unload before use' by users.
3. a. block un-binding of the device while in use,
   b. support run-time {un-,}binding of the devices
      via sysfs by users (to switch drivers?).
Is this right?

> I guess we should discuss a way of doing it that will be acceptable
> on existing drivers. Perhaps you should try to do such change for
> an hybrid driver like em28xx or cx231xx. There are a few ISDB-T
> devices using them. Not sure how easy would be to find one of those
> in Japan, though.

I'll look into those drivers' code, to begin with.
(I'm pretty sure those devices are hardly found here in Japan).

> I'm now helping to to maintain Kaffeine upstream. I recently added
> support for both ISDB-T and DVB-T2. It would be nice if you could
> add support there for ISDB-S too.

All the channels in ISDB-S are scrambled,
unlike ISDB-T(jp) where non-scrambled '1-seg' channels are delivered.
In Japan, it will be considered illegal to desramble them with
a non-authorized software that lacks private copy-guard encryption.
So, unfortunately, there will be no legitimate OSS player for ISDB-S.

regards,
akihiro

