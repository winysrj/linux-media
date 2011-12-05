Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46828 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932318Ab1LEPPF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Dec 2011 10:15:05 -0500
Date: Mon, 5 Dec 2011 15:16:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: HoP <jpetrous@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111205151643.0c06eddc@lxorguk.ukuu.org.uk>
In-Reply-To: <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com>
	<4EDC9B17.2080701@gmail.com>
	<CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> You know - I'm a bit confused. Somebody are pointing on double
> data copying (userspace networked daemon -> kernel -> application)
> issue and another one warn me to not start network connection
> from the kernel. But if it works for NFS or CIFS then it should not
> be so weaky, isn't it?

And then you want to add multicast, or SSL or some other transport layer,
and so on. You can do it - but in the case of DVB it's really probably
not the overall way to go.

> What exactly vtuner aproach does so hackish (other then exposing
> DVB internals, what is every time made if virtualization support is developing)?

Exposing DVB internals is also not good - it creates an API which locks
out future trivial changes to that API because it might break your
stuff. Also you are trying to fake distributed network in the wrong place
so faking basically synchronous interfaces with undefined network
behaviour and time lines.

> The code itself no need to patch any line of vanilla kernel source, it even
> doesn't change any processing of the rest of kernel, it is very simple
> driver/code/whatever.

That's not a measure of whether something is a good idea, more of the
cleanness of the core code.

Fix the userspace bits that need fixing, or use ones that don't - in the
longer term that will be a bigger win by far.

Alan
