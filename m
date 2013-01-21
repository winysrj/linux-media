Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53509 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab3AUJGl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 04:06:41 -0500
Message-ID: <50FD04F9.5000401@iki.fi>
Date: Mon, 21 Jan 2013 11:06:01 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] tda8290: Allow disabling I2C gate
References: <1358716939-2133-1-git-send-email-linux@rainbow-software.org> <1358716939-2133-2-git-send-email-linux@rainbow-software.org> <50FCF71E.4060909@iki.fi> <201301210918.07199.linux@rainbow-software.org>
In-Reply-To: <201301210918.07199.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/21/2013 10:18 AM, Ondrej Zary wrote:
> On Monday 21 January 2013, Antti Palosaari wrote:
>> On 01/20/2013 11:22 PM, Ondrej Zary wrote:
>>> Allow disabling I2C gate handling by external configuration.
>>> This is required by cards that have all devices on a single I2C bus,
>>> like AverMedia A706.
>>
>> My personal opinion is that I2C gate control should be disabled setting
>> callback to NULL (same for the other unwanted callbacks too). There is
>> checks for callback existence in DVB-core, it does not call callback if
>> it is NULL.
>
> This is TDA8290 internal I2C gate which is used by tda8290 internally and also
> by tda827x or tda18271.

That sounds like there is some logical problems in the driver then, not 
split correctly?

What I think, scenario is tda8290 is analog decoder, tda18271 is silicon 
tuner, which is connected (usually) to the tda8290 I2C bus. tda18271 
calls tda8290 I2C-gate control when needed. Analog or digital demod 
should not call its own I2C gate directly - and if it was done in some 
weird reason then it should call own callback conditionally, checking 
whether or not it is NULL.

regards
Antti

-- 
http://palosaari.fi/
