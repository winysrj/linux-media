Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:36613 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbcLRJGN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Dec 2016 04:06:13 -0500
Date: Sun, 18 Dec 2016 18:06:10 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v5 2/6] [media] rc-main: split setup and unregister
 functions
Message-id: <20161218090610.2whlhabeoxx74ldu@gangnam.samsung>
References: <20161216061218.5906-1-andi.shyti@samsung.com>
 <20161216061218.5906-3-andi.shyti@samsung.com>
 <20161216121026.GA31618@gofer.mess.org>
 <CGME20161216141636epcas4p16388dfbda7e061e0d1c3809fcad3b8fd@epcas4p1.samsung.com>
 <20161216141629.GA32757@gofer.mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20161216141629.GA32757@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> On Fri, Dec 16, 2016 at 12:10:26PM +0000, Sean Young wrote:
> > Sorry to add to your woes, but there are some checkpatch warnings and
> > errors. Please can you correct these. One is below.
> 
> Actually, the changes are pretty minor, I can fix them up before sending
> them to Mauro. Sorry for bothering you.

yes, it's an error on the previous code:

ERROR: do not initialise statics to false
#109: FILE: drivers/media/rc/rc-main.c:1521:
+       static bool raw_init = false; /* raw decoders loaded? */

total: 1 errors, 0 warnings, 196 lines checked

I noticed this already before, but I preferred to leave it
in its original status.

No worries, if you want I will send the fix, it's indeed quite
an easy fix.

Thanks,
Andi
