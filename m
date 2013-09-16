Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:43800 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3IPF7S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 01:59:18 -0400
MIME-Version: 1.0
In-Reply-To: <1379076935.4396.13.camel@pizza.hi.pengutronix.de>
References: <1378987669-10870-1-git-send-email-arun.kk@samsung.com>
	<1378987669-10870-13-git-send-email-arun.kk@samsung.com>
	<1379076935.4396.13.camel@pizza.hi.pengutronix.de>
Date: Mon, 16 Sep 2013 11:29:14 +0530
Message-ID: <CALt3h78TezzNoET+st6RBUH6Fefj_HX5A6NkeTit5SYb2EQ_Rw@mail.gmail.com>
Subject: Re: [PATCH v8 12/12] V4L: Add driver for s5k4e5 image sensor
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

>> +Example:
>> +
>> +     i2c-isp@13130000 {
>> +             s5k4e5@20 {
>> +                     compatible = "samsung,s5k4e5";
>> +                     reg = <0x20>;
>> +                     gpios = <&gpx1 2 1>;
>
> This probably should be 'reset-gpios', too.
>

Yes thats right. I missed updating the example.
Thanks for pointing out.

Regards
Arun
