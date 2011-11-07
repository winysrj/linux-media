Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45559 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1KGUGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 15:06:34 -0500
Received: by ggnb2 with SMTP id b2so5642589ggn.19
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2011 12:06:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EB8383F.2000201@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
	<4EB7F709.2050503@gmail.com>
	<4EB802A0.7030600@gmail.com>
	<4EB8383F.2000201@gmail.com>
Date: Mon, 7 Nov 2011 15:06:33 -0500
Message-ID: <CAGoCfixyrz5S-4SQCRKNw4pC8_eRH=FD3MR-LoXidga_GtRM8A@mail.gmail.com>
Subject: Re: [PATCH 00/13] Remaining coding style clean up of AS102 driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: gennarone@gmail.com, linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 7, 2011 at 2:57 PM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> My knowledge about this driver is rather limited, in case of any issues I
> guess it's best to ask Devin directly.

Part of the problem here is that the as102 chip is a fully
programmable part, and as a result the firmware may differ on a
product-by-product basis.  In fact, the engineer at Abilis told me
outright that the firmware provided for the PCTV device isn't
appropriate for the Elgato board, but it worked "good enough" for the
user.

In other words, users are free to try the firmware prepared for PCTV
against other devices, but be prepared for it to not be optimized
properly for that hardware design (meaning tuning quality issues or
perhaps not working at all), and if it destroys your board then don't
come crying to me.

The only way to know if the same firmware is being used would be to do
a USB capture, write a decoder which allows you to extract the
firmware being uploaded, and compare it against the PCTV blob.  And if
it doesn't match, there's no real way of knowing whether the delta is
significant.

Also worth noting that the only firmware we have the legal right to
freely redistribute is the one needed by the PCTV device.  Even if
somebody extracts another firmware blob from a USB trace, there are no
legal rights to redistribute it (meaning a firmware extract script
written to work against the Windows driver binary would be required).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
