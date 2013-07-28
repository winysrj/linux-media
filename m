Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:37660 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab3G1IEa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jul 2013 04:04:30 -0400
Message-ID: <51F4D08C.4040605@schinagl.nl>
Date: Sun, 28 Jul 2013 10:04:28 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Franz Schrober <franzschrober@yahoo.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kaffeine-user@lists.sourceforge.net"
	<kaffeine-user@lists.sourceforge.net>,
	"pkg-kde-extras@lists.alioth.debian.org"
	<pkg-kde-extras@lists.alioth.debian.org>, sven@narfation.org
Subject: Re: de-Primacom initial tuning data doesn't work anymore
References: <1371910047.2617.YahooMailNeo@web171902.mail.ir2.yahoo.com> <1374921429.93450.YahooMailNeo@web171902.mail.ir2.yahoo.com>
In-Reply-To: <1374921429.93450.YahooMailNeo@web171902.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I completly missed that mail somehow, appologies, a CC to me is always 
helpfull ;)

Next time it would be preferred if you send a patch instead of a link. 
It would have been even better if Sven submittted said patch so we could 
have committed it to git much earlier!

Anyhow, pushed to git(hub) as edc0bc3f04b715f2c882343e4d4fdf94e7cc1e29

Oliver

On 27-07-13 12:37, Franz Schrober wrote:
> bump
>
>
>
> ----- Ursprüngliche Message -----
> Von: Franz Schrober <franzschrober@yahoo.de>
> An: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>; "kaffeine-user@lists.sourceforge.net" <kaffeine-user@lists.sourceforge.net>; "pkg-kde-extras@lists.alioth.debian.org" <pkg-kde-extras@lists.alioth.debian.org>
> CC:
> Gesendet: 16:07 Samstag, 22.Juni 2013
> Betreff: de-Primacom initial tuning data doesn't work anymore
>
> Hi,
>
> I wanted to watch TV today with kaffeine 1.2.2-2 from debian and noticed that it didn't work anymore. Also scans even after the update of the initial tuning data didn't show all tv stations. Just replacing the entry for dvb-c/de-Primacom in ~/.kde/share/apps/kaffeine/scanfile.dvb with the one from http://narfation.org/misc/dvbc/de-Primacom fixed the problem for me after the next scan for tv stations.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

