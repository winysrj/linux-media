Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43297 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaL3H4B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 02:56:01 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so23566710wiv.7
        for <linux-media@vger.kernel.org>; Mon, 29 Dec 2014 23:56:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54A1B4FD.70006@cogweb.net>
References: <54A1B4FD.70006@cogweb.net>
Date: Tue, 30 Dec 2014 09:55:59 +0200
Message-ID: <CAAZRmGxoOTf9f4gq05RgbcD44tmiySMXo-_ZHtBQX0pw6ZXPUA@mail.gmail.com>
Subject: Re: dvbv5-scan needs which channel file?
From: Olli Salonen <olli.salonen@iki.fi>
To: David Liontooth <lionteeth@cogweb.net>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello David,

Coincidentally I was just yesterday working with dvbv5-scan and the
initial scan files. dvbv5-scan expects the initial scan files in the
new DVBV5 format. w_scan is not producing results in this format.

The scan tables at
http://git.linuxtv.org/cgit.cgi/dtv-scan-tables.git/ are in the new
format. Some of them are a bit outdated though (send in a patch if you
can update it for your area).

The v4l-utils package also includes tools to convert between the old
and the new format.

Cheers,
-olli


On 29 December 2014 at 22:09, David Liontooth <lionteeth@cogweb.net> wrote:
>
> Greetings --
>
> How do you actually use dvbv5-scan? It seems to require some kind of input
> file but there is no man page and the --help screen doesn't say anything
> about it.
>
> Could we document this? I tried
>
> $ dvbv5-scan
> Usage: dvbv5-scan [OPTION...] <initial file>
> scan DVB services using the channel file
>
> What is "the channel file"? Maybe the channels.conf file? (I created mine
> using "w_scan -ft -A3 -X -cUS -o7 -a /dev/dvb/adapter0/")
>
> $ dvbv5-scan /etc/channels.conf
> ERROR key/value without a channel group while parsing line 1 of
> /etc/channels.conf
>
> So it knows what it wants -- but what is it? Or is this a matter of dvb
> versions, and my /etc/channels.conf is in the older format?
>
> Very mysterious.
>
> Cheers,
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
