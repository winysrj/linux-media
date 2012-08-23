Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54556 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2HWGXC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 02:23:02 -0400
MIME-Version: 1.0
In-Reply-To: <3648908.jA5PYymWxV@avalon>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<3937256.gcqPRVoNWN@avalon>
	<1345528197.15491.8.camel@lappyti>
	<3648908.jA5PYymWxV@avalon>
Date: Thu, 23 Aug 2012 14:23:01 +0800
Message-ID: <CAGA24MLnW-i0koFuAsnFQ2mNnrLupkmbxW5T8WYiV3QuoA2vig@mail.gmail.com>
Subject: Re: [RFC 0/5] Generic panel framework
From: Jun Nie <niej0001@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
    Do you plan to add an API to get and parse EDID to mode list?
video mode is tightly coupled with panel that is capable of hot-plug.
Or you are busy on modifying EDID parsing code for sharing it amoung
DRM/FB/etc? I see you mentioned this in Mar. It is great if you are
considering add more info into video mode, such as pixel repeating, 3D
timing related parameter. I have some code for CEA modes filtering and
3D parsing, but still tight coupled with FB and with a little hack
style.

    My HDMI driver is implemented as lcd device as you mentioned here.
But more complex than other lcd devices for a kthread is handling
hot-plug/EDID/HDCP/ASoC etc.

    I also feel a little weird to add code parsing HDMI audio related
info in fbmod.c in my current implementation, thought it is the only
place to handle EDID in kernel. Your panel framework provide a better
place to add panel related audio/HDCP code. panel notifier can also
trigger hot-plug related feature, such as HDCP start.

    Looking forward to your hot-plug panel patch. Or I can help add it
if you would like me to.

Thanks!
Jun
