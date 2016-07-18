Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38002 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbcGRTmO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 15:42:14 -0400
MIME-Version: 1.0
In-Reply-To: <1468851368.2994.54.camel@pengutronix.de>
References: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
 <1468845736-19651-10-git-send-email-ricardo.ribalda@gmail.com>
 <1468847611.2994.22.camel@pengutronix.de> <CAPybu_3MLxefeLDoU_HhSrS7ugc1idE7Qa7=h5a2F0x+4TizFg@mail.gmail.com>
 <1468851368.2994.54.camel@pengutronix.de>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 18 Jul 2016 21:41:53 +0200
Message-ID: <CAPybu_1XseCtoQdZ+k2mPYD4FrvsxxuDZPF00gZGJJowvy+o5Q@mail.gmail.com>
Subject: Re: [PATCH v4 09/12] [media] vivid: Local optimization
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarit.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Antti Palosaari <crope@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp:

On Mon, Jul 18, 2016 at 4:16 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:

> I had the best looking result with this variant, btw:
>
>         y >>= 4;
>         cb >>= 4;
>         cr >>= 4;
>         if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
>                 y = clamp(y, 16, 235);
>                 cb = clamp(cb, 16, 240);
>                 cr = clamp(cr, 16, 240);
>         } else {
>                 y = clamp(y, 1, 254);
>                 cb = clamp(cb, 1, 254);
>                 cr = clamp(cr, 1, 254);
>         }

I like this variant much better than mine. I have applied to my local
tree. So it will be what I post on v5

Thanks for you comments :)


btw: it is scary what the compiler optimizations are capable of doing these days


-- 
Ricardo Ribalda
