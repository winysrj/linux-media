Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52003 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab1K2AKB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 19:10:01 -0500
Message-ID: <4ED422D5.60701@iki.fi>
Date: Tue, 29 Nov 2011 02:09:57 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH FOR 3.2 FIX] af9015: limit I2C access to keep FW happy
References: <4EC014E5.5090303@iki.fi> <4EC01857.5050000@iki.fi> <4ec1955e.e813b40a.37be.3fce@mx.google.com>
In-Reply-To: <4ec1955e.e813b40a.37be.3fce@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/15/2011 12:25 AM, Malcolm Priestley wrote:
> I have tried this patch, while it initially got MythTV working, there is
> too many call backs and some failed to acquire the lock. The device
> became unstable on both single and dual devices.
>
> The callbacks
>
> af9015_af9013_read_status,
> af9015_af9013_init
> af9015_af9013_sleep
>
> had to be removed.
>
> I take your point, a call back can be an alternative.
>
> The patch didn't stop the firmware fails either.
>
> The af9015 usb bridge on the whole is so unstable in its early stages,
> especially on a cold boot and when the USB controller has another device
> on it, such as card reader or wifi device.
>
> I am, at the moment looking to see if the fails are due to interface 1
> being claimed by HID.

I just got af9013 rewrite ready. Feel free to test.
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/misc

It reduces typical statistics polling load maybe 1/4 from the original.

I see still small glitch when switching to channel. That seems to come 
from tuner driver I2C load. There is 3 tuners used for dual devices; 
MXL5005S, MXL5007T and TDA18271. I have only MXL5005S and MXL5007T dual 
devices here. MXL5005S is worse than MXL5007T but both makes still 
rather much I/O.

regards
Antti
-- 
http://palosaari.fi/
