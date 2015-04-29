Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35709 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031191AbbD2Ace (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 20:32:34 -0400
MIME-Version: 1.0
In-Reply-To: <20150428113658.GE3188@valkosipuli.retiisi.org.uk>
References: <1430205530-20873-1-git-send-email-j.anaszewski@samsung.com>
 <1430205530-20873-6-git-send-email-j.anaszewski@samsung.com> <20150428113658.GE3188@valkosipuli.retiisi.org.uk>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 28 Apr 2015 17:32:13 -0700
Message-ID: <CAK5ve-J-HdS3omcSHT657GhfCrno5U=y=9jcXs=U=1e0mkLdZA@mail.gmail.com>
Subject: Re: [PATCH v6 05/10] leds: Add driver for AAT1290 flash LED controller
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pavel Machek <pavel@ucw.cz>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 28, 2015 at 4:36 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Tue, Apr 28, 2015 at 09:18:45AM +0200, Jacek Anaszewski wrote:
>> This patch adds a driver for the 1.5A Step-Up Current Regulator
>> for Flash LEDs. The device is programmed through a Skyworks proprietary
>> AS2Cwire serial digital interface.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
Applied, thanks,
-Bryan

> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
