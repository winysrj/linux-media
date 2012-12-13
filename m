Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35341 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336Ab2LMOOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:03 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so3917397ieb.19
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2012 06:14:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGGh5h1TB-=YqM0m-xbC7q7Y-AtzxYAhm+wUGSqTeO51PA25aA@mail.gmail.com>
References: <CAGGh5h0dVOsT-PCoCBtjj=+rLzViwnM2e9hG+sbWQk5iS-ThEQ@mail.gmail.com>
	<2747531.0sXdUv33Rd@avalon>
	<CAGGh5h13mOVtWPLGowvtvZM1Ufx2PST3DCokJzspGFcsUo=FiA@mail.gmail.com>
	<2243690.V1TtfkZKP0@avalon>
	<CAGGh5h1TB-=YqM0m-xbC7q7Y-AtzxYAhm+wUGSqTeO51PA25aA@mail.gmail.com>
Date: Thu, 13 Dec 2012 15:14:02 +0100
Message-ID: <CAGGh5h23vLD=L1D2PHwQD8XeT8edypcSx=kbf7aATQUCfQ14zg@mail.gmail.com>
Subject: Re: Lockup on second streamon with omap3-isp
From: jean-philippe francois <jp.francois@cynove.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have news on the "IRQ storm on second streamon" problem.
Reminder :
Given a perfectly fine HSYNC / VSYNC / PIXELCLOK configuration, the
omap3-isp (at least until 3.4) will go into an interrupt storm when
streamon is called for the second time, unless you are able to stop
the sensor when not streaming. I have reproduced this on three
different board, with three different sensor.

On board 1, the problem disappeared by itself (in fact not by itself,
see below) and the board is not in my possession anymore.
On board 2, I implemented a working s_stream operation in the subdev
driver, so the problem was solved because the sensor would effectively
stop streaming when told to, keeping the ISP + CCDC happy
On board 3, I can't stop the streaming, or I did not figure out how to
make it stop  yet.

I tried to disable the HS_VS_IRQ, but it did not help, so I came back
looking at the code of board 1, which was running fine with a 3.4
kernel. And I discovered the problem doesn't happen if I break the
pipeline between two consecutive streamon.

In other word if I do the following :

media-ctl -l '16:0->5:0[1], 5:1->6:0[1]'
media-ctl -f '16:0 [SBGGR8 2560x800 (0, 0)/2560x800]'
yavta ....
yavta ...       <--------- board locks up, soft lockup is fired

But if I do this instead :

media-ctl -l '16:0->5:0[0], 5:1->6:0[0]'
media-ctl -l '16:0->5:0[1], 5:1->6:0[1]'
media-ctl -f '16:0 [SBGGR8 2560x800 (0, 0)/2560x800]'
yavta ....
media-ctl -l '16:0->5:0[0], 5:1->6:0[0]'
media-ctl -l '16:0->5:0[1], 5:1->6:0[1]'
media-ctl -f '16:0 [SBGGR8 2560x800 (0, 0)/2560x800]'
yavta ...       <--------- image are acquired, board doesn't lock up anymore

It would be interesting to go from this workaround to the elimination of
the root cause. What can I do / test next to stop this bug from hapenning ?

Regards,
Jean-Philippe François
