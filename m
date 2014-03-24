Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36238 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790AbaCXTbL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:31:11 -0400
Message-ID: <533087FB.7010008@iki.fi>
Date: Mon, 24 Mar 2014 21:31:07 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	linux-media@vger.kernel.org
CC: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: How to build I2C_MUX in media_build as rtl28xxu depends on it
 ?
References: <1394756071-22410-1-git-send-email-crope@iki.fi> <1394756071-22410-12-git-send-email-crope@iki.fi> <533074B2.4000007@hoogenraad.net>
In-Reply-To: <533074B2.4000007@hoogenraad.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24.03.2014 20:08, Jan Hoogenraad wrote:
> After recent changes, I cannot build  rtl28xxu on systems with linux
> 2.6.32 or 3.2.0.
> rtl28xxu is one of the few drivers depending on  I2C_MUX.
> Kconfig.kern lists I2C_MUX (correctly) as not in the kernel of the system.
> I don't know if it is possible to load a new module for that.
>
> Who can help me with this ?

I think the correct way is to add that I2C_MUX to media-build backport.


regards
Antti

-- 
http://palosaari.fi/
