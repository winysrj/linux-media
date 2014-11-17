Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:39664 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaKQSXa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 13:23:30 -0500
Received: by mail-lb0-f181.google.com with SMTP id l4so16690296lbv.12
        for <linux-media@vger.kernel.org>; Mon, 17 Nov 2014 10:23:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAM_ZknVe-ciJBeTLy5FFuGyue=s=wdVJLLdWEzEGQjoFfOffTA@mail.gmail.com>
References: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com>
	<CAM_ZknVe-ciJBeTLy5FFuGyue=s=wdVJLLdWEzEGQjoFfOffTA@mail.gmail.com>
Date: Mon, 17 Nov 2014 16:23:27 -0200
Message-ID: <CAOMZO5An4UVLo9NAR6MRQ48vDRQs+ZXt2YghZ+4nnT6tizWOYg@mail.gmail.com>
Subject: Re: Using the coda driver with Gstreamer
From: Fabio Estevam <festevam@gmail.com>
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
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

Hi Andrey,

On Mon, Nov 17, 2014 at 3:48 PM, Andrey Utkin
<andrey.utkin@corp.bluecherry.net> wrote:
> could you give `lspci -v` so that i see what module is a driver for
> that component?

I am using a mx6 processor that has a built-in hardware video
encoder/decoder. The driver is located at drivers/media/platform/coda/

Thanks
