Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43089 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaLUJVL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Dec 2014 04:21:11 -0500
Message-ID: <54969102.3030204@iki.fi>
Date: Sun, 21 Dec 2014 11:21:06 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC][PATCH] mn88472: add support for the mn88473 demod
References: <1419119853-29452-1-git-send-email-benjamin@southpole.se> <54960F0C.5020506@southpole.se>
In-Reply-To: <54960F0C.5020506@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 12/21/2014 02:06 AM, Benjamin Larsson wrote:
> This is what mn88473 support in the mn88472 demod driver could look
> like. The code is untested but will look similar in the final version.
> It is also possible to let the driver figure out the demod version from
> the 0xff register. Then the users would not need to set that parameter.
> Same goes to the xtal parameter.
>
> So does the mn88473 support look ok and should the driver figure out
> what demod is connected ?


You patch looks rather good and these drivers should be merged to one if 
possible, lets say registers are 80% same or something like that. Looks 
like those are.

About detecting the chip type. Prefer always detecting automatically be 
reading the chip id.

Second best way is to use device ID for that:

static const struct i2c_device_id mn88472_id_table[] = {
	{"mn88472", 0},
	{"mn88473", 1},
	{}


Put the xtal/clock freq to config struct or use clock framework for it 
(maybe too heavy solution).

regards
Antti

-- 
http://palosaari.fi/
