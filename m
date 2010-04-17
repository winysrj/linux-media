Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:45133 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0DQTIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 15:08:48 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1039769fgg.1
        for <linux-media@vger.kernel.org>; Sat, 17 Apr 2010 12:08:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BC9F6B8.1050302@cogweb.net>
References: <4BC8F087.3050805@cogweb.net>
	 <u2g829197381004161714z2f0b827eu824a3bcb17d2aa17@mail.gmail.com>
	 <g2w846899811004162344ib3c9223ek8bcef2df83e7f23b@mail.gmail.com>
	 <4BC96A12.2040007@cogweb.net>
	 <i2g846899811004170310s6f0a26fejace49a3886240bca@mail.gmail.com>
	 <4BC9F6B8.1050302@cogweb.net>
Date: Sat, 17 Apr 2010 21:08:46 +0200
Message-ID: <n2m846899811004171208k9113f001o36545c70fedcd6d9@mail.gmail.com>
Subject: Re: zvbi-atsc-cc device node conflict
From: HoP <jpetrous@gmail.com>
To: David Liontooth <lionteeth@cogweb.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> That's promising but no cigar:
>
> cat test-cat3.mpeg > zvbi-atsc-cc --ts
>
> just feeds the output of the cat into a file called zvbi-atsc-cc (not
> surprisingly).

Hehe. Sure, it was my mistake. Piping syntax what you tried
later is exactly what I thought :-)

>
>  cat test-cat3.mpeg | zvbi-atsc-cc --ts
>
> also doesn't work. zvbi-atsc-cc's --ts switch is designed to "Decode a DVB
> Transport Stream on stdin", so if the file created with
>
>  cat /dev/dvb/adapter0/dvr0 > test-cat3.mpeg
>
> qualifies as a DVB Transport Stream, then there's a way to pipe it to
> zvbi-atsc-cc.  How do we get the syntax for this?
>

Of course I can be wrong as I have exactly zero experiences of using
zvbi tool, but I think command line option --ts should tell that
data are not comming from dvr device but from stdin. Dunno
why it not works for you. May be it needs some additional options?

/Honza
