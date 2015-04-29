Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:32962 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031083AbbD2AYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 20:24:30 -0400
MIME-Version: 1.0
In-Reply-To: <20150428100951.GO11956@x1>
References: <1430205530-20873-1-git-send-email-j.anaszewski@samsung.com>
 <1430205530-20873-3-git-send-email-j.anaszewski@samsung.com> <20150428100951.GO11956@x1>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 28 Apr 2015 17:24:09 -0700
Message-ID: <CAK5ve-Kj92nU0Ykq54OVZxi_oekAiZ9O6R2sf11TrtZTKDr=dg@mail.gmail.com>
Subject: Re: [PATCH v6 02/10] DT: Add documentation for the mfd Maxim max77693
To: Lee Jones <lee.jones@linaro.org>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pavel Machek <pavel@ucw.cz>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 28, 2015 at 3:09 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, 28 Apr 2015, Jacek Anaszewski wrote:
>
>> This patch adds device tree binding documentation for
>> the flash cell of the Maxim max77693 multifunctional device.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> Cc: devicetree@vger.kernel.org
>> ---
>>  Documentation/devicetree/bindings/mfd/max77693.txt |   67 ++++++++++++++++++++
>>  1 file changed, 67 insertions(+)
>
> Requires a LED Ack.
>

Please go with my Ack:

Acked-by: Bryan Wu <cooloney@gmail.com>

Thanks,
-Bryan
