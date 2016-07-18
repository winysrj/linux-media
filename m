Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37020 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbcGRJDx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 05:03:53 -0400
MIME-Version: 1.0
In-Reply-To: <6224fd35-50f3-e1cd-a9b5-f377087fade6@xs4all.nl>
References: <1468665716-10178-1-git-send-email-ricardo.ribalda@gmail.com>
 <1468665716-10178-9-git-send-email-ricardo.ribalda@gmail.com> <6224fd35-50f3-e1cd-a9b5-f377087fade6@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 18 Jul 2016 11:03:32 +0200
Message-ID: <CAPybu_0bZS-yo_PcJnC4tG34jXWSY5hnCjHmrH6d0NXJ6h3=_Q@mail.gmail.com>
Subject: Re: [PATCH v3 8/9] [media] vivid: Fix YUV555 and YUV565 handling
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarit.de>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans


On Mon, Jul 18, 2016 at 10:51 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> +     int y, cb, cr;
>> +     bool ycbbr_valid = false;
>
> I guess you mean ycbcr_valid?

Yes, I think the medical term is Saturday dyslexia :)

It is fixed on the next version.

Thanks!
