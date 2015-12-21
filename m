Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:51350 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbbLUPSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 10:18:18 -0500
Message-ID: <1450710545.12572.17.camel@v3.sk>
Subject: Re: [PATCH] usbtv: discard redundant video fields
From: Lubomir Rintel <lkundrak@v3.sk>
To: Nikola =?ISO-8859-1?Q?Forr=F3?= <nikola.forro@gmail.com>,
	linux-media@vger.kernel.org
Date: Mon, 21 Dec 2015 16:09:05 +0100
In-Reply-To: <20151220125717.376e7903@urna>
References: <20151220125717.376e7903@urna>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2015-12-20 at 12:57 +0100, Nikola Forró wrote:
> There are many dropped fields with some sources, leading to many
> redundant fields without counterparts. When this redundant field
> is odd, a new frame is pushed containing this odd field interleaved
> with whatever was left in the buffer, causing video artifacts.
> 
> Do not push a new frame after processing every odd field, but do it
> only after those which come after an even field.
> 
> Signed-off-by: Nikola Forró <nikola.forro@gmail.com>

Acked-by: Lubomir Rintel <lkundrak@v3.sk>

Thanks,
Lubo
