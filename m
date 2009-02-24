Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:65513 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbZBXP50 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 10:57:26 -0500
Received: by fxm11 with SMTP id 11so2896166fxm.13
        for <linux-media@vger.kernel.org>; Tue, 24 Feb 2009 07:57:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090224153514.090816655@gentoo.org>
References: <20090224153514.090816655@gentoo.org>
Date: Tue, 24 Feb 2009 16:57:22 +0100
Message-ID: <617be8890902240757q11a56affo6e07a95c1fa3ce00@mail.gmail.com>
Subject: Re: [patch 0/2] Add support for DVB part of Avermedia A700 DVB-S
	cards
From: Eduard Huguet <eduardhc@gmail.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That's great, I really hope your patches finally find their way into
the main tree. I'm just tired of manually downloading & patching HG
sources everytime I needed to recompile the kernel...

Anyway, I've been using the card for some time now (almost a year,
IIRC...) and it runs very well in DVB-S mode. I was using your
a700_full_xxxx patches, I hope you still leave them available until
these patches are merged...

Best regards,
  Eduard



2009/2/24 Matthias Schwarzott <zzam@gentoo.org>:
> Hello all!
>
> These patches finally add support for the DVB part of the
> Avermedia A700 DVB-S cards.
>
> The first adds the tuner-driver for the Zarlink zl10036.
> The second adds the glue code to saa7134-dvb to use it.
>
> After having them lying around a long time I now did a
> bit of cleanup and send them out now.
>
> Regards
> Matthias
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
