Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54609 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaFXPTI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 11:19:08 -0400
Received: by mail-oa0-f43.google.com with SMTP id o6so503165oag.30
        for <linux-media@vger.kernel.org>; Tue, 24 Jun 2014 08:19:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7uDVL+s9aY-erktyKeUbmd2=49r=nDZXPRCZ8dcSjmCoA@mail.gmail.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<CA+2YH7uDVL+s9aY-erktyKeUbmd2=49r=nDZXPRCZ8dcSjmCoA@mail.gmail.com>
Date: Tue, 24 Jun 2014 17:19:08 +0200
Message-ID: <CA+2YH7urbO6C-a6UMB+1JKN2z7F0CDmqh0184cCzXHbW1ADfXA@mail.gmail.com>
Subject: Re: [PATCH 00/11] OMAP3 ISP BT.656 support
From: Enrico <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 27, 2014 at 10:38 AM, Enrico <ebutera@users.berlios.de> wrote:
> On Mon, May 26, 2014 at 9:50 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hello,
>>
>> This patch sets implements support for BT.656 and interlaced formats in the
>> OMAP3 ISP driver. Better late than never I suppose, although given how long
>> this has been on my to-do list there's probably no valid excuse.
>
> Thanks Laurent!
>
> I hope to have time soon to test it :)

Hi Laurent,

i wanted to try your patches but i'm having a problem (probably not
caused by your patches).

I merged media_tree master and omap3isp branches, applied your patches
and added camera platform data in pdata-quirks, but when loading the
omap3-isp driver i have:

omap3isp: clk_set_rate for cam_mclk failed

The returned value from clk_set_rate is -22 (EINVAL), but i can't see
any other debug message to track it down. Any ides?
I'm testing it on an igep proton (omap3530 version).

Thanks,

Enrico
