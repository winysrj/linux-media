Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:48923 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbaLHU7L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 15:59:11 -0500
Message-ID: <5486111D.2000800@southpole.se>
Date: Mon, 08 Dec 2014 21:59:09 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] mn88472: fix firmware downloading
References: <1418070667-13349-1-git-send-email-benjamin@southpole.se> <5486104D.8090601@iki.fi>
In-Reply-To: <5486104D.8090601@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/08/2014 09:55 PM, Antti Palosaari wrote:
> Moikka!
>
> But that patch is rather useless :] Only thing needed is to change 
> existing value in file drivers/media/usb/dvb-usb-v2/rtl28xxu.c :
> mn88472_config.i2c_wr_max = 22,
> ... and that leaves room for use even smaller values if there is an 
> I2C adapter which cannot write even 17 bytes.
>
> 2nd thing is to add comment mn88472.h to specify that max limit and 
> that's all.
>
> regards
> Antti

Ok, I'll do that.

MvH
Benjamin Larsson
