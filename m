Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53448 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933471AbeCGPOw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 10:14:52 -0500
Date: Wed, 7 Mar 2018 12:14:38 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Soeren Moch <smoch@web.de>
Cc: Andreas Regel <andreas.regel@gmx.de>,
        Manu Abraham <manu@linuxtv.org>,
        Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL RESEND] SAA716x DVB driver
Message-ID: <20180307121438.389f411c@vento.lan>
In-Reply-To: <76416aa4-0955-b10b-42ba-f24ea0bea678@web.de>
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
        <76416aa4-0955-b10b-42ba-f24ea0bea678@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi S=C3=B6ren,

Em Wed, 23 Aug 2017 11:56:50 +0200
Soeren Moch <smoch@web.de> escreveu:

> Resend this pull request. Apparently my explanation one month ago,
> why we need the userspace API of this driver in the current form [1],
> got lost.

As discussed in priv, I'm ok to merge this at staging, provided that
you add this to its TODO[1] with something like:

	* The osd/video/audio APIs should be redesigned in order to fit
	  the needs for modern embedded hardware.

In other words, once we have an API for FF devices that work for modern
embedded hardware, this driver should either be changed to work with it
or may be removed on future Kernel versions, if it becomes incompatible
with whatever DVB core changes required for it.

[1] https://github.com/s-moch/linux-saa716x/blob/for-media/drivers/staging/=
media/saa716x/TODO

I'm marking the current pull request with "Changes Requested".

Thanks,
Mauro
