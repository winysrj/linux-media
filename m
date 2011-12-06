Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:51489 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933269Ab1LFMBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Dec 2011 07:01:08 -0500
Message-ID: <4EDE0400.1070304@linuxtv.org>
Date: Tue, 06 Dec 2011 13:01:04 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	HoP <jpetrous@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111205205554.2caeb496@lxorguk.ukuu.org.uk> <4EDD3583.30405@linuxtv.org> <20111206111829.GB17194@sirena.org.uk>
In-Reply-To: <20111206111829.GB17194@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06.12.2011 12:18, Mark Brown wrote:
> On Mon, Dec 05, 2011 at 10:20:03PM +0100, Andreas Oberritter wrote:
>> On 05.12.2011 21:55, Alan Cox wrote:
>>> The USB case is quite different because your latency is very tightly
>>> bounded, your dead device state is rigidly defined, and your loss of
>>> device is accurately and immediately signalled.
> 
>>> Quite different.
> 
>> How can usbip work if networking and usb are so different and what's so
>> different between vtunerc and usbip, that made it possible to put usbip
>> into drivers/staging?
> 
> USB-IP is a hack that will only work well on a tightly bounded set of
> networks - if you run it over a lightly loaded local network it can
> work adequately.  This starts to break down as you vary the network
> configuration.

I see. So it has problems that vtunerc doesn't have.
