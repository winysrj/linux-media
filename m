Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39741 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab2LNQ4L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 11:56:11 -0500
Message-ID: <50CB5A0A.3030305@iki.fi>
Date: Fri, 14 Dec 2012 18:55:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: mchehab@redhat.com, linux-media@vger.kernel.org,
	dheitmueller@kernellabs.com
Subject: Re: [PATCH 2/5] em28xx: respect the message size constraints for
 i2c transfers
References: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com> <1355502533-25636-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1355502533-25636-3-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/14/2012 06:28 PM, Frank Schäfer wrote:
> The em2800 can transfer up to 4 bytes per i2c message.
> All other em25xx/em27xx/28xx chips can transfer at least 64 bytes per message.
>
> I2C adapters should never split messages transferred via the I2C subsystem
> into multiple message transfers, because the result will almost always NOT be
> the same as when the whole data is transferred to the I2C client in a single
> message.
> If the message size exceeds the capabilities of the I2C adapter, -EOPNOTSUPP
> should be returned.
>
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>


> +	if (len < 1 || len > 4)
> +		return -EOPNOTSUPP;

That patch seem to be good for my eyes, but that check for len < 1 is 
something I would like to double checked. Generally len = 0 is OK and is 
used some cases, probing and sometimes when all registers are read for 
example.

Did you test it returns some error for zero len messages?

regards
Antti

-- 
http://palosaari.fi/
