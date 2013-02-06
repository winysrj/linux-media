Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:42039 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3BFN1F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 08:27:05 -0500
Received: by mail-oa0-f43.google.com with SMTP id l10so1470494oag.30
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 05:27:03 -0800 (PST)
MIME-Version: 1.0
From: Adriano Martins <adrianomatosmartins@gmail.com>
Date: Wed, 6 Feb 2013 11:26:43 -0200
Message-ID: <CAJRKTVo279P0dqTxqoQLLpyRQYn8HNDpE6=csk1pV46E7hQp4g@mail.gmail.com>
Subject: omap3isp - set_xclk dont work
To: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have 2 boards with DM3730 processor, a beagleboard  and a custom
board.  The omap3isp is working in both boards, any error is seen. On
beagleboard I can see the xclka, then the sensor is detected and the
driver is load correctly.
But, in the custom board, every seem work, there are no errors too.
But I can't see the xclka signal.

The hardware is ok. Because, I load another driver that uses the
camera bus. The xclka is working.

it is the same processor, same kernel version, same driver.
Why, it work in one, and not another.

Someone can help me? please.

Thanks

Regards
Adriano Martins
