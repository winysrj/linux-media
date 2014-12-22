Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:39763 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbaLVM7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 07:59:30 -0500
Received: by mail-yk0-f181.google.com with SMTP id 142so2198582ykq.12
        for <linux-media@vger.kernel.org>; Mon, 22 Dec 2014 04:59:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1419191964-29833-1-git-send-email-zzam@gentoo.org>
References: <1419191964-29833-1-git-send-email-zzam@gentoo.org>
Date: Mon, 22 Dec 2014 07:59:29 -0500
Message-ID: <CALzAhNVkW3spVHVi0h--1XDp+1ekR1Z+v-FBYX61wf5Bj1H7wg@mail.gmail.com>
Subject: Re: [PATCH] cx23885: Split Hauppauge WinTV Starburst from HVR4400
 card entry
From: Steven Toth <stoth@kernellabs.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 21, 2014 at 2:59 PM, Matthias Schwarzott <zzam@gentoo.org> wrote:
> Unconditionally attaching Si2161/Si2165 demod driver
> breaks Hauppauge WinTV Starburst.
> So create own card entry for this.
>
> Add card name comments to the subsystem ids.
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Matthias,

Thank you for your work. However, nobody knows or cares what
'STARBURST' is. When I created the original driver I was careful to
name the card identified to match the actual hardware names that were
sold in retail, this eases future maintenance for people with no
knowledge of the hardware and makes Linux support for the HVR550 much
more obvious in google.

Please change CX23885_BOARD_HAUPPAUGE_STARBURST to
CX23885_BOARD_HAUPPAUGE_HVR5500.

Thanks,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
