Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:35431 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbbFZLEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 07:04:21 -0400
Received: by ykdy1 with SMTP id y1so55022127ykd.2
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2015 04:04:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2DCE24E5218441A2AD205B5EA707CB62@unknown>
References: <DB7ACFD5239247FCB3C1CA323B56E88D@unknown>
	<20150626062210.6ee035ec@recife.lan>
	<2DCE24E5218441A2AD205B5EA707CB62@unknown>
Date: Fri, 26 Jun 2015 07:04:20 -0400
Message-ID: <CAGoCfixD8VwQX9jB8a3_8urGu4y3D+x=JhZvq8PbpTpPcqrGzQ@mail.gmail.com>
Subject: Re: XC5000C 0x14b4 status
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Unembossed Name <severe.siberian.man@mail.ru>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> It's not "new" IC. It's XC5000C. Maybe i was interpreted wrong.
> As I have understood, such behaviour can depends from FW version.
> HW vendor says, that with his latest FW he always gets response 0x14b4.

Ah, so you're running a completely different firmware image?  Well in
that case that would explain the different response for the firmware
loaded indication.

> Not a 0x1388. And I think, that these ICs still come without pre-loaded FW.
> HW vendor also didn't says anything about FW pre-load possibility.

Correct.  These are not parts that have any form of default firmware
in their ROM mask (i.e. not like the silabs or micronas parts which
have a default firmware and the ability to patch the ROM via a
software loaded code update).  The firmware must be loaded every time
the chip is brought out of reset or it won't work at all.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
