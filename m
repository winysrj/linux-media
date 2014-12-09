Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8857 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157AbaLINOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Dec 2014 08:14:12 -0500
Message-id: <5486F5A0.9060700@samsung.com>
Date: Tue, 09 Dec 2014 14:14:08 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Subject: Re: [PATCH/RFC v9 02/19] Documentation: leds: Add description of LED
 Flash class extension
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-3-git-send-email-j.anaszewski@samsung.com>
 <20141203170818.GN14746@valkosipuli.retiisi.org.uk>
 <54802C9F.8030101@samsung.com>
 <20141209123819.GJ15559@valkosipuli.retiisi.org.uk>
In-reply-to: <20141209123819.GJ15559@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 12/09/2014 01:38 PM, Sakari Ailus wrote:

[...]

>>> How does the user btw. figure out which flash LEDs may be strobed
>>> synchronously using the LED flash interface?
>>
>> The flash_sync_strobe argument is absent if synchronized strobe
>> is not available for a LED. The driver defines this by setting
>> newly added LED_DEV_CAP_COMPOUND flag.
>
> I meant that how does the user figure out which LEDs may be strobed
> synchronously, together. Say, if you have two of these chips and four LEDs,
> then how does it work? :-)
>

User can figure it out by checking the existence of the
flash_sync_strobe attribute. Sub-leds can by synchronized only
when are driven by common chip. It is assumed that sub-leds of
one chip will have common segment in their name, defined in
DT 'label' property. Maybe we should enforce it by adding another
property to the leds/common.txt DT binding, e.g. 'device-prefix'?

Best Regards,
Jacek Anaszewski

