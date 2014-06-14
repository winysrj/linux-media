Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53463 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbaFNAta (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 20:49:30 -0400
Message-ID: <539B9C17.3000809@iki.fi>
Date: Sat, 14 Jun 2014 03:49:27 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Daniel Mayer <danielmayer@arcor.de>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: WG: Patch pctv452e.c: Suppress annoying dmesg-SPAM
References: <029901cf7c4c$7a4d78d0$6ee86a70$@arcor.de>
In-Reply-To: <029901cf7c4c$7a4d78d0$6ee86a70$@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Daniel,

On 05/31/2014 12:16 AM, Daniel Mayer wrote:
> Hi,
> attached micro-patch removes the text output of an error-message of the
> PCTV452e-driver. The error messages "I2C error: [.]" do not help any user of
> the kernel, so whatever causes the error, it does not hamper the function of
> my TT-3600 USB receiver.
> So: Just remove the entries in the dmesg, for it is quite spam-like.
> Perhaps someone with deeper knowledge could have a look up the background of
> this message and fix it?
> Thanks,
> Daniel
>
> (resent as plain-text; sorry)
>

That is not proper fix, it just hides it by removing proper error logging.

I debugged real reason earlier:
http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/50491


I have got even hardware, but I am totally overloaded so I have to 
prioritize things. I am happy to see if someone fixes it properly.

regards
Antti

-- 
http://palosaari.fi/
