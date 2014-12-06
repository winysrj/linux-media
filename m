Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:46534 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaLFO1p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Dec 2014 09:27:45 -0500
Message-ID: <54831255.6080800@southpole.se>
Date: Sat, 06 Dec 2014 15:27:33 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] rtl28xxu: lower the rc poll time to mitigate i2c
 transfer errors
References: <1417825533-13081-1-git-send-email-benjamin@southpole.se> <5482FABE.3050004@iki.fi>
In-Reply-To: <5482FABE.3050004@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/2014 01:46 PM, Antti Palosaari wrote:
> Moikka!
> I am very surprised about that patch, especially because it 
> *increases* polling interval from 400ms to 200ms. For me it has been 
> always worked rather well, but now I suspect it could be due to I 
> disable always remote controller... I have to test that.
>
> regards
> Antti

I noticed that I got more retry errors when I removed the poll. So when 
I tried lowering the interval time the errors totally disappeared for 
me. Exactly how it works is unclear to me but I guess that the rc poll 
triggers something in the chip to mitigate some overflow in the i2c 
transmit buffer. This workaround also suggest that the i2c bus actually 
is ok and not the cause for the errors. Anyway please test and if this 
is an acceptable solution then there might also be some check that this 
poll is active and set to 200 at all times for this card. At least when 
the card is set in dvb mode, for sdr mode this might not be an issue.

MvH
Benjamin Larsson
