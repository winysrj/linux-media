Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60385 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbbCWJyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 05:54:16 -0400
Message-id: <550FE2C3.7090702@samsung.com>
Date: Mon, 23 Mar 2015 10:54:11 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com, Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v1 02/11] DT: Add documentation for the mfd Maxim max77693
References: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
 <1426863811-12516-3-git-send-email-j.anaszewski@samsung.com>
 <20150321224903.GE16613@valkosipuli.retiisi.org.uk>
In-reply-to: <20150321224903.GE16613@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 03/21/2015 11:49 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Fri, Mar 20, 2015 at 04:03:22PM +0100, Jacek Anaszewski wrote:
>> +Optional properties of the LED child node:
>> +- label : see Documentation/devicetree/bindings/leds/common.txt
>
> I'm still not comfortable using the label field as-is as the entity name in
> the later patches, there's one important problem: it is not guaranteed to be
> unique in the system.

I don't use it as-is in my patches. For max77603-led the i2c adapter id
and client address is added to it, and for aat1290 there is '_n' suffix
added. Nonetheless I didn't notice that the patch [1] was already
merged. It checks if a LED class device with given name isn't already
registered and adds a '_n" suffix if there was any. If it was exported
I could use it in the leds-aat1290 driver and avoid depending on the
static variable.

Whereas for I2C devices the problem doesn't exist (it is guaranteed that
no more than one I2C client with an address can be present on the
same bus), for devices driven through GPIOs we haven't stable unique
identifier.

I thought that we agreed on #v4l about adding numerical postfixes
in case of such devices.

> Do you think this could be added to
> Documentation/devicetree/bindings/leds/common.txt, with perhaps enforcing it
> in the LED framework? Bryan, what do you think?

The patch [1] seems to address the issue.

> The alternative would be to simply ignore it in the entity name, but then
> the name of the device would be different in the LED framework and Media
> controller.
>

This is the case currently - the names are different. The post fixes
are added only to media entity name. Perhaps they should be unified.


[1] http://www.spinics.net/lists/linux-leds/msg03137.html

-- 
Best Regards,
Jacek Anaszewski
