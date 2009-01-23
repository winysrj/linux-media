Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32727 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbZAWRS6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 12:18:58 -0500
Message-ID: <4979E939.2080102@iki.fi>
Date: Fri, 23 Jan 2009 17:58:49 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Lindsay Mathieson <lindsay.mathieson@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: TinyTwin (af9015) Results and questions
References: <497912d9.3df.52be.1092695642@blackpaw.dyndns.org>
In-Reply-To: <497912d9.3df.52be.1092695642@blackpaw.dyndns.org>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lindsay Mathieson wrote:
> to enable the second tuner. I thought that would be on by
> default now the 2nd tuner bugs have been worked out. 

Done.

> - Is there a official place to download the firmware from?
> Currently I'm getting it from:
>  
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw

That's "official". I think it is not wanted to linuxtv.org because there 
is same as almost every firmware - it does not have any license. It is 
just extracted out from Windows driver (actually from USB-sniff). I 
think some distributions will package & deliver this kind of firmwares, 
though.

> - Is it possible to estimate when this will make its way
> into the linux kernel? How will I know?

Driver is in 2.6.28, with dual mode disabled & broken. I am not sure 
whether those fixes are coming to 2.6.29 or 2.6.30, I doubt later Kernel.

> I ask because I'd like to write up a howto for myth and/or
> ubuntu users, and want to cover all bases.

regards
Antti
-- 
http://palosaari.fi/
