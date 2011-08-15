Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41887 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1HOACd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 20:02:33 -0400
Message-ID: <4E486216.90501@iki.fi>
Date: Mon, 15 Aug 2011 03:02:30 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: PCTV 290e - assorted problems
References: <1313366188.5010.YahooMailClassic@web121715.mail.ne1.yahoo.com>
In-Reply-To: <1313366188.5010.YahooMailClassic@web121715.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/15/2011 02:56 AM, Chris Rankin wrote:

>>>> tuning status == 0x0f
>>>> tuning status == 0x0f
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
> 
> Although it was working (briefly) on Saturday morning.
> 
>> Have you tried it on Windows?
> 
> No, because I don't own a Windows machine.

Most likely demod does not got full lock since weak/noisy signal. It is
possible to increase lock waiting time from changing driver but it is
not wise before signal is known to be good enough.


Antti
-- 
http://palosaari.fi/
