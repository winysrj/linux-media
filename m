Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59802 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab2DASRA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 14:17:00 -0400
Message-ID: <4F789B9A.8000501@iki.fi>
Date: Sun, 01 Apr 2012 21:16:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH][GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 i2c read fix
References: <4F75A7FE.8090405@iki.fi> <201204011915.47265.hfvogt@gmx.net> <4F788F49.202@iki.fi> <201204012011.29830.hfvogt@gmx.net>
In-Reply-To: <201204012011.29830.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.04.2012 21:11, Hans-Frieder Vogt wrote:
> attached is the i2c read fix (necessary e.g. for mxl5007t tuner, because it
> sends a 2 bytes for a read request, thus msg[0].len != msg[1].len).
>
> Enable i2c read requests.
>
> Signed-off-by: Hans-Frieder Vogt<hfvogt@gmx.net>

Applied, thank you!

http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental

regards
Antti
-- 
http://palosaari.fi/
