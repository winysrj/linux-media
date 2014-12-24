Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:50443 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaLXApg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 19:45:36 -0500
Message-ID: <549A0CA9.6050401@southpole.se>
Date: Wed, 24 Dec 2014 01:45:29 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 48/66] rtl28xxu: use master I2C adapter for slave demods
References: <1419367799-14263-1-git-send-email-crope@iki.fi> <1419367799-14263-48-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-48-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/23/2014 09:49 PM, Antti Palosaari wrote:
> Both mn88472 and mn88473 slave demods are connected to master I2C
> bus, not the bus behind master demod I2C gate like tuners. Use
> correct bus.
>

Hello Antti, in my work tree I am still getting i2c errors even with the 
ir poll workaround (it takes really long time to get them). If I reload 
the rtl28xxu driver 2 times it starts working again. Could this change 
be related to such errors ?

MvH
Benjamin Larsson

