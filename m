Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2554 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaGNTeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 15:34:17 -0400
Message-ID: <53C430AC.9030204@xs4all.nl>
Date: Mon, 14 Jul 2014 21:34:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] airspy: AirSpy SDR driver
References: <1405366031-31937-1-git-send-email-crope@iki.fi>
In-Reply-To: <1405366031-31937-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/14/2014 09:27 PM, Antti Palosaari wrote:
> AirSpy SDR driver.
> 
> Thanks to Youssef Touil and Benjamin Vernoux for support, help and
> hardware!
> http://airspy.com/
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/staging/media/Kconfig         |    1 +
>  drivers/staging/media/Makefile        |    1 +
>  drivers/staging/media/airspy/Kconfig  |    5 +
>  drivers/staging/media/airspy/Makefile |    1 +
>  drivers/staging/media/airspy/airspy.c | 1120 +++++++++++++++++++++++++++++++++
>  5 files changed, 1128 insertions(+)
>  create mode 100644 drivers/staging/media/airspy/Kconfig
>  create mode 100644 drivers/staging/media/airspy/Makefile
>  create mode 100644 drivers/staging/media/airspy/airspy.c
> 

It's a new driver, so the usual question: can you post the output from the
latest v4l2-compliance? 'v4l2-compliance -S /dev/swradioX -s'

It looks good, but I always like to see the output of that as a record and
as a verification that someone actually ran it :-)

Thanks,

	Hans
