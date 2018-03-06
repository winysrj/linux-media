Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42140 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752784AbeCFR33 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 12:29:29 -0500
Date: Tue, 6 Mar 2018 14:29:23 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Mariusz Bialonczyk <manio@skyboo.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] w1: fix w1_ds2438 documentation
Message-ID: <20180306142923.6364ad2b@vento.lan>
In-Reply-To: <20180302075524.27868-1-manio@skyboo.net>
References: <20180302075524.27868-1-manio@skyboo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  2 Mar 2018 08:55:24 +0100
Mariusz Bialonczyk <manio@skyboo.net> escreveu:

> Signed-off-by: Mariusz Bialonczyk <manio@skyboo.net>
> ---
>  Documentation/w1/slaves/w1_ds2438 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/w1/slaves/w1_ds2438 b/Documentation/w1/slaves/w1_ds2438
> index b99f3674c5b4..e64f65a09387 100644
> --- a/Documentation/w1/slaves/w1_ds2438
> +++ b/Documentation/w1/slaves/w1_ds2438
> @@ -60,4 +60,4 @@ vad: general purpose A/D input (VAD)
>  vdd: battery input (VDD)
>  
>  After the voltage conversion the value is returned as decimal ASCII.
> -Note: The value is in mV, so to get a volts the value has to be divided by 10.
> +Note: To get a volts the value has to be divided by 100.

Hmm... I've no idea why you sent this to linux-media and to me...

The proper maintainer seems to be Evgeniy:

 ./scripts/get_maintainer.pl -f Documentation/w1/slaves/w1_ds2438
Evgeniy Polyakov <zbr@ioremap.net> (maintainer:W1 DALLAS'S 1-WIRE BUS)
Jonathan Corbet <corbet@lwn.net> (maintainer:DOCUMENTATION)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (commit_signer:1/1=100%)
Mariusz Bialonczyk <manio@skyboo.net> (commit_signer:1/1=100%,authored:1/1=100%,added_lines:63/63=100%)
linux-doc@vger.kernel.org (open list:DOCUMENTATION)
linux-kernel@vger.kernel.org (open list)



Thanks,
Mauro
