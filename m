Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:46216 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3IKKQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 06:16:20 -0400
Message-id: <523042F0.8030603@samsung.com>
Date: Wed, 11 Sep 2013 12:16:16 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arunkk.samsung@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	kilyeon.im@samsung.com
Subject: Re: [PATCH v7 13/13] V4L: Add driver for s5k4e5 image sensor
References: <1377066881-5423-1-git-send-email-arun.kk@samsung.com>
 <1377066881-5423-14-git-send-email-arun.kk@samsung.com>
 <5228E34B.307@gmail.com>
 <CALt3h78uVgjBKuc-++HVajwTKekFTPinAZ14BMKJmEGrg6OUyQ@mail.gmail.com>
In-reply-to: <CALt3h78uVgjBKuc-++HVajwTKekFTPinAZ14BMKJmEGrg6OUyQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 09/11/2013 07:10 AM, Arun Kumar K wrote:
> If I name it to reset-gpios, the function of_get_gpio_flags() in the driver
> fails. This function searches for the entry with name "gpios". Is it still
> recommended to use a custom name and parse it explicitly?

I guess so, you could just use of_get_named_gpio_flags().

Regards,
Sylwester
