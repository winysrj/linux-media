Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43272 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab1AGMhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 07:37:37 -0500
Received: by iyi12 with SMTP id 12so15745006iyi.19
        for <linux-media@vger.kernel.org>; Fri, 07 Jan 2011 04:37:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D25FDBA.7070407@mulder.franken.de>
References: <4D25FDBA.7070407@mulder.franken.de>
Date: Fri, 7 Jan 2011 13:37:36 +0100
Message-ID: <AANLkTi=rdzxfRa9jKbTj=cuHQmCKFi-A6ZzBK945XJ4W@mail.gmail.com>
Subject: Re: [PATCH] Corrections to dvb-apps util/scan/dvb-c/de-neftv
From: Christoph Pfister <christophpfister@gmail.com>
To: Michael Meier <poempelfox@mulder.franken.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/1/6 Michael Meier <poempelfox@mulder.franken.de>:
> The scan config for de-neftv seems to be outdated: It is missing some
> channels, and (more importantly) has incorrect settings for some other
> channels, as their settings differ a little from the rest [*].
> The following patch fixes that (and, at least for me, allows reception
> on these channels to finally work).
>
> Signed-off-by: Michael Meier <poempelfox@mulder.franken.de>
>
> [*] src: http://www.herzomedia.de/front_content.php?idcat=126 - This
> requires a little explanation: herzomedia is not the same as neftv, but
> takes over their signal; neftv itself unfortunately doesn't provide
> proper information on symbolrate/qam used, which is why I have to resort
> to herzomedia. The 466 MHz transponder is supplemented by herzomedia, it
> is not available on neftv - I propose including it anyways, as apart
> from the additional channel they are the same.
<snip>

Applied, thanks.

Christoph
