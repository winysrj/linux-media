Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47970 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2GSTkw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 15:40:52 -0400
Received: by bkwj10 with SMTP id j10so2798701bkw.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 12:40:51 -0700 (PDT)
Message-ID: <500862C0.2000507@gmail.com>
Date: Thu, 19 Jul 2012 21:40:48 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org,
	david.a.cohen@linux.intel.com
Subject: Re: [PATCH v2 1/2] v4l: Add factory register values form S5K4ECGX
 sensor
References: <1342700047-31806-1-git-send-email-sangwook.lee@linaro.org> <1342700047-31806-2-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1342700047-31806-2-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sangwook,

On 07/19/2012 02:14 PM, Sangwook Lee wrote:
> Add factory default settings for S5K4ECGX sensor registers.
> I copied them from the reference code of Samsung S.LSI.

I'm pretty sure we can do better than that. I've started S5K6AAFX sensor 
driver development with similar set of write-only register address/value
arrays, that stored mainly register default values after the device reset,
or were configuring presets that were never used.

If you lok at the s5k6aa driver, you'll find only one relatively small
array of register values for the analog processing block settings.
It's true that I had to reverse engineer a couple of things, but I also
had a relatively good datasheet for the sensor.
 
> According to comments from the reference code, they do not
> recommend any changes of these settings.

Yes, but it doesn't mean cannot convert, at least part of, those ugly
tables into function calls.

Have you tried to contact Samsung S.LSI for a datasheet that would 
contain better registers' description ?

--

Thanks,
Sylwester
