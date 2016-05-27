Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58094 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbcE0API (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2016 20:15:08 -0400
Subject: Re: How should I use kernel-defined i2c structs in this driver
To: Andrey Utkin <andrey_utkin@fastmail.com>,
	kernel-mentors@selenic.com, devel@driverdev.osuosl.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
References: <20160526135953.GA20697@zver>
Cc: andrey.utkin@corp.bluecherry.net
From: Antti Palosaari <crope@iki.fi>
Message-ID: <85a38a7c-d970-426a-5710-bbdf955cab58@iki.fi>
Date: Fri, 27 May 2016 03:14:59 +0300
MIME-Version: 1.0
In-Reply-To: <20160526135953.GA20697@zver>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/26/2016 04:59 PM, Andrey Utkin wrote:
> Could anybody please give a hint - which kernel-defined i2c objects, and how
> many of them, I need to define and use to substitute these driver-defined
> functions i2c_read(), i2c_write() ?
> https://github.com/bluecherrydvr/linux/blob/release/tw5864/1.16/drivers/media/pci/tw5864/tw5864-config.c
> In a word, there's 4 chips with different addresses, to which this code
> communicates via main chip's dedicated registers.
> Do i need a single i2c_adapter or several?
> Do i need i2c_client entities?
> where should I put what is named "devid" here?
>
> Thanks in advance.

It depends how those are connected at hardware level. Quickly looking I 
think "devid" is here to select proper I2C adapter. So I think there is 
4 I2C adapters and each of those adapter has 1 slave device. Is that 
correct? If yes, then register 4 I2C adapters and register single client 
for each of those adapters.

regards
Antti



-- 
http://palosaari.fi/
