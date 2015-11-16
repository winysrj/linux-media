Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12985 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbbKPNev (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 08:34:51 -0500
Message-id: <5649DB76.5020500@samsung.com>
Date: Mon, 16 Nov 2015 14:34:46 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
	pavel@ucw.cz, andrew@lunn.ch, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 10/10] media: flash: use led_set_brightness_sync for
 torch brightness
References: <1444209048-29415-1-git-send-email-j.anaszewski@samsung.com>
 <1444209048-29415-11-git-send-email-j.anaszewski@samsung.com>
 <5649A37A.2050902@samsung.com> <5649A64E.8050907@linux.intel.com>
In-reply-to: <5649A64E.8050907@linux.intel.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/16/2015 10:47 AM, Sakari Ailus wrote:
> Jacek Anaszewski wrote:
>> This patch depends on the preceding LED core improvements patches
>> from this patch set, and it would be best if it was merged through
>> the LED tree. Can I get your ack for this? I've already obtained acks
>> for the whole set from Sakari.
>
> I agree with this going through the LED tree.
>

Applied this patch set, with fixed version of the patch 4/10 [1],
thanks.

[1] http://www.spinics.net/lists/linux-leds/msg05045.html
-- 
Best Regards,
Jacek Anaszewski
