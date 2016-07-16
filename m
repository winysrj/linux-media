Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36099 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbcGPKwb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 06:52:31 -0400
MIME-Version: 1.0
In-Reply-To: <1468665716-10178-10-git-send-email-ricardo.ribalda@gmail.com>
References: <1468665716-10178-1-git-send-email-ricardo.ribalda@gmail.com> <1468665716-10178-10-git-send-email-ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Sat, 16 Jul 2016 12:52:09 +0200
Message-ID: <CAPybu_3L2_yGLjzo7wnXxiXRrJQ4YmRZUvAkmoVMKxJKgVe3yQ@mail.gmail.com>
Subject: Re: [PATCH v3 9/9] [media] vivid: Local optimization
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarit.de>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Sat, Jul 16, 2016 at 12:41 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> -                       cr = clamp(cr, 16 << 4, 240 << 4);
> +                       y = clamp(y >> 4, 16, 235);
> +                       cb = clamp(cb >> 4, 16, 240);
> +                       cr = clamp(cr > 4, 16, 240);
This line is obviously wrong, sorry about that.

I wait for some more comments and add it to v4.

Regards!
