Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44369 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1422912AbeBORQ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 12:16:59 -0500
Subject: Re: [PATCH v12 6/8] media: i2c: Add TDA1997x HDMI receiver driver
To: Tim Harvey <tharvey@gateworks.com>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1518712767-21928-1-git-send-email-tharvey@gateworks.com>
 <1518712767-21928-7-git-send-email-tharvey@gateworks.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <10f08dfb-cc23-a9e3-7439-95955661cb77@xs4all.nl>
Date: Thu, 15 Feb 2018 18:16:57 +0100
MIME-Version: 1.0
In-Reply-To: <1518712767-21928-7-git-send-email-tharvey@gateworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/02/18 17:39, Tim Harvey wrote:
> Add support for the TDA1997x HDMI receivers.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---
> v12:
>  - fix coccinelle warnings

Did you post the right version? I still see the owner being set and the
other kbuild warning ('note: in expansion of macro 'v4l_dbg'') is also
still there.

Note that the last one also shows these errors:

drivers/media/i2c/tda1997x.c:387:5-8: WARNING: Unsigned expression compared with zero: val < 0
drivers/media/i2c/tda1997x.c:391:5-8: WARNING: Unsigned expression compared with zero: val < 0
drivers/media/i2c/tda1997x.c:404:5-8: WARNING: Unsigned expression compared with zero: val < 0
drivers/media/i2c/tda1997x.c:408:5-8: WARNING: Unsigned expression compared with zero: val < 0
drivers/media/i2c/tda1997x.c:412:5-8: WARNING: Unsigned expression compared with zero: val < 0
drivers/media/i2c/tda1997x.c:427:6-9: WARNING: Unsigned expression compared with zero: val < 0

This is indeed wrong.

Regards,

	Hans
