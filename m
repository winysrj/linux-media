Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35677 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbaGHF6U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 01:58:20 -0400
Received: from 85-23-164-97.bb.dnainternet.fi ([85.23.164.97] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1X4OPy-0006rc-Od
	for linux-media@vger.kernel.org; Tue, 08 Jul 2014 08:58:18 +0300
Message-ID: <53BB887A.5030505@iki.fi>
Date: Tue, 08 Jul 2014 08:58:18 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL 3.16] tda10071 fixes
References: <53BB87C2.9070501@iki.fi>
In-Reply-To: <53BB87C2.9070501@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are not very critical and all are old, so better to pull for 3.17 
as it is now 3.16-rc4...

regards
Antti

On 07/08/2014 08:55 AM, Antti Palosaari wrote:
> The following changes since commit
> 13936af3d2f04f173a83cc050dbc4b20d8562b81:
>
>    [media] saa7134: use unlocked_ioctl instead of ioctl (2014-06-19
> 13:14:51 -0300)
>
> are available in the git repository at:
>
>    git://linuxtv.org/anttip/media_tree.git tda10071
>
> for you to fetch changes up to c1154dfb51a9628cc52ece398343ca775d9e0c43:
>
>    tda10071: fix returned symbol rate calculation (2014-07-08 08:51:47
> +0300)
>
> ----------------------------------------------------------------
> Antti Palosaari (4):
>        tda10071: force modulation to QPSK on DVB-S
>        tda10071: add missing DVB-S2/PSK-8 FEC AUTO
>        tda10071: fix spec inversion reporting
>        tda10071: fix returned symbol rate calculation
>
>   drivers/media/dvb-frontends/tda10071.c      | 12 ++++++++----
>   drivers/media/dvb-frontends/tda10071_priv.h |  1 +
>   2 files changed, 9 insertions(+), 4 deletions(-)
>

-- 
http://palosaari.fi/
