Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161137Ab1FALk7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 07:40:59 -0400
Message-ID: <4DE6253F.3070202@redhat.com>
Date: Wed, 01 Jun 2011 08:40:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 2.6.40] Anysee
References: <4DBAEFC5.8080707@iki.fi> <4DC178C8.4040603@redhat.com> <4DDD780C.30205@iki.fi>
In-Reply-To: <4DDD780C.30205@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 25-05-2011 18:43, Antti Palosaari escreveu:
> Moikka Mauro,
> 
> Two new models and some fixes.
> 
> 
> The following changes since commit 87cf028f3aa1ed51fe29c36df548aa714dc7438f:
> 
>   [media] dm1105: GPIO handling added, I2C on GPIO added, LNB control through GPIO reworked (2011-05-21 11:10:28 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/anttip/media_tree.git anysee
> 
> Antti Palosaari (4):
>       anysee: return EOPNOTSUPP for unsupported I2C messages

This one is a bug fix. I'm adding it on my queue for 3.0.

A side note: you're using the stack for the I2C transfers. If the stack
buffer is used also on a URB transfer, it may fail on x86 architecture
and it will for sure fail on arm architectures, as the stack memory
is not safe for DMA transfers.

>       anysee: add support for Anysee E7 PTC
>       anysee: add support for Anysee E7 PS2
>       anysee: style issues, comments, etc.
> 
>  drivers/media/dvb/dvb-usb/anysee.c |   86 ++++++++++++++++++++++++++----------
>  drivers/media/dvb/dvb-usb/anysee.h |   16 ++++---
>  2 files changed, 71 insertions(+), 31 deletions(-)
> 

Cheers,
Mauro
