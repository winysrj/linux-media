Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1EDQDa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 12:03:30 -0400
Message-ID: <4DC178C8.4040603@redhat.com>
Date: Wed, 04 May 2011 13:03:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 2.6.40] Anysee
References: <4DBAEFC5.8080707@iki.fi>
In-Reply-To: <4DBAEFC5.8080707@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-04-2011 14:05, Antti Palosaari escreveu:
> Moikka Mauro,
> 
> PULL following patches for the 2.6.40.
> 
> This basically adds support for two Anysee satellite models:
> 1. E30 S2 Plus
> 2. E7 S2
> 
> 
> t. Antti
> 
> The following changes since commit f5bc5d1d4730bce69fbfdc8949ff50b49c70d934:
> 
>   anysee: add more info about known board configs (2011-04-13 02:17:11 +0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/anttip/media_tree.git anysee
> 
> Antti Palosaari (3):
>       cx24116: add config option to split firmware download
>       anysee: add support for Anysee E30 S2 Plus
>       anysee: add support for Anysee E7 S2

As I said you on irc, at cx24116, please add a logic to explicitly check if
I2C size is equal to zero. While your logic works, it is tricky, and having
a more readable code at the expense of something like:
	if (i2c_max == 0)
		i2c_max = 65535;

seems to be the right thing to do.

Thanks,
Mauro.
