Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38850 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbcGRNVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 09:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <1468847611.2994.22.camel@pengutronix.de>
References: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
 <1468845736-19651-10-git-send-email-ricardo.ribalda@gmail.com> <1468847611.2994.22.camel@pengutronix.de>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 18 Jul 2016 15:21:10 +0200
Message-ID: <CAPybu_3MLxefeLDoU_HhSrS7ugc1idE7Qa7=h5a2F0x+4TizFg@mail.gmail.com>
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

Hi Philipp

On Mon, Jul 18, 2016 at 3:13 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Since the constant expressions are evaluated at compile time, you are
> not actually removing shifts. The code generated for precalculate_color
> by gcc 5.4 even grows by one asr instruction with this patch.
>

I dont think that I follow you completely here. The original code was

if (a)
   y= clamp(y, 16<<4, 235<<4)

y = clamp(y>>4, 1, 254)


And now is

if (a)
   y= clamp(y >>4, 16, 235)
else
    y = clamp(y, 1, 254)


On the previous case, when a was true there was 2 clamp operations.
Now it is only one.


Best regards!

-- 
Ricardo Ribalda
