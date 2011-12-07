Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:50554 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab1LGQ6w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Dec 2011 11:58:52 -0500
Message-ID: <4EDF9B48.1080808@linuxtv.org>
Date: Wed, 07 Dec 2011 17:58:48 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	HoP <jpetrous@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111206112153.GC17194@sirena.org.uk> <4EDE0427.2050307@linuxtv.org> <20111206141929.GE17731@opensource.wolfsonmicro.com> <4EDE2B3B.2080905@linuxtv.org> <20111207134848.GB18837@opensource.wolfsonmicro.com> <4EDF71AE.5070509@linuxtv.org> <20111207161058.GC22355@opensource.wolfsonmicro.com>
In-Reply-To: <20111207161058.GC22355@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07.12.2011 17:10, Mark Brown wrote:
> You're talking about a purely software defined thing that goes in the
> kernel - it pretty much has to be able to scale to other applications
> even if some of the implementation is left for later.  Once things like
> this get included in the kernel they become part of the ABI and having
> multiple specific things ends up being a recipie for confusion as users
> have to work out which of the options is most appropriate for their
> application.

And to repeat myself once more: No networking is to be perfomed by the
kernel in vtunerc.
