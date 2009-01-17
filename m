Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:30562 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763770AbZAQSpq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 13:45:46 -0500
Message-ID: <49722758.8030801@iki.fi>
Date: Sat, 17 Jan 2009 20:45:44 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCHv4] Add Freescale MC44S803 tuner driver
References: <496F9A1C.7040602@scram.de>
In-Reply-To: <496F9A1C.7040602@scram.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jochen,
I just reviewed this patch and here is my comments;

Jochen Friedrich wrote:
> +	buf[0] = (val & 0xFF0000) >> 16;

I am not sure where it comes I have seen comments sometimes that we 
should use lower case hex numbers.

> +		return -EREMOTEIO;
[...]
> +	u8 ret, id;

Error status (-EREMOTEIO) is stored to the u8, which leads ~254. This 
seems not to be problem currently because mc44s803_readreg() is used 
only in mc44s803_attach() that returns NULL in error case. Anyhow, I 
think it would be better to use int for clarity.

regards,
Antti
-- 
http://palosaari.fi/
