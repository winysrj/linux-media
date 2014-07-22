Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:57564 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbaGVP7f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 11:59:35 -0400
Message-ID: <53CE8A5F.3000506@gentoo.org>
Date: Tue, 22 Jul 2014 17:59:27 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Luis Alves <ljalvs@gmail.com>, linux-media@vger.kernel.org
CC: crope@iki.fi
Subject: Re: [PATCH] si2157: Fix DVB-C bandwidth.
References: <1406027388-10336-1-git-send-email-ljalvs@gmail.com>
In-Reply-To: <1406027388-10336-1-git-send-email-ljalvs@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.07.2014 13:09, Luis Alves wrote:
> This patch fixes DVB-C reception.
> Without setting the bandwidth to 8MHz the received stream gets corrupted.


Hi Luis,
I also wonder if some code should default to bandwidth of 8MHz if none
is set.

But then I grepped for it and found code in
drivers/media/dvb-core/dvb_frontend.c to calculate the bandwidth
depending on delivery system and symbol rate.
So if this works, the bandwidth should already be correct.

Regards
Matthias

