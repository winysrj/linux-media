Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35825 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031206AbbD2A2d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 20:28:33 -0400
MIME-Version: 1.0
In-Reply-To: <20150428113604.GD3188@valkosipuli.retiisi.org.uk>
References: <1430205530-20873-1-git-send-email-j.anaszewski@samsung.com>
 <1430205530-20873-4-git-send-email-j.anaszewski@samsung.com> <20150428113604.GD3188@valkosipuli.retiisi.org.uk>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 28 Apr 2015 17:28:12 -0700
Message-ID: <CAK5ve-LzasuSmVD9=CYR9bb__QWX+j7uvb1dhp-YhBhcGJ9G4Q@mail.gmail.com>
Subject: Re: [PATCH v6 03/10] leds: Add support for max77693 mfd flash cell
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pavel Machek <pavel@ucw.cz>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 28, 2015 at 4:36 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Jacek,
>
> On Tue, Apr 28, 2015 at 09:18:43AM +0200, Jacek Anaszewski wrote:
>> This patch adds led-flash support to Maxim max77693 chipset.
>> A device can be exposed to user space through LED subsystem
>> sysfs interface. Device supports up to two leds which can
>> work in flash and torch mode. The leds can be triggered
>> externally or by software.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Applied, thanks,
-Bryan
