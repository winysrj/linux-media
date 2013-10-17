Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30727 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab3JQRKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 13:10:13 -0400
Message-id: <526019F0.3070406@samsung.com>
Date: Thu, 17 Oct 2013 19:10:08 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: hverkuil@xs4all.nl, swarren@wwwdotorg.org, mark.rutland@arm.com,
	Pawel.Moll@arm.com, galak@codeaurora.org, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH v9 13/13] V4L: Add driver for s5k4e5 image sensor
References: <1380279558-21651-1-git-send-email-arun.kk@samsung.com>
 <1380279558-21651-14-git-send-email-arun.kk@samsung.com>
In-reply-to: <1380279558-21651-14-git-send-email-arun.kk@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/09/13 12:59, Arun Kumar K wrote:
> This patch adds subdev driver for Samsung S5K4E5 raw image sensor.
> Like s5k6a3, it is also another fimc-is firmware controlled
> sensor. This minimal sensor driver doesn't do any I2C communications
> as its done by ISP firmware. It can be updated if needed to a
> regular sensor driver by adding the I2C communication.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  .../devicetree/bindings/media/i2c/s5k4e5.txt       |   45 +++
>  drivers/media/i2c/Kconfig                          |    8 +
>  drivers/media/i2c/Makefile                         |    1 +
>  drivers/media/i2c/s5k4e5.c                         |  347 ++++++++++++++++++++
>  4 files changed, 401 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
>  create mode 100644 drivers/media/i2c/s5k4e5.c
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt b/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
> new file mode 100644
> index 0000000..0fca087
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt

Could you make a separate patch adding DT binding only ?
And can you please rename this file to:
Documentation/devicetree/bindings/media/samsung-s5k4e5.txt, like
it's done in case of other sensors ?

Should I apply patches 02...11/13 already or would you like send 
the whole series updated ? AFAICS there are minor things pointed 
out by Hans not addressed yet ?

Regards,
Sylwester
