Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:34304 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab3I2RqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Sep 2013 13:46:14 -0400
Message-ID: <52486760.1000105@gmail.com>
Date: Sun, 29 Sep 2013 19:46:08 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Wolfram Sang <wsa@the-dreams.de>, David Airlie <airlied@linux.ie>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-i2c@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2/8] [media] exynos4-is: Don't use i2c_client->driver
References: <1380444666-12019-1-git-send-email-lars@metafoo.de> <1380444666-12019-3-git-send-email-lars@metafoo.de>
In-Reply-To: <1380444666-12019-3-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/29/2013 10:51 AM, Lars-Peter Clausen wrote:
> The 'driver' field of the i2c_client struct is redundant and is going to be
> removed. The results of the expressions 'client->driver.driver->field' and
> 'client->dev.driver->field' are identical, so replace all occurrences of the
> former with the later.
>
> Signed-off-by: Lars-Peter Clausen<lars@metafoo.de>
> Cc: Kyungmin Park<kyungmin.park@samsung.com>
> Cc: Sylwester Nawrocki<s.nawrocki@samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
