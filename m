Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42694 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2IDIUj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2012 04:20:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAGA24MLnW-i0koFuAsnFQ2mNnrLupkmbxW5T8WYiV3QuoA2vig@mail.gmail.com>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<3937256.gcqPRVoNWN@avalon>
	<1345528197.15491.8.camel@lappyti>
	<3648908.jA5PYymWxV@avalon>
	<CAGA24MLnW-i0koFuAsnFQ2mNnrLupkmbxW5T8WYiV3QuoA2vig@mail.gmail.com>
Date: Tue, 4 Sep 2012 16:20:38 +0800
Message-ID: <CAJATT-5=kQzUaubL--oRJdm6u8Z10Hus+SMLt3zG1ZSi4QUVWw@mail.gmail.com>
Subject: Re: [RFC 0/5] Generic panel framework
From: Zhou Zhu <zzhu84@gmail.com>
To: Jun Nie <niej0001@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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

Basically I agree that we need a common panel framework. I just have
some questions:
1.  I think we should add color format in videomode - if we use such
common video mode structure shared across subsystems.
In HDMI, colors are bind with timings tightly. We need a combined
videomode with timing and color format together.
2. I think we should add "set_videomode" interface. It helps HDMI
monitors to set EDIDs.

-- 
Thanks,
-Zhou
