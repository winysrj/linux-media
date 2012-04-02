Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35152 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab2DBVwP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 17:52:15 -0400
Message-ID: <4F7A1F88.1060109@iki.fi>
Date: Tue, 03 Apr 2012 00:52:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans-Frieder Vogt <hfvogt@gmx.net>,
	Gianluca Gennari <gennarone@gmail.com>
Subject: Re: [PATCH] Add fc0011 tuner driver
References: <20120402181432.74e8bd50@milhouse> <4F79DA52.2050907@iki.fi> <20120402192011.4edc82ff@milhouse> <4F79E49D.1020802@iki.fi> <20120402195125.771b2c72@milhouse>
In-Reply-To: <20120402195125.771b2c72@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02.04.2012 20:51, Michael Büsch wrote:
>> Likely tuner driver, or demod driver. But as demod tuner initialization
>> tables are likely correct I suspect it is tuner issue at first hand. And
>> secondly my other hardware with TUA9001 performs very well, better than
>> old AF9015 sticks.
>
> Well the fc0011 tuner driver still works worse on this af9035 driver
> than on Hans' driver. I have absolutely no idea why this is the case.
> I'm almost certain that it is not a timing issue of some sort. I tried
> a zillion of delays and such.

And after taking sniffs and comparing those I found the reason. It is 
I2C adapter code. It writes one byte too much => as a FC0011 is 
auto-increment (as almost every I2C client) registers it means it writes 
next register too. Fixing that gives normal tuner sensitivity. I will 
try to make patch for that soon.

regards
Antti
-- 
http://palosaari.fi/
