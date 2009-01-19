Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:52144 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765AbZASOr6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:58 -0500
Message-ID: <497492AE.5030509@scram.de>
Date: Mon, 19 Jan 2009 15:48:14 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCHv4] Add Freescale MC44S803 tuner driver
References: <496F9A1C.7040602@scram.de> <49722758.8030801@iki.fi>
In-Reply-To: <49722758.8030801@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

>> +	buf[0] = (val & 0xFF0000) >> 16;
> 
> I am not sure where it comes I have seen comments sometimes that we 
> should use lower case hex numbers.

OK, will fix.

>> +		return -EREMOTEIO;
> [...]
>> +	u8 ret, id;
> 
> Error status (-EREMOTEIO) is stored to the u8, which leads ~254. This 
> seems not to be problem currently because mc44s803_readreg() is used 
> only in mc44s803_attach() that returns NULL in error case. Anyhow, I 
> think it would be better to use int for clarity.

This is definitely a BUG. I'll also fix this. Do you want me to post an
update to the tuner or an incremental patch against your repository?

Thanks,
Jochen
