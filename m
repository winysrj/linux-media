Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:33479 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaKQT6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 14:58:08 -0500
Received: by mail-la0-f49.google.com with SMTP id ge10so18469895lab.8
        for <linux-media@vger.kernel.org>; Mon, 17 Nov 2014 11:58:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141117185554.GW25554@pengutronix.de>
References: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com>
	<20141117185554.GW25554@pengutronix.de>
Date: Mon, 17 Nov 2014 17:58:06 -0200
Message-ID: <CAOMZO5DGR=Y1MVAc46OG6f26s9kEAoT+XCXgyezFOefM6H_NQg@mail.gmail.com>
Subject: Re: Using the coda driver with Gstreamer
From: Fabio Estevam <festevam@gmail.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Mon, Nov 17, 2014 at 4:55 PM, Robert Schwebel
<r.schwebel@pengutronix.de> wrote:

> Philipp is on vacation this week, he can have a look when he is back in
> the office next monday.

Thanks for letting me know.

> Just a wild guess - we usually test here with dmabuf capable devices and
> without X. As you are using gstglimagesink, the code around
> ext/gl/gstglimagesink.c (453) looks like gst_gl_context_create() went
> wrong. Does your GL work correctly? Maybe you can test the glimagesink
> with a simpler pipeline first.

Yes, maybe it would be better to remove X from my initial tests. I
will give it a try.

Thanks for the suggestions.

Regards,

Fabio Estevam
