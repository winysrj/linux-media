Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37180 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659Ab2LNREZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 12:04:25 -0500
Message-ID: <50CB5BF8.5070201@iki.fi>
Date: Fri, 14 Dec 2012 19:03:52 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: mchehab@redhat.com, linux-media@vger.kernel.org,
	dheitmueller@kernellabs.com
Subject: Re: [PATCH 5/5] em28xx: fix+improve+unify i2c error handling, debug
 messages and code comments
References: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com> <1355502533-25636-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1355502533-25636-6-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/14/2012 06:28 PM, Frank Schäfer wrote:
> - check i2c slave address range (only 7 bit addresses supported)
> - do not pass USB specific error codes to userspace/i2c-subsystem
> - unify the returned error codes and make them compliant with
>    the i2c subsystem spec
> - check number of actually transferred bytes (via USB) everywehere
> - fix/improve debug messages
> - improve code comments
>
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>


> @@ -244,16 +294,20 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>   		dprintk2(2, "%s %s addr=%x len=%d:",
>   			 (msgs[i].flags & I2C_M_RD) ? "read" : "write",
>   			 i == num - 1 ? "stop" : "nonstop", addr, msgs[i].len);
> +		if (addr > 0xff) {
> +			dprintk2(2, " ERROR: 10 bit addresses not supported\n");
> +			return -EOPNOTSUPP;
> +		}

There is own flag for 10bit I2C address. Use it (and likely not compare 
at all addr validly like that). This kind of address validation check is 
quite unnecessary - and after all if it is wanted then correct place is 
somewhere in I2C routines.

regards
Antti

-- 
http://palosaari.fi/
