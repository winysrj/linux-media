Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42137 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab1KLQcN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 11:32:13 -0500
Message-ID: <4EBE9F8B.6000808@iki.fi>
Date: Sat, 12 Nov 2011 18:32:11 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/7] af9013 frontend tuner bus lock and gate changes v2
References: <4ebe9705.0d3ae30a.18dc.7d6f@mx.google.com>
In-Reply-To: <4ebe9705.0d3ae30a.18dc.7d6f@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2011 05:55 PM, Malcolm Priestley wrote:
> Changes from version 1
> Remove the bus lock from read status. Causing a lagging
> effect on some kernels<  [2.6.38]
>
> This does mean that noisy I2C traffic could be heard on
> the first frontend when its tuner gate is open.

I think you want add locking for tuner set. But this seems to be now 
removing it.

* tuner gate is not normally open, it is only open very small period 
when tuner is programmed, init or sleep.
* I think gate is not reason for I2C errors seen in log

Finally I think, you want lock tuner set. Than is easiest to do locking 
whole .set_frontend(). I haven't tested it, but testing it have been on 
my TODO some time.

Antti


-- 
http://palosaari.fi/
