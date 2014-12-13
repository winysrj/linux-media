Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:36761 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaLMSwn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 13:52:43 -0500
Message-ID: <548C8AEF.1090907@southpole.se>
Date: Sat, 13 Dec 2014 19:52:31 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] rtl28xxu: swap frontend order for devices with slave
 demodulators
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se> <1418429925-16342-2-git-send-email-benjamin@southpole.se> <548BBA41.7000109@iki.fi> <548C1E53.10408@southpole.se> <548C4096.5030401@iki.fi>
In-Reply-To: <548C4096.5030401@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2014 02:35 PM, Antti Palosaari wrote:
>
>
> Do you understand that code at all?

No I can't really say I understand all the workings of the media api.

>
> Now it is:
> FE0 == (fe->id == 0) == RTL2832
> FE1 == (fe->id == 1) == MN88472
>
> you changed it to:
> FE0 == (fe->id == 0) == MN88472
> FE1 == (fe->id == 1) == RTL2832

I thought the rtl2832u_frontend_attach() actually attached the devices. 
Then the id's would have followed the frontend.


>
> Then there is:
>
> /* bypass slave demod TS through master demod */
> if (fe->id == 1 && onoff) {
>     ret = rtl2832_enable_external_ts_if(adap->fe[1]);
>     if (ret)
>         goto err;
> }
>
> After your change that code branch is taken when RTL2832 demod is 
> activated / used. Shouldn't TS bypass enabled just opposite, when 
> MN88472 is used....
>
>
> Antti
>

This intent of the patch was for better backwards compatibility with old 
software. This isn't strictly needed so consider the patch dropped.

MvH
Benjamin Larsson
