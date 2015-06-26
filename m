Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:34293 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbbFZLAZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 07:00:25 -0400
Received: by ykfy125 with SMTP id y125so55025843ykf.1
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2015 04:00:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150626062210.6ee035ec@recife.lan>
References: <DB7ACFD5239247FCB3C1CA323B56E88D@unknown>
	<20150626062210.6ee035ec@recife.lan>
Date: Fri, 26 Jun 2015 07:00:24 -0400
Message-ID: <CAGoCfiyjRSxRrzdWVPREVaXoMK_iowu19n2+FJosg90UskumHA@mail.gmail.com>
Subject: Re: XC5000C 0x14b4 status
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Unembossed Name <severe.siberian.man@mail.ru>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> IMHO, the best is to get the latest firmware licensed is the best
> thing to do.
>
> Does that "new" xc5000c come with a firmware pre-loaded already?

I've got firmware here that is indicated as being for the xc5300 (i.e.
0x14b4).  That said, I am not sure if it's the same as the original
5000c firmware.  Definitely makes sense to do an I2C dump and compare
the firmware images since using the wrong firmware can damage the
part.

I'm not against an additional #define for the 0x14b4 part ID, but it
shouldn't be accepted upstream until we have corresponding firmware
and have seen the tuner working.  Do you have digital signal lock
working with this device under Linux and the issue is strictly with
part identification?

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
