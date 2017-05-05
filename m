Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36587 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755839AbdEETvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 15:51:00 -0400
Received: by mail-wm0-f68.google.com with SMTP id u65so3274556wmu.3
        for <linux-media@vger.kernel.org>; Fri, 05 May 2017 12:50:59 -0700 (PDT)
Date: Fri, 5 May 2017 21:50:56 +0200
From: Thomas Hollstegge <thomas.hollstegge@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] em28xx: support for Sundtek MediaTV Digital Home
Message-ID: <20170505195054.GA29473@googlemail.com>
References: <20170504222115.GA26659@googlemail.com>
 <CA+O4pCJqqSqE_YFDM6unU8pvuVoRJijkNOv64AWD6CPdbxD5qA@mail.gmail.com>
 <20170505154435.GA18161@googlemail.com>
 <CA+O4pCKDyADH+Bx8Mxd01jCzU3vefRK6JLLYFDMuXdbZxToDtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+O4pCKDyADH+Bx8Mxd01jCzU3vefRK6JLLYFDMuXdbZxToDtw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

Markus Rechberger <mrechberger@gmail.com> schrieb am Sat, 06. May 00:33:
> We had different HW designs based on Empia until 2012 using this USB
> ID it will not work with many units out there, also with different
> standby behaviours, chipsets etc.

Well, after this patch there's one more device that works with an
open-source driver, which I consider a good thing. What about
open-sourcing support for the other devices you're talking about?

> If you want to get a device with kernel support I recommend buying a
> different one and let that one go back to our community (since our
> tuners and support are still quite popular).

Thanks, but I'd rather stick with the device I have than spending more
money to have a device that only works with a closed-source driver.

Anyway, I just saw that the patch doesn't apply cleanly against
linux-media master. I'll submit a new version of the patch in a
minute.

Cheers
Thomas
