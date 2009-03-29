Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42161 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbZC2Kk2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 06:40:28 -0400
Message-ID: <49CF5013.70901@iki.fi>
Date: Sun, 29 Mar 2009 13:40:19 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add AVerMedia A310 USB IDs to CE6230 driver.
References: <b0bb99640903281936u43ba9a84l6cfa5c8d3d00de0e@mail.gmail.com>
In-Reply-To: <b0bb99640903281936u43ba9a84l6cfa5c8d3d00de0e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello

Juan Jesús García de Soria Lucena wrote:
> El día 28 de marzo de 2009 22:05, Mauro Carvalho Chehab
> <mchehab@infradead.org> escribió:
>> So, please send the patch you did for analysis. Please submit it as explained at [1].
>>
>> [1] http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches
> 
> Add AVerMedia A310 USB IDs to CE6230 driver.
> 
> From: Juan Jesús García de Soria Lucena <skandalfo@gmail.com>
> 
> The CE6230 DVB USB driver works correctly for the AVerMedia A310 USB2.0
> DVB-T tuner. Add the required USB ID's and hardware names so that the
> driver will handle it.
> 
> Priority: normal
> 
> Signed-off-by: Juan Jesús García de Soria Lucena <skandalfo@gmail.com>
> 
> diff -r b1596c6517c9 -r 71dd4cff4eb6 linux/drivers/media/dvb/dvb-usb/ce6230.c

Thank you. Patch looks 100% correct and good for me.

Mauro, should I pick up and add this my devel tree and PULL-request or 
is there now patchwork which handles this? Current procedure is not 
clear for me...

regards
Antti
-- 
http://palosaari.fi/
