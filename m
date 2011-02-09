Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37122 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab1BIWmQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 17:42:16 -0500
Received: by eye27 with SMTP id 27so482420eye.19
        for <linux-media@vger.kernel.org>; Wed, 09 Feb 2011 14:42:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102092336.20812.martin@pibbs.de>
References: <201102082305.24897.martin@pibbs.de>
	<201102092244.49176.martin@pibbs.de>
	<AANLkTimPQJ6+uJ1kY=-HPmg0x1mouB_ZJmdAQxjQbwdg@mail.gmail.com>
	<201102092336.20812.martin@pibbs.de>
Date: Wed, 9 Feb 2011 17:42:15 -0500
Message-ID: <AANLkTimST51rWpp9G3a6kds6eqM+dupWu=MyEJtTYZNs@mail.gmail.com>
Subject: Re: em28xx: board id [eb1a:2863 eMPIA Technology, Inc] Silver Crest
 VG2000 "USB 2.0 Video Grabber"
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Martin Seekatz <martin@pibbs.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 9, 2011 at 5:36 PM, Martin Seekatz <martin@pibbs.de> wrote:
> Hello Devin,
>
> I mean that list
> http://www.kernel.org/doc/Documentation/video4linux/CARDLIST.em28xx

It actually is there:

29 -> EM2860/TVP5150 Reference Design

If the vendor did not build the hardware with its own unique USB ID
(because they were lazy), the best we can do is refer to it by the
above name (since we would not be able to distinguish between the
Silvercrest and all the other clones).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
