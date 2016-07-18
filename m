Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40688 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbcGROQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 10:16:20 -0400
Message-ID: <1468851368.2994.54.camel@pengutronix.de>
Subject: Re: [PATCH v4 09/12] [media] vivid: Local optimization
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
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
Date: Mon, 18 Jul 2016 16:16:08 +0200
In-Reply-To: <CAPybu_3MLxefeLDoU_HhSrS7ugc1idE7Qa7=h5a2F0x+4TizFg@mail.gmail.com>
References: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
	 <1468845736-19651-10-git-send-email-ricardo.ribalda@gmail.com>
	 <1468847611.2994.22.camel@pengutronix.de>
	 <CAPybu_3MLxefeLDoU_HhSrS7ugc1idE7Qa7=h5a2F0x+4TizFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Am Montag, den 18.07.2016, 15:21 +0200 schrieb Ricardo Ribalda Delgado:
> Hi Philipp
> 
> On Mon, Jul 18, 2016 at 3:13 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > Since the constant expressions are evaluated at compile time, you are
> > not actually removing shifts. The code generated for precalculate_color
> > by gcc 5.4 even grows by one asr instruction with this patch.
> >
> 
> I dont think that I follow you completely here. The original code was

Sorry, I forgot to mention I compiled both versions for ARMv7-A, saw
that object size increased, had a look the diff between objdump -d
outputs and noticed an additional shift instruction. I have not checked
this for x86_64.

> if (a)
>    y= clamp(y, 16<<4, 235<<4)
> 
> y = clamp(y>>4, 1, 254)
>
> And now is
> 
> if (a)
>    y= clamp(y >>4, 16, 235)
> else
>     y = clamp(y, 1, 254)
     y = clamp(y >>4, 1, 254)

> On the previous case, when a was true there was 2 clamp operations.
> Now it is only one.

Yes. And now there's two shift operations (overall, still just one in
each conditional path).

It seems in my case the compiler was not clever enough to move all the
right shifts out of the conditional paths, so I ended up with one more
than before. You are right that in the limited range path the second
clamps are now avoided though. Basically, feel free to disregard my
comment.

I had the best looking result with this variant, btw:

	y >>= 4;
	cb >>= 4;
	cr >>= 4;
	if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
		y = clamp(y, 16, 235);
		cb = clamp(cb, 16, 240);
		cr = clamp(cr, 16, 240);
	} else {
		y = clamp(y, 1, 254);
		cb = clamp(cb, 1, 254);
		cr = clamp(cr, 1, 254);
	}

regards
Philipp

